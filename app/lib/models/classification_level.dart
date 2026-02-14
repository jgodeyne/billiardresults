/// Classification level (target average range) for a discipline
class ClassificationLevel {
  final int? id;
  final String discipline;
  final double minAverage;
  final double maxAverage;

  ClassificationLevel({
    this.id,
    required this.discipline,
    required this.minAverage,
    required this.maxAverage,
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
    };
  }

  /// Create from database Map
  factory ClassificationLevel.fromMap(Map<String, dynamic> map) {
    return ClassificationLevel(
      id: map['id'] as int?,
      discipline: map['discipline'] as String,
      minAverage: (map['min_average'] as num).toDouble(),
      maxAverage: (map['max_average'] as num).toDouble(),
    );
  }

  /// Copy with modifications
  ClassificationLevel copyWith({
    int? id,
    String? discipline,
    double? minAverage,
    double? maxAverage,
  }) {
    return ClassificationLevel(
      id: id ?? this.id,
      discipline: discipline ?? this.discipline,
      minAverage: minAverage ?? this.minAverage,
      maxAverage: maxAverage ?? this.maxAverage,
    );
  }

  @override
  String toString() {
    return 'ClassificationLevel{id: $id, discipline: $discipline, range: $minAverage-$maxAverage}';
  }
}
