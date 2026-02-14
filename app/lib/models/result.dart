/// Match result entry
class Result {
  final int? id;
  final String discipline;
  final DateTime date;
  final int pointsMade;
  final int innings;
  final int highestRun;
  final String? adversary; // Optional
  final String? outcome; // 'won', 'lost', 'draw', or null
  final String? competition; // Optional

  Result({
    this.id,
    required this.discipline,
    required this.date,
    required this.pointsMade,
    required this.innings,
    required this.highestRun,
    this.adversary,
    this.outcome,
    this.competition,
  });

  /// Calculate average for this result
  double get average => innings > 0 ? pointsMade / innings : 0.0;

  /// Convert to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'discipline': discipline,
      'date': date.toIso8601String(),
      'points_made': pointsMade,
      'innings': innings,
      'highest_run': highestRun,
      'adversary': adversary,
      'outcome': outcome,
      'competition': competition,
    };
  }

  /// Create from database Map
  factory Result.fromMap(Map<String, dynamic> map) {
    return Result(
      id: map['id'] as int?,
      discipline: map['discipline'] as String,
      date: DateTime.parse(map['date'] as String),
      pointsMade: map['points_made'] as int,
      innings: map['innings'] as int,
      highestRun: map['highest_run'] as int,
      adversary: map['adversary'] as String?,
      outcome: map['outcome'] as String?,
      competition: map['competition'] as String?,
    );
  }

  /// Copy with modifications
  Result copyWith({
    int? id,
    String? discipline,
    DateTime? date,
    int? pointsMade,
    int? innings,
    int? highestRun,
    String? adversary,
    String? outcome,
    String? competition,
  }) {
    return Result(
      id: id ?? this.id,
      discipline: discipline ?? this.discipline,
      date: date ?? this.date,
      pointsMade: pointsMade ?? this.pointsMade,
      innings: innings ?? this.innings,
      highestRun: highestRun ?? this.highestRun,
      adversary: adversary ?? this.adversary,
      outcome: outcome ?? this.outcome,
      competition: competition ?? this.competition,
    );
  }

  @override
  String toString() {
    return 'Result{id: $id, discipline: $discipline, date: $date, points: $pointsMade, innings: $innings, avg: ${average.toStringAsFixed(3)}}';
  }
}
