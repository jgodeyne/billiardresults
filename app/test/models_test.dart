import 'package:flutter_test/flutter_test.dart';
import 'package:app/models/models.dart';

void main() {
  group('UserSettings Model', () {
    test('creates UserSettings with required fields', () {
      final settings = UserSettings(
        name: 'John Doe',
        seasonStartDay: 1,
        seasonStartMonth: 9,
        language: 'en',
      );

      expect(settings.name, 'John Doe');
      expect(settings.seasonStartDay, 1);
      expect(settings.seasonStartMonth, 9);
      expect(settings.language, 'en');
    });

    test('converts to and from Map', () {
      final settings = UserSettings(
        id: 1,
        name: 'John Doe',
        seasonStartDay: 1,
        seasonStartMonth: 9,
        language: 'en',
      );

      final map = settings.toMap();
      final restored = UserSettings.fromMap(map);

      expect(restored.id, settings.id);
      expect(restored.name, settings.name);
      expect(restored.seasonStartDay, settings.seasonStartDay);
      expect(restored.seasonStartMonth, settings.seasonStartMonth);
      expect(restored.language, settings.language);
    });

    test('copyWith creates modified copy', () {
      final original = UserSettings(
        name: 'John',
        seasonStartDay: 1,
        seasonStartMonth: 9,
        language: 'en',
      );

      final modified = original.copyWith(name: 'Jane', language: 'nl');

      expect(modified.name, 'Jane');
      expect(modified.language, 'nl');
      expect(modified.seasonStartDay, 1); // Unchanged
      expect(modified.seasonStartMonth, 9); // Unchanged
    });
  });

  group('Result Model', () {
    test('creates Result with all fields', () {
      final result = Result(
        discipline: '3-cushion - Small table',
        date: DateTime(2026, 2, 14),
        pointsMade: 50,
        innings: 25,
        highestRun: 8,
        adversary: 'opponent name',
        outcome: 'won',
        competition: 'tournament',
      );

      expect(result.discipline, '3-cushion - Small table');
      expect(result.pointsMade, 50);
      expect(result.innings, 25);
      expect(result.highestRun, 8);
      expect(result.adversary, 'opponent name');
      expect(result.outcome, 'won');
      expect(result.competition, 'tournament');
    });

    test('calculates average correctly', () {
      final result = Result(
        discipline: 'Free game',
        date: DateTime.now(),
        pointsMade: 100,
        innings: 40,
        highestRun: 15,
      );

      expect(result.average, 2.5);
    });

    test('handles zero innings in average calculation', () {
      final result = Result(
        discipline: 'Free game',
        date: DateTime.now(),
        pointsMade: 100,
        innings: 0,
        highestRun: 0,
      );

      expect(result.average, 0.0);
    });

    test('converts to and from Map', () {
      final result = Result(
        id: 1,
        discipline: '3-cushion',
        date: DateTime(2026, 2, 14, 10, 30),
        pointsMade: 50,
        innings: 25,
        highestRun: 8,
        adversary: 'Test',
        outcome: 'won',
        competition: 'Local',
      );

      final map = result.toMap();
      final restored = Result.fromMap(map);

      expect(restored.id, result.id);
      expect(restored.discipline, result.discipline);
      expect(restored.date, result.date);
      expect(restored.pointsMade, result.pointsMade);
      expect(restored.innings, result.innings);
      expect(restored.highestRun, result.highestRun);
    });
  });

  group('ClassificationLevel Model', () {
    test('creates ClassificationLevel', () {
      final level = ClassificationLevel(
        discipline: '3-cushion',
        minAverage: 1.5,
        maxAverage: 2.0,
      );

      expect(level.discipline, '3-cushion');
      expect(level.minAverage, 1.5);
      expect(level.maxAverage, 2.0);
    });

    test('checks if average is within range', () {
      final level = ClassificationLevel(
        discipline: '3-cushion',
        minAverage: 1.5,
        maxAverage: 2.0,
      );

      expect(level.isWithinRange(1.7), true);
      expect(level.isWithinRange(1.5), true);
      expect(level.isWithinRange(2.0), true);
      expect(level.isWithinRange(1.0), false);
      expect(level.isWithinRange(2.5), false);
    });

    test('checks if average is above target', () {
      final level = ClassificationLevel(
        discipline: '3-cushion',
        minAverage: 1.5,
        maxAverage: 2.0,
      );

      expect(level.isAboveTarget(2.5), true);
      expect(level.isAboveTarget(2.0), false);
      expect(level.isAboveTarget(1.5), false);
    });

    test('checks if average is below target', () {
      final level = ClassificationLevel(
        discipline: '3-cushion',
        minAverage: 1.5,
        maxAverage: 2.0,
      );

      expect(level.isBelowTarget(1.0), true);
      expect(level.isBelowTarget(1.5), false);
      expect(level.isBelowTarget(2.0), false);
    });
  });

  group('Season Model', () {
    test('creates season from user settings', () {
      final season = Season.fromUserSettings(
        year: 2025,
        seasonStartDay: 1,
        seasonStartMonth: 9, // September 1
      );

      expect(season.year, 2025);
      expect(season.startDate, DateTime(2025, 9, 1));
      // Should end on August 31, 2026, 23:59:59
      expect(season.endDate.year, 2026);
      expect(season.endDate.month, 8);
      expect(season.endDate.day, 31);
    });

    test('checks if date is in season', () {
      final season = Season.fromUserSettings(
        year: 2025,
        seasonStartDay: 1,
        seasonStartMonth: 9,
      );

      expect(season.containsDate(DateTime(2025, 9, 1)), true);
      expect(season.containsDate(DateTime(2025, 12, 25)), true);
      expect(season.containsDate(DateTime(2026, 1, 15)), true);
      expect(season.containsDate(DateTime(2026, 8, 31)), true);
      expect(season.containsDate(DateTime(2025, 8, 31)), false);
      expect(season.containsDate(DateTime(2026, 9, 1)), false);
    });

    test('gets current season correctly', () {
      // This test depends on current date, so we test the logic
      final now = DateTime.now();
      final season = Season.getCurrentSeason(
        seasonStartDay: 1,
        seasonStartMonth: 9,
      );

      // Verify the returned season contains today
      expect(season.containsDate(now), true);
    });

    test('handles January 1 season start', () {
      final season = Season.fromUserSettings(
        year: 2025,
        seasonStartDay: 1,
        seasonStartMonth: 1,
      );

      expect(season.startDate, DateTime(2025, 1, 1));
      expect(season.endDate.year, 2025);
      expect(season.endDate.month, 12);
      expect(season.endDate.day, 31);
    });

    test('display name shows correct year', () {
      final season = Season.fromUserSettings(
        year: 2025,
        seasonStartDay: 1,
        seasonStartMonth: 9,
      );

      expect(season.displayName, 'Season 2025');
    });

    test('equality works correctly', () {
      final season1 = Season.fromUserSettings(
        year: 2025,
        seasonStartDay: 1,
        seasonStartMonth: 9,
      );
      
      final season2 = Season.fromUserSettings(
        year: 2025,
        seasonStartDay: 1,
        seasonStartMonth: 9,
      );
      
      final season3 = Season.fromUserSettings(
        year: 2024,
        seasonStartDay: 1,
        seasonStartMonth: 9,
      );

      expect(season1 == season2, true);
      expect(season1 == season3, false);
    });
  });
}
