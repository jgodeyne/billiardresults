/// Auto-backup frequency options
enum AutoBackupFrequency {
  disabled,
  afterResults,
  daily,
  weekly;

  String toValue() => name;

  static AutoBackupFrequency fromValue(String value) {
    return AutoBackupFrequency.values.firstWhere(
      (e) => e.name == value,
      orElse: () => AutoBackupFrequency.disabled,
    );
  }
}

/// User settings and profile information
class UserSettings {
  final int? id;
  final String name;
  final int seasonStartDay; // 1-31
  final int seasonStartMonth; // 1-12
  final String language; // 'en', 'nl', 'fr'
  final DateTime? lastBackupDate; // When data was last backed up to cloud
  final bool autoBackupEnabled; // Whether auto-backup is enabled
  final AutoBackupFrequency autoBackupFrequency; // How often to auto-backup
  final int autoBackupResultCount; // Number of results before auto-backup (for afterResults mode)
  final int resultCountSinceBackup; // Tracks results added since last backup

  UserSettings({
    this.id,
    required this.name,
    required this.seasonStartDay,
    required this.seasonStartMonth,
    required this.language,
    this.lastBackupDate,
    this.autoBackupEnabled = false,
    this.autoBackupFrequency = AutoBackupFrequency.disabled,
    this.autoBackupResultCount = 10,
    this.resultCountSinceBackup = 0,
  });

  /// Convert to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'season_start_day': seasonStartDay,
      'season_start_month': seasonStartMonth,
      'language': language,
      'last_backup_date': lastBackupDate?.toIso8601String(),
      'auto_backup_enabled': autoBackupEnabled ? 1 : 0,
      'auto_backup_frequency': autoBackupFrequency.toValue(),
      'auto_backup_result_count': autoBackupResultCount,
      'result_count_since_backup': resultCountSinceBackup,
    };
  }

  /// Create from database Map
  factory UserSettings.fromMap(Map<String, dynamic> map) {
    return UserSettings(
      id: map['id'] as int?,
      name: map['name'] as String,
      seasonStartDay: map['season_start_day'] as int,
      seasonStartMonth: map['season_start_month'] as int,
      language: map['language'] as String,
      lastBackupDate: map['last_backup_date'] != null 
          ? DateTime.parse(map['last_backup_date'] as String)
          : null,
      autoBackupEnabled: (map['auto_backup_enabled'] as int?) == 1,
      autoBackupFrequency: AutoBackupFrequency.fromValue(
        map['auto_backup_frequency'] as String? ?? 'disabled'
      ),
      autoBackupResultCount: map['auto_backup_result_count'] as int? ?? 10,
      resultCountSinceBackup: map['result_count_since_backup'] as int? ?? 0,
    );
  }

  /// Copy with modifications
  UserSettings copyWith({  
    int? id,
    String? name,
    int? seasonStartDay,
    int? seasonStartMonth,
    String? language,
    DateTime? lastBackupDate,
    bool? autoBackupEnabled,
    AutoBackupFrequency? autoBackupFrequency,
    int? autoBackupResultCount,
    int? resultCountSinceBackup,
  }) {
    return UserSettings(
      id: id ?? this.id,
      name: name ?? this.name,
      seasonStartDay: seasonStartDay ?? this.seasonStartDay,
      seasonStartMonth: seasonStartMonth ?? this.seasonStartMonth,
      language: language ?? this.language,
      lastBackupDate: lastBackupDate ?? this.lastBackupDate,
      autoBackupEnabled: autoBackupEnabled ?? this.autoBackupEnabled,
      autoBackupFrequency: autoBackupFrequency ?? this.autoBackupFrequency,
      autoBackupResultCount: autoBackupResultCount ?? this.autoBackupResultCount,
      resultCountSinceBackup: resultCountSinceBackup ?? this.resultCountSinceBackup,
    );
  }

  @override
  String toString() {
    return 'UserSettings{id: $id, name: $name, seasonStart: $seasonStartMonth/$seasonStartDay, language: $language}';
  }
}
