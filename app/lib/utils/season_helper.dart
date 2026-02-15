import '../models/user_settings.dart';

/// Helper class for season calculations
class SeasonHelper {
  /// Get the current season start and end dates based on user settings
  static (DateTime start, DateTime end) getCurrentSeason(UserSettings settings) {
    final now = DateTime.now();
    return getSeasonForDate(settings, now);
  }

  /// Get season boundaries for a specific date
  static (DateTime start, DateTime end) getSeasonForDate(
    UserSettings settings,
    DateTime date,
  ) {
    final year = date.year;
    
    // Create potential season start for current year
    var seasonStart = DateTime(
      year,
      settings.seasonStartMonth,
      settings.seasonStartDay,
    );

    // If date is before this year's season start, use previous year's season
    if (date.isBefore(seasonStart)) {
      seasonStart = DateTime(
        year - 1,
        settings.seasonStartMonth,
        settings.seasonStartDay,
      );
    }

    // Season end is one day before next season start
    final seasonEnd = DateTime(
      seasonStart.year + 1,
      settings.seasonStartMonth,
      settings.seasonStartDay,
    ).subtract(const Duration(days: 1));

    return (seasonStart, seasonEnd);
  }

  /// Get all seasons that have results
  static List<(DateTime start, DateTime end)> getAvailableSeasons(
    UserSettings settings,
    DateTime? firstResultDate,
    DateTime? lastResultDate,
  ) {
    if (firstResultDate == null || lastResultDate == null) {
      return [];
    }

    final seasons = <(DateTime, DateTime)>[];
    var currentDate = firstResultDate;

    while (currentDate.isBefore(lastResultDate) ||
        currentDate.isAtSameMomentAs(lastResultDate)) {
      final season = getSeasonForDate(settings, currentDate);
      
      // Avoid duplicate seasons
      if (seasons.isEmpty || 
          seasons.last.$1.isBefore(season.$1)) {
        seasons.add(season);
      }

      // Move to next season
      currentDate = season.$2.add(const Duration(days: 1));
    }

    // Always include current season if not already in list
    final currentSeason = getCurrentSeason(settings);
    if (seasons.isEmpty ||
        seasons.last.$1.isBefore(currentSeason.$1)) {
      seasons.add(currentSeason);
    }

    return seasons.reversed.toList(); // Most recent first
  }

  /// Format season as string (e.g., "2023-2024")
  static String formatSeason(DateTime start, DateTime end) {
    if (start.year == end.year) {
      return '${start.year}';
    }
    return '${start.year}-${end.year}';
  }

  /// Check if a date falls within a season
  static bool isDateInSeason(
    DateTime date,
    DateTime seasonStart,
    DateTime seasonEnd,
  ) {
    return (date.isAfter(seasonStart) || date.isAtSameMomentAs(seasonStart)) &&
        (date.isBefore(seasonEnd) || date.isAtSameMomentAs(seasonEnd));
  }
}
