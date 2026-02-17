/// Classification level (target average range) for a discipline per season
class ClassificationLevel {
  final int? id;
  final String discipline;
  final double minAverage;
  final double maxAverage;
  final DateTime? seasonStartDate;
  final DateTime? seasonEndDate;

  ClassificationLevel({
    this.id,
    required this.discipline,
    required this.minAverage,
    required this.maxAverage,
    this.seasonStartDate,
    this.seasonEndDate,
  });

  /// Check if an average is within range
  bool isWithinRange(double average) {
    return average >= minAverage && average <= maxAverage;
  }

  /// Check if average is above target
  bool isAboveTarget(double average) {
    return average > maxAverage;
  }

  /// Check if average is below target
  bool isBelowTarget(double average) {
    return average < minAverage;
  }

  /// Convert to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'discipline': discipline,
      'min_average': minAverage,
      'max_average': maxAverage,
      'season_start_date': seasonStartDate?.toIso8601String(),
      'season_end_date': seasonEndDate?.toIso8601String(),
    };
  }

  /// Create from database Map
  factory ClassificationLevel.fromMap(Map<String, dynamic> map) {
    return ClassificationLevel(
      id: map['id'] as int?,
      discipline: map['discipline'] as String,
      minAverage: (map['min_average'] as num).toDouble(),
      maxAverage: (map['max_average'] as num).toDouble(),
      seasonStartDate: map['season_start_date'] != null
          ? DateTime.parse(map['season_start_date'] as String)
          : null,
      seasonEndDate: map['season_end_date'] != null
          ? DateTime.parse(map['season_end_date'] as String)
          : null,
    );
  }

  /// Copy with modifications
  ClassificationLevel copyWith({
    int? id,
    String? discipline,
    double? minAverage,
    double? maxAverage,
    DateTime? seasonStartDate,
    DateTime? seasonEndDate,
  }) {
    return ClassificationLevel(
      id: id ?? this.id,
      discipline: discipline ?? this.discipline,
      minAverage: minAverage ?? this.minAverage,
      maxAverage: maxAverage ?? this.maxAverage,
      seasonStartDate: seasonStartDate ?? this.seasonStartDate,
      seasonEndDate: seasonEndDate ?? this.seasonEndDate,
    );
  }

  @override
  String toString() {
    final seasonInfo = seasonStartDate != null && seasonEndDate != null
        ? ', season: ${seasonStartDate!.year}-${seasonEndDate!.year}'
        : '';
    return 'ClassificationLevel{id: $id, discipline: $discipline, range: $minAverage-$maxAverage$seasonInfo}';
  }
}
