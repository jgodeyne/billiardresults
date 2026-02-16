/// User settings and profile information
class UserSettings {
  final int? id;
  final String name;
  final int seasonStartDay; // 1-31
  final int seasonStartMonth; // 1-12
  final String language; // 'en', 'nl', 'fr'
  final DateTime? lastBackupDate; // When data was last backed up to cloud

  UserSettings({
    this.id,
    required this.name,
    required this.seasonStartDay,
    required this.seasonStartMonth,
    required this.language,
    this.lastBackupDate,
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
  }) {
    return UserSettings(
      id: id ?? this.id,
      name: name ?? this.name,
      seasonStartDay: seasonStartDay ?? this.seasonStartDay,
      seasonStartMonth: seasonStartMonth ?? this.seasonStartMonth,
      language: language ?? this.language,
      lastBackupDate: lastBackupDate ?? this.lastBackupDate,
    );
  }

  @override
  String toString() {
    return 'UserSettings{id: $id, name: $name, seasonStart: $seasonStartMonth/$seasonStartDay, language: $language}';
  }
}
