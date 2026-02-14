import 'package:flutter_test/flutter_test.dart';
import 'package:app/models/result.dart';
import 'package:app/services/statistics_helper.dart';

void main() {
  group('StatisticsHelper', () {
    late List<Result> sampleResults;

    setUp(() {
      sampleResults = [
        Result(
          id: 1,
          discipline: '3-cushion',
          date: DateTime(2026, 2, 1),
          pointsMade: 40,
          innings: 20,
          highestRun: 6,
          outcome: 'won',
        ),
        Result(
          id: 2,
          discipline: '3-cushion',
          date: DateTime(2026, 2, 5),
          pointsMade: 50,
          innings: 20,
          highestRun: 8,
          outcome: 'lost',
        ),
        Result(
          id: 3,
          discipline: '3-cushion',
          date: DateTime(2026, 2, 10),
          pointsMade: 60,
          innings: 30,
          highestRun: 10,
          outcome: 'draw',
        ),
        Result(
          id: 4,
          discipline: '3-cushion',
          date: DateTime(2026, 2, 15),
          pointsMade: 45,
          innings: 15,
          highestRun: 7,
        ), // No outcome
      ];
    });

    test('calculates overall average correctly', () {
      final avg = StatisticsHelper.calculateAverage(sampleResults);
      // Total: 195 points, 85 innings = 2.294...
      expect(avg.toStringAsFixed(3), '2.294');
    });

    test('handles empty results for average', () {
      final avg = StatisticsHelper.calculateAverage([]);
      expect(avg, 0.0);
    });

    test('gets highest run', () {
      final highest = StatisticsHelper.getHighestRun(sampleResults);
      expect(highest, 10);
    });

    test('calculates total points', () {
      final total = StatisticsHelper.getTotalPoints(sampleResults);
      expect(total, 195);
    });

    test('calculates total innings', () {
      final total = StatisticsHelper.getTotalInnings(sampleResults);
      expect(total, 85);
    });

    test('counts outcomes correctly', () {
      final counts = StatisticsHelper.getOutcomeCounts(sampleResults);
      expect(counts['won'], 1);
      expect(counts['lost'], 1);
      expect(counts['draw'], 1);
      expect(counts['unknown'], 1);
    });

    test('calculates trend - improving', () {
      final improvingResults = [
        Result(
          discipline: 'test',
          date: DateTime(2026, 1, 1),
          pointsMade: 20,
          innings: 20,
          highestRun: 3,
        ),
        Result(
          discipline: 'test',
          date: DateTime(2026, 1, 2),
          pointsMade: 25,
          innings: 20,
          highestRun: 4,
        ),
        Result(
          discipline: 'test',
          date: DateTime(2026, 1, 3),
          pointsMade: 30,
          innings: 20,
          highestRun: 5,
        ),
        Result(
          discipline: 'test',
          date: DateTime(2026, 1, 4),
          pointsMade: 40,
          innings: 20,
          highestRun: 6,
        ),
        Result(
          discipline: 'test',
          date: DateTime(2026, 1, 5),
          pointsMade: 45,
          innings: 20,
          highestRun: 7,
        ),
      ];

      final trend = StatisticsHelper.calculateTrend(improvingResults);
      expect(trend, 'up');
    });

    test('calculates trend - declining', () {
      final decliningResults = [
        Result(
          discipline: 'test',
          date: DateTime(2026, 1, 1),
          pointsMade: 45,
          innings: 20,
          highestRun: 7,
        ),
        Result(
          discipline: 'test',
          date: DateTime(2026, 1, 2),
          pointsMade: 40,
          innings: 20,
          highestRun: 6,
        ),
        Result(
          discipline: 'test',
          date: DateTime(2026, 1, 3),
          pointsMade: 30,
          innings: 20,
          highestRun: 5,
        ),
        Result(
          discipline: 'test',
          date: DateTime(2026, 1, 4),
          pointsMade: 25,
          innings: 20,
          highestRun: 4,
        ),
        Result(
          discipline: 'test',
          date: DateTime(2026, 1, 5),
          pointsMade: 20,
          innings: 20,
          highestRun: 3,
        ),
      ];

      final trend = StatisticsHelper.calculateTrend(decliningResults);
      expect(trend, 'down');
    });

    test('calculates trend - stable', () {
      final stableResults = [
        Result(
          discipline: 'test',
          date: DateTime(2026, 1, 1),
          pointsMade: 40,
          innings: 20,
          highestRun: 5,
        ),
        Result(
          discipline: 'test',
          date: DateTime(2026, 1, 2),
          pointsMade: 41,
          innings: 20,
          highestRun: 5,
        ),
        Result(
          discipline: 'test',
          date: DateTime(2026, 1, 3),
          pointsMade: 40,
          innings: 20,
          highestRun: 5,
        ),
        Result(
          discipline: 'test',
          date: DateTime(2026, 1, 4),
          pointsMade: 39,
          innings: 20,
          highestRun: 5,
        ),
      ];

      final trend = StatisticsHelper.calculateTrend(stableResults);
      expect(trend, 'stable');
    });

    test('gets averages per match in chronological order', () {
      final averages = StatisticsHelper.getAveragesPerMatch(sampleResults);
      expect(averages.length, 4);
      expect(averages[0], 2.0); // 40/20
      expect(averages[1], 2.5); // 50/20
      expect(averages[2], 2.0); // 60/30
      expect(averages[3], 3.0); // 45/15
    });

    test('gets unique adversaries', () {
      final resultsWithAdversaries = [
        Result(
          discipline: 'test',
          date: DateTime.now(),
          pointsMade: 40,
          innings: 20,
          highestRun: 5,
          adversary: 'Player A',
        ),
        Result(
          discipline: 'test',
          date: DateTime.now(),
          pointsMade: 40,
          innings: 20,
          highestRun: 5,
          adversary: 'Player B',
        ),
        Result(
          discipline: 'test',
          date: DateTime.now(),
          pointsMade: 40,
          innings: 20,
          highestRun: 5,
          adversary: 'Player A',
        ),
      ];

      final adversaries = StatisticsHelper.getUniqueAdversaries(resultsWithAdversaries);
      expect(adversaries.length, 2);
      expect(adversaries, containsAll(['Player A', 'Player B']));
    });

    test('validates result fields correctly', () {
      // Valid result
      var errors = StatisticsHelper.validateResult(
        pointsMade: 50,
        innings: 25,
        highestRun: 8,
      );
      expect(errors.isEmpty, true);

      // Negative points
      errors = StatisticsHelper.validateResult(
        pointsMade: -5,
        innings: 25,
        highestRun: 8,
      );
      expect(errors.containsKey('points'), true);

      // Zero innings
      errors = StatisticsHelper.validateResult(
        pointsMade: 50,
        innings: 0,
        highestRun: 8,
      );
      expect(errors.containsKey('innings'), true);

      // Highest run > points
      errors = StatisticsHelper.validateResult(
        pointsMade: 50,
        innings: 25,
        highestRun: 60,
      );
      expect(errors.containsKey('highestRun'), true);

      // Warning for high points
      errors = StatisticsHelper.validateResult(
        pointsMade: 600,
        innings: 25,
        highestRun: 50,
      );
      expect(errors.containsKey('points'), true);
      expect(StatisticsHelper.isWarningOnly(errors['points']!), true);
    });

    test('filters by adversary', () {
      final resultsWithAdversaries = [
        Result(
          discipline: 'test',
          date: DateTime.now(),
          pointsMade: 40,
          innings: 20,
          highestRun: 5,
          adversary: 'Player A',
        ),
        Result(
          discipline: 'test',
          date: DateTime.now(),
          pointsMade: 40,
          innings: 20,
          highestRun: 5,
          adversary: 'Player B',
        ),
        Result(
          discipline: 'test',
          date: DateTime.now(),
          pointsMade: 40,
          innings: 20,
          highestRun: 5,
          adversary: 'Player A',
        ),
      ];

      final filtered = StatisticsHelper.filterByAdversary(resultsWithAdversaries, 'Player A');
      expect(filtered.length, 2);
      expect(filtered.every((r) => r.adversary == 'Player A'), true);
    });

    test('filters by competition', () {
      final resultsWithCompetitions = [
        Result(
          discipline: 'test',
          date: DateTime.now(),
          pointsMade: 40,
          innings: 20,
          highestRun: 5,
          competition: 'Tournament A',
        ),
        Result(
          discipline: 'test',
          date: DateTime.now(),
          pointsMade: 40,
          innings: 20,
          highestRun: 5,
          competition: 'Tournament B',
        ),
        Result(
          discipline: 'test',
          date: DateTime.now(),
          pointsMade: 40,
          innings: 20,
          highestRun: 5,
          competition: 'Tournament A',
        ),
      ];

      final filtered = StatisticsHelper.filterByCompetition(resultsWithCompetitions, 'Tournament A');
      expect(filtered.length, 2);
      expect(filtered.every((r) => r.competition == 'Tournament A'), true);
    });
  });
}
