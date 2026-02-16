# Cloud Backup Feature

## Overview
The Cloud Backup feature allows users to backup and restore their billiard results data using their personal cloud storage:
- **iOS**: iCloud Drive
- **Android**: Google Drive

This approach provides automatic cloud storage without requiring a dedicated backend service.

## Features

✅ **Manual Backup** - Users can backup their data on demand  
✅ **Manual Restore** - Users can restore from cloud backup  
✅ **Last Backup Timestamp** - Shows when data was last backed up  
✅ **Platform-Native** - Uses iCloud on iOS, Google Drive on Android  
✅ **Privacy-Focused** - Data stays in user's personal cloud account  
✅ **JSON Export** - Human-readable backup format  

## How It Works

### Data Export (Backup)
1. User taps "Backup to Cloud" in Settings → Cloud Backup
2. App exports all data to JSON format:
   - User settings
   - All results
   - Classification levels  
   - Discipline order
3. JSON is saved to:
   - **iOS**: iCloud Drive Documents folder (`billiard_results_backup.json`)
   - **Android**: Google Drive App Data folder (`billiard_results_backup.json`)
4. Last backup timestamp is updated in user settings

### Data Import (Restore)
1. User taps "Restore from Cloud" in Settings → Cloud Backup
2. Confirmation dialog warns data will be replaced
3. App downloads JSON from cloud storage
4. Database is cleared and repopulated with backup data
5. App refreshes to show restored data

## iOS Setup (iCloud)

### Required Configuration

#### 1. Enable iCloud Capability in Xcode
1. Open `ios/Runner.xcworkspace` in Xcode
2. Select Runner target → Signing & Capabilities
3. Click "+ Capability" → iCloud
4. Enable "iCloud Documents"

#### 2. Entitlements File
The `ios/Runner/Runner.entitlements` file has been created with:
```xml
<key>com.apple.developer.icloud-services</key>
<array>
    <string>CloudDocuments</string>
</array>
```

#### 3. Platform Channel
The `AppDelegate.swift` handles:
- `saveToICloud` - Save backup to iCloud Drive
- `loadFromICloud` - Load backup from iCloud Drive  
- `fileExists` - Check if backup exists
- `getFileModifiedDate` - Get last backup date

### User Requirements (iOS)
- Signed in to iCloud on device
- iCloud Drive enabled in Settings
- Sufficient iCloud storage space

## Android Setup (Google Drive)

### Required Configuration

#### 1. Google Sign-In Setup
Add to `android/app/build.gradle`:
```gradle
dependencies {
    implementation 'com.google.android.gms:play-services-auth:20.7.0'
}
```

#### 2. OAuth Client ID
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create/select project
3. Enable Google Drive API
4. Create OAuth 2.0 Client ID for Android app
5. Add SHA-1 certificate fingerprint

#### 3. Permissions
Already added to `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

### User Requirements (Android)
- Google account on device
- Google Play Services installed
- Internet connection for initial sign-in
- Sufficient Google Drive storage space

## Technical Implementation

### Database Export Format
```json
{
  "version": 1,
  "exportDate": "2026-02-16T10:30:00.000Z",
  "userSettings": {
    "name": "John Doe",
    "season_start_day": 1,
    "season_start_month": 9,
    "language": "en"
  },
  "results": [
    {
      "discipline": "Free game - Small table",
      "date": "2026-01-15T00:00:00.000Z",
      "points_made": 45,
      "innings": 30,
      "highest_run": 8,
      ...
    }
  ],
  "classificationLevels": [...],
  "disciplineOrder": [...]
}
```

### Service Architecture

#### `CloudBackupService` (`lib/services/cloud_backup_service.dart`)
- Platform detection (iOS vs Android)
- Backup orchestration
- Restore orchestration
- Google Sign-In management

#### `DatabaseService` Export Methods
- `exportData()` - Export all database data to Map
- `importData(Map, merge: bool)` - Import data from Map

#### Platform Channels (iOS)
- Method channel: `com.billiardresults.app/icloud`
- Swift implementation in `AppDelegate.swift`

#### Google Drive API (Android)
- Uses `googleapis` package
- App Data folder (hidden from user)
- Automatic auth token management

## UI Components

### Settings Screen Additions
Located in Settings → Cloud Backup section:

1. **Last Backup Timestamp** - Shows when data was last backed up
2. **Backup to Cloud** - Button with platform-specific subtitle
3. **Restore from Cloud** - Button with confirmation dialog

### User Flow

**Backup:**
```
Tap "Backup to Cloud" 
  → Loading dialog
  → Success/Error message
  → Timestamp updated
