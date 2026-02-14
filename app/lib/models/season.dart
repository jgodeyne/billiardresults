/// Season model - computed based on user-defined season start date
class Season {
  final int year; // The year when the season starts
  final DateTime startDate;
  final DateTime endDate;

  Season({
    required this.year,
    required this.startDate,
    required this.endDate,
  });

  /// Create a season from user settings and year
  /// Example: if seasonStartDay=1, seasonStartMonth=9 (Sept 1)
  /// Season 2025 runs from Sept 1, 2025 to Aug 31, 2026
  factory Season.fromUserSettings({
    required int year,
    required int seasonStartDay,
    required int seasonStartMonth,
  }) {
    final startDate = DateTime(year, seasonStartMonth, seasonStartDay);
    
    // End date is one day before the next season
    DateTime endDate;
    if (seasonStartMonth == 1 && seasonStartDay == 1) {
      // Special case: if season starts Jan 1, it ends Dec 31
      endDate = DateTime(year, 12, 31, 23, 59, 59);
    } else {
      // Calculate next year's start date
      final nextSeasonStart = DateTime(year + 1, seasonStartMonth, seasonStartDay);
      // End date is one day before
      endDate = nextSeasonStart.subtract(const Duration(days: 1, seconds: -86399)); // 23:59:59 of previous day
    }
    
    return Season(
      year: year,
      startDate: startDate,
      endDate: endDate,
    );
  }

  /// Get current season based on today's date and user settings
  static Season getCurrentSeason({
    required int seasonStartDay,
    required int seasonStartMonth,
  }) {
    final now = DateTime.now();
    final currentYearSeasonStart = DateTime(now.year, seasonStartMonth, seasonStartDay);
    
    // If we're before this year's season start, we're in last year's season
    if (now.isBefore(currentYearSeasonStart)) {
      return Season.fromUserSettings(
        year: now.year - 1,
        seasonStartDay: seasonStartDay,
        seasonStartMonth: seasonStartMonth,
      );
    } else {
      // We're in this year's season
      return Season.fromUserSettings(
        year: now.year,
        seasonStartDay: seasonStartDay,
        seasonStartMonth: seasonStartMonth,
      );
    }
  }

  /// Check if a date falls within this season
  bool containsDate(DateTime date) {
    return (date.isAfter(startDate) || date.isAtSameMomentAs(startDate)) &&
        (date.isBefore(endDate) || date.isAtSameMomentAs(endDate));
  }

  /// Get season name for display (e.g., "Season 2025")
  String get displayName => 'Season $year';

  /// Get all seasons from first result date to current season
  static List<Season> getAllSeasons({
    required DateTime? firstResultDate,
    required int seasonStartDay,
    required int seasonStartMonth,
  }) {
    if (firstResultDate == null) {
      return [];
    }

    final seasons = <Season>[];
    final currentSeason = getCurrentSeason(
      seasonStartDay: seasonStartDay,
      seasonStartMonth: seasonStartMonth,
    );

    // Find the season of the first result
    Season firstSeason;
    final firstYearSeasonStart = DateTime(
      firstResultDate.year,
      seasonStartMonth,
      seasonStartDay,
    );
    
    if (firstResultDate.isBefore(firstYearSeasonStart)) {
      firstSeason = Season.fromUserSettings(
        year: firstResultDate.year - 1,
        seasonStartDay: seasonStartDay,
        seasonStartMonth: seasonStartMonth,
      );
    } else {
      firstSeason = Season.fromUserSettings(
        year: firstResultDate.year,
        seasonStartDay: seasonStartDay,
        seasonStartMonth: seasonStartMonth,
      );
    }

    // Generate all seasons from first to current
    for (int year = firstSeason.year; year <= currentSeason.year; year++) {
      seasons.add(Season.fromUserSettings(
        year: year,
        seasonStartDay: seasonStartDay,
        seasonStartMonth: seasonStartMonth,
      ));
    }

    return seasons.reversed.toList(); // Most recent first
  }

  @override
  String toString() {
    return 'Season{year: $year, start: ${startDate.toString().split(' ')[0]}, end: ${endDate.toString().split(' ')[0]}}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Season && other.year == year;
  }

  @override
  int get hashCode => year.hashCode;
}
