import '../models/result.dart';

/// Statistics for a specific discipline
class DisciplineStats {
  final String discipline;
  final List<Result> results;
  final double currentAverage;
  final int highestRun;
  final int totalPoints;
  final int totalInnings;
  final int matchCount;
  final int wonCount;
  final int lostCount;
  final int drawCount;
  final int unknownCount;
  final List<double> averagesPerMatch;

  DisciplineStats({
    required this.discipline,
    required this.results,
    required this.currentAverage,
    required this.highestRun,
    required this.totalPoints,
    required this.totalInnings,
    required this.matchCount,
    required this.wonCount,
    required this.lostCount,
    required this.drawCount,
    required this.unknownCount,
    required this.averagesPerMatch,
  });

  /// Create statistics from a list of results
  factory DisciplineStats.fromResults(String discipline, List<Result> results) {
    if (results.isEmpty) {
      return DisciplineStats(
        discipline: discipline,
        results: [],
        currentAverage: 0.0,
        highestRun: 0,
        totalPoints: 0,
        totalInnings: 0,
        matchCount: 0,
        wonCount: 0,
        lostCount: 0,
        drawCount: 0,
        unknownCount: 0,
        averagesPerMatch: [],
      );
    }

    // Sort by date for chart
    final sortedResults = List<Result>.from(results)
      ..sort((a, b) => a.date.compareTo(b.date));

    // Calculate totals
    int totalPoints = 0;
    int totalInnings = 0;
    int highestRun = 0;
    int wonCount = 0;
    int lostCount = 0;
    int drawCount = 0;
    int unknownCount = 0;

    for (final result in results) {
      totalPoints += result.pointsMade;
      totalInnings += result.innings;
      if (result.highestRun > highestRun) {
        highestRun = result.highestRun;
      }

      // Count outcomes
      switch (result.outcome?.toLowerCase()) {
        case 'won':
          wonCount++;
          break;
        case 'lost':
          lostCount++;
          break;
        case 'draw':
          drawCount++;
          break;
        default:
          unknownCount++;
      }
    }

    final currentAverage = totalInnings > 0 ? totalPoints / totalInnings : 0.0;
    final averagesPerMatch = sortedResults.map((r) => r.average).toList();

    return DisciplineStats(
      discipline: discipline,
      results: results,
      currentAverage: currentAverage,
      highestRun: highestRun,
      totalPoints: totalPoints,
      totalInnings: totalInnings,
      matchCount: results.length,
      wonCount: wonCount,
      lostCount: lostCount,
      drawCount: drawCount,
      unknownCount: unknownCount,
      averagesPerMatch: averagesPerMatch,
    );
  }

  /// Get performance trend (up, down, stable)
  String getTrend({int lastN = 5}) {
    if (averagesPerMatch.length < 2) return 'stable';

    final recentAverages = averagesPerMatch.length > lastN
        ? averagesPerMatch.sublist(averagesPerMatch.length - lastN)
        : averagesPerMatch;

    if (recentAverages.length < 2) return 'stable';

    final midPoint = recentAverages.length ~/ 2;
    final firstHalf = recentAverages.sublist(0, midPoint);
    final secondHalf = recentAverages.sublist(midPoint);

    final firstAvg = firstHalf.reduce((a, b) => a + b) / firstHalf.length;
    final secondAvg = secondHalf.reduce((a, b) => a + b) / secondHalf.length;

    const threshold = 0.1;

    if (secondAvg > firstAvg + threshold) {
      return 'up';
    } else if (secondAvg < firstAvg - threshold) {
      return 'down';
    } else {
      return 'stable';
    }
  }
}
