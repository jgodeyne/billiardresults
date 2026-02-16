import '../models/result.dart';

/// Statistics for a specific competition
class CompetitionStats {
  final String competition;
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

  CompetitionStats({
    required this.competition,
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
  factory CompetitionStats.fromResults(String competition, List<Result> results) {
    if (results.isEmpty) {
      return CompetitionStats(
        competition: competition,
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

    return CompetitionStats(
      competition: competition,
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

  /// Get trend based on last 5 matches
  String getTrend() {
    if (averagesPerMatch.length < 2) return 'stable';
    
    // Get up to last 5 matches
    final recentCount = averagesPerMatch.length >= 5 ? 5 : averagesPerMatch.length;
    final recentAverages = averagesPerMatch.sublist(averagesPerMatch.length - recentCount);
    
    // Calculate trend
    double sum = 0;
    for (int i = 1; i < recentAverages.length; i++) {
      sum += recentAverages[i] - recentAverages[i - 1];
    }
    
    final trend = sum / (recentAverages.length - 1);
    
    // Threshold for trend detection (0.05 average difference)
    if (trend > 0.05) return 'up';
    if (trend < -0.05) return 'down';
    return 'stable';
  }
}
