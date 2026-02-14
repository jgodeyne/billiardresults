import '../models/result.dart';

/// Helper class for calculating statistics from results
class StatisticsHelper {
  /// Calculate overall average from list of results
  static double calculateAverage(List<Result> results) {
    if (results.isEmpty) return 0.0;
    
    int totalPoints = 0;
    int totalInnings = 0;
    
    for (final result in results) {
      totalPoints += result.pointsMade;
      totalInnings += result.innings;
    }
    
    return totalInnings > 0 ? totalPoints / totalInnings : 0.0;
  }

  /// Get highest run from list of results
  static int getHighestRun(List<Result> results) {
    if (results.isEmpty) return 0;
    
    return results.map((r) => r.highestRun).reduce((a, b) => a > b ? a : b);
  }

  /// Get total points made
  static int getTotalPoints(List<Result> results) {
    return results.fold(0, (sum, result) => sum + result.pointsMade);
  }

  /// Get total innings played
  static int getTotalInnings(List<Result> results) {
    return results.fold(0, (sum, result) => sum + result.innings);
  }

  /// Count results by outcome
  static Map<String, int> getOutcomeCounts(List<Result> results) {
    final counts = {
      'won': 0,
      'lost': 0,
      'draw': 0,
      'unknown': 0,
    };
    
    for (final result in results) {
      if (result.outcome == null) {
        counts['unknown'] = (counts['unknown'] ?? 0) + 1;
      } else {
        final outcome = result.outcome!.toLowerCase();
        if (counts.containsKey(outcome)) {
          counts[outcome] = (counts[outcome] ?? 0) + 1;
        } else {
          counts['unknown'] = (counts['unknown'] ?? 0) + 1;
        }
      }
    }
    
    return counts;
  }

  /// Calculate performance trend from last N matches
  /// Returns: 'up', 'down', or 'stable'
  static String calculateTrend(List<Result> results, {int lastN = 5}) {
    if (results.length < 2) return 'stable';
    
    // Sort by date (oldest first for trend calculation)
    final sortedResults = List<Result>.from(results)
      ..sort((a, b) => a.date.compareTo(b.date));
    
    // Take last N results
    final recentResults = sortedResults.length > lastN
        ? sortedResults.sublist(sortedResults.length - lastN)
        : sortedResults;
    
    if (recentResults.length < 2) return 'stable';
    
    // Calculate average for first half and second half
    final midPoint = recentResults.length ~/ 2;
    final firstHalf = recentResults.sublist(0, midPoint);
    final secondHalf = recentResults.sublist(midPoint);
    
    final firstAvg = calculateAverage(firstHalf);
    final secondAvg = calculateAverage(secondHalf);
    
    // Define threshold for "significant" change (e.g., 0.1 difference)
    const threshold = 0.1;
    
    if (secondAvg > firstAvg + threshold) {
      return 'up';
    } else if (secondAvg < firstAvg - threshold) {
      return 'down';
    } else {
      return 'stable';
    }
  }

  /// Get average per match for chart data
  static List<double> getAveragesPerMatch(List<Result> results) {
    // Sort by date
    final sortedResults = List<Result>.from(results)
      ..sort((a, b) => a.date.compareTo(b.date));
    
    return sortedResults.map((r) => r.average).toList();
  }

  /// Get highest runs per match for chart data
  static List<int> getHighestRunsPerMatch(List<Result> results) {
    // Sort by date
    final sortedResults = List<Result>.from(results)
      ..sort((a, b) => a.date.compareTo(b.date));
    
    return sortedResults.map((r) => r.highestRun).toList();
  }

  /// Get unique adversaries from results
  static List<String> getUniqueAdversaries(List<Result> results) {
    final adversaries = results
        .where((r) => r.adversary != null && r.adversary!.isNotEmpty)
        .map((r) => r.adversary!)
        .toSet()
        .toList();
    
    adversaries.sort();
    return adversaries;
  }

  /// Get unique competitions from results
  static List<String> getUniqueCompetitions(List<Result> results) {
    final competitions = results
        .where((r) => r.competition != null && r.competition!.isNotEmpty)
        .map((r) => r.competition!)
        .toSet()
        .toList();
    
    competitions.sort();
    return competitions;
  }

  /// Filter results by adversary
  static List<Result> filterByAdversary(List<Result> results, String adversary) {
    return results.where((r) => r.adversary == adversary).toList();
  }

  /// Filter results by competition
  static List<Result> filterByCompetition(List<Result> results, String competition) {
    return results.where((r) => r.competition == competition).toList();
  }

  /// Validate result fields
  static Map<String, String?> validateResult({
    required int pointsMade,
    required int innings,
    required int highestRun,
  }) {
    final errors = <String, String?>{};
    
    // Points validation
    if (pointsMade < 0) {
      errors['points'] = 'Points cannot be negative';
    } else if (pointsMade > 500) {
      errors['points'] = 'Warning: Unusually high points value';
    }
    
    // Innings validation
    if (innings <= 0) {
      errors['innings'] = 'Innings must be greater than 0';
    } else if (innings > 200) {
      errors['innings'] = 'Warning: Unusually high innings value';
    }
    
    // Highest run validation
    if (highestRun < 0) {
      errors['highestRun'] = 'Highest run cannot be negative';
    } else if (highestRun > pointsMade) {
      errors['highestRun'] = 'Highest run cannot exceed points made';
    } else if (highestRun > 300) {
      errors['highestRun'] = 'Warning: Unusually high run value';
    }
    
    return errors;
  }

  /// Check if validation errors are warnings only (not blocking)
  static bool isWarningOnly(String errorMessage) {
    return errorMessage.toLowerCase().startsWith('warning');
  }
}
