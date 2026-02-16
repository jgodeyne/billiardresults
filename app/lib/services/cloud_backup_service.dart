import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'database_service.dart';

class CloudBackupService {
  static const String _backupFileName = 'billiard_results_backup.json';
  static const String _iCloudChannel = 'com.billiardresults.app/icloud';
  static const MethodChannel _platform = MethodChannel(_iCloudChannel);

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [drive.DriveApi.driveAppdataScope],
  );

  /// Backup data to cloud storage (iCloud for iOS, Google Drive for Android)
  Future<void> backupToCloud() async {
    // Export data from database
    final data = await DatabaseService.instance.exportData();
    final jsonString = jsonEncode(data);

    if (Platform.isIOS) {
      await _backupToICloud(jsonString);
    } else if (Platform.isAndroid) {
      await _backupToGoogleDrive(jsonString);
    } else {
      throw UnsupportedError('Cloud backup not supported on this platform');
    }

    // Update last backup timestamp
    final settings = await DatabaseService.instance.getUserSettings();
    if (settings != null) {
      final updated = settings.copyWith(lastBackupDate: DateTime.now());
      await DatabaseService.instance.saveUserSettings(updated);
    }
  }

  /// Restore data from cloud storage
  Future<void> restoreFromCloud({bool merge = false}) async {
    String? jsonString;

    if (Platform.isIOS) {
      jsonString = await _restoreFromICloud();
    } else if (Platform.isAndroid) {
      jsonString = await _restoreFromGoogleDrive();
    } else {
      throw UnsupportedError('Cloud restore not supported on this platform');
    }

    if (jsonString == null || jsonString.isEmpty) {
      throw Exception('No backup found in cloud storage');
    }

    // Import data into database
    final data = jsonDecode(jsonString) as Map<String, dynamic>;
    await DatabaseService.instance.importData(data, merge: merge);
  }

  /// Check if a backup exists in cloud storage
  Future<bool> hasBackup() async {
    try {
      if (Platform.isIOS) {
        return await _hasICloudBackup();
      } else if (Platform.isAndroid) {
        return await _hasGoogleDriveBackup();
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Get the date of the last cloud backup
  Future<DateTime?> getCloudBackupDate() async {
    try {
      if (Platform.isIOS) {
        return await _getICloudBackupDate();
      } else if (Platform.isAndroid) {
        return await _getGoogleDriveBackupDate();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // ==================== iOS iCloud Methods ====================

  Future<void> _backupToICloud(String jsonString) async {
    try {
      await _platform.invokeMethod('saveToICloud', {
        'fileName': _backupFileName,
        'content': jsonString,
      });
    } on PlatformException catch (e) {
      throw Exception('Failed to backup to iCloud: ${e.message}');
    }
  }

  Future<String?> _restoreFromICloud() async {
    try {
      final result = await _platform.invokeMethod('loadFromICloud', {
        'fileName': _backupFileName,
      });
      return result as String?;
    } on PlatformException catch (e) {
      throw Exception('Failed to restore from iCloud: ${e.message}');
    }
  }

  Future<bool> _hasICloudBackup() async {
    try {
      final result = await _platform.invokeMethod('fileExists', {
        'fileName': _backupFileName,
      });
      return result as bool? ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<DateTime?> _getICloudBackupDate() async {
    try {
      final result = await _platform.invokeMethod('getFileModifiedDate', {
        'fileName': _backupFileName,
      });
      if (result != null) {
        return DateTime.parse(result as String);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // ==================== Android Google Drive Methods ====================

  Future<void> _backupToGoogleDrive(String jsonString) async {
    try {
      // Sign in to Google
      final account = await _googleSignIn.signIn();
      if (account == null) {
        throw Exception('Google Sign-In cancelled');
      }

      // Get auth headers
      final authHeaders = await account.authHeaders;
      final authenticateClient = _GoogleAuthClient(authHeaders);
      final driveApi = drive.DriveApi(authenticateClient);

      // Check if backup file already exists
      final fileList = await driveApi.files.list(
        spaces: 'appDataFolder',
        q: "name='$_backupFileName'",
        $fields: 'files(id, name)',
      );

      final bytes = utf8.encode(jsonString);
      final media = drive.Media(Stream.value(bytes), bytes.length);

      if (fileList.files != null && fileList.files!.isNotEmpty) {
        // Update existing file
        final fileId = fileList.files!.first.id!;
        await driveApi.files.update(
          drive.File(),
          fileId,
          uploadMedia: media,
        );
      } else {
        // Create new file
        final driveFile = drive.File()
          ..name = _backupFileName
          ..parents = ['appDataFolder'];

        await driveApi.files.create(
          driveFile,
          uploadMedia: media,
        );
      }

      // Save sign-in state
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('google_signed_in', true);
    } catch (e) {
      throw Exception('Failed to backup to Google Drive: $e');
    }
  }

  Future<String?> _restoreFromGoogleDrive() async {
    try {
      // Try to sign in silently first
      GoogleSignInAccount? account = await _googleSignIn.signInSilently();
      
      // If silent sign-in fails, do interactive sign-in
      account ??= await _googleSignIn.signIn();
      
      if (account == null) {
        throw Exception('Google Sign-In cancelled');
      }

      final authHeaders = await account.authHeaders;
      final authenticateClient = _GoogleAuthClient(authHeaders);
      final driveApi = drive.DriveApi(authenticateClient);

      // Find the backup file
      final fileList = await driveApi.files.list(
        spaces: 'appDataFolder',
        q: "name='$_backupFileName'",
        $fields: 'files(id, name)',
      );

      if (fileList.files == null || fileList.files!.isEmpty) {
        return null;
      }

      final fileId = fileList.files!.first.id!;
      
      // Download file
      final media = await driveApi.files.get(
        fileId,
        downloadOptions: drive.DownloadOptions.fullMedia,
      ) as drive.Media;

      final List<int> dataStore = [];
      await for (var chunk in media.stream) {
        dataStore.addAll(chunk);
      }

      return utf8.decode(dataStore);
    } catch (e) {
      throw Exception('Failed to restore from Google Drive: $e');
    }
  }

  Future<bool> _hasGoogleDriveBackup() async {
    try {
      GoogleSignInAccount? account = await _googleSignIn.signInSilently();
      account ??= await _googleSignIn.signIn();
      
      if (account == null) return false;

      final authHeaders = await account.authHeaders;
      final authenticateClient = _GoogleAuthClient(authHeaders);
      final driveApi = drive.DriveApi(authenticateClient);

      final fileList = await driveApi.files.list(
        spaces: 'appDataFolder',
        q: "name='$_backupFileName'",
        $fields: 'files(id)',
      );

      return fileList.files != null && fileList.files!.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<DateTime?> _getGoogleDriveBackupDate() async {
    try {
      GoogleSignInAccount? account = await _googleSignIn.signInSilently();
      account ??= await _googleSignIn.signIn();
      
      if (account == null) return null;

      final authHeaders = await account.authHeaders;
      final authenticateClient = _GoogleAuthClient(authHeaders);
      final driveApi = drive.DriveApi(authenticateClient);

      final fileList = await driveApi.files.list(
        spaces: 'appDataFolder',
        q: "name='$_backupFileName'",
        $fields: 'files(id, modifiedTime)',
      );

      if (fileList.files != null && fileList.files!.isNotEmpty) {
        return fileList.files!.first.modifiedTime;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Sign out from Google Drive
  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('google_signed_in');
  }
}

/// HTTP client that adds Google auth headers to requests
class _GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  _GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}