```

**Restore:**
```
Tap "Restore from Cloud"
  → Confirmation dialog
  → Loading dialog  
  → Success/Error message
  → Data refreshed
```

## Error Handling

### Common Errors

| Error | Cause | Solution |
|-------|-------|----------|
| "iCloud not available" | Not signed in to iCloud | Sign in to iCloud in device Settings |
| "Google Sign-In cancelled" | User cancelled sign-in | Try again and complete sign-in |
| "No backup found" | No previous backup exists | Create a backup first |
| "Backup failed" | Network or permission issue | Check internet and permissions |

### Error Messages
All error messages are localized and user-friendly, showing:
- What went wrong
- Technical error (for support)
- Suggestion for resolution

## Testing

### Manual Testing Checklist

#### iOS
- [ ] Backup creates file in iCloud Drive
- [ ] Restore loads data from iCloud Drive
- [ ] Last backup timestamp updates
- [ ] Works without internet (after initial iCloud setup)
- [ ] Error when not signed in to iCloud

#### Android
- [ ] Google Sign-In flow works
- [ ] Backup uploads to Google Drive App Data
- [ ] Restore downloads from Google Drive
- [ ] Last backup timestamp updates
- [ ] Error when no Google account

#### Cross-Platform
- [ ] Large dataset backup (1000+ results)
- [ ] Restore replaces all data correctly
- [ ] UI shows correct platform messages
- [ ] All localized strings work (EN, NL, FR)

### Automated Testing
Currently, cloud backup is tested manually. Future considerations:
- Mock cloud storage for unit tests
- Integration tests with test Google/Apple accounts

## Limitations

⚠️ **No Auto-Sync** - Backups are manual, not automatic  
⚠️ **No Conflict Resolution** - Restore always replaces all data  
⚠️ **Single Backup** - Only latest backup is kept (no versioning)  
⚠️ **Platform-Specific** - Cannot transfer backup between iOS and Android  
⚠️ **Network Required** - Android requires internet for Google Drive access  

## Future Enhancements

Potential improvements for future versions:
1. **Auto-Backup** - Automatic backup after X results or daily/weekly
2. **Backup Versioning** - Keep multiple backup versions
3. **Merge Option** - Choose to merge instead of replace
4. **Backup Encryption** - Encrypt sensitive data
5. **Cross-Platform** - Share backups between iOS and Android
6. **Backup Scheduling** - User-configurable auto-backup intervals

## Troubleshooting

### iOS iCloud Issues

**Issue**: "iCloud not available" error  
**Fix**: 
1. Go to Settings → [Your Name] → iCloud
2. Enable iCloud Drive
3. Make sure app has iCloud access

**Issue**: Backup not syncing to other devices  
**Note**: This is expected - iCloud Documents may not sync immediately

### Android Google Drive Issues

**Issue**: Google Sign-In fails  
**Fix**:
1. Check internet connection
2. Verify Google Play Services is updated
3. Try signing out and back in to Google account

**Issue**: "Insufficient permissions" error  
**Fix**:
1. Uninstall and reinstall app
2. Grant all requested permissions during sign-in

## Security & Privacy

✅ **Local Cloud Storage** - Data stays in user's personal cloud account  
✅ **No Third-Party Access** - No external servers or databases  
✅ **Platform Encryption** - iCloud and Google Drive provide encryption  
✅ **App Data Folder** - Android backup hidden from user's Drive  
✅ **User Control** - All backups/restores are user-initiated  

## Support

For issues with cloud backup:
1. Check device cloud storage settings
2. Verify cloud storage quota availability
3. Check app permissions
4. Review error messages for specific guidance
5. Contact support with error details if persistent

---

**Note**: This feature requires proper setup of iCloud capabilities in Xcode for iOS, and Google Sign-In configuration for Android before it will work in production builds.
