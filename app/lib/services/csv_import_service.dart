import 'dart:io';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import '../models/result.dart';

class CsvImportResult {
  final List<Result> results;
  final List<String> errors;
  final int successCount;
  final int errorCount;

  CsvImportResult({
    required this.results,
    required this.errors,
    required this.successCount,
    required this.errorCount,
  });

  bool get hasErrors => errors.isNotEmpty;
  bool get hasResults => results.isNotEmpty;
}

class CsvImportService {
  static Future<CsvImportResult> parseAndValidateCsv(String filePath) async {
    final file = File(filePath);
    final csvString = await file.readAsString();
    
    return _parseCsvString(csvString);
  }

  static CsvImportResult _parseCsvString(String csvString) {
    final List<Result> validResults = [];
    final List<String> errors = [];
    
    try {
      final rows = const CsvToListConverter().convert(
        csvString,
        eol: '\n',
        fieldDelimiter: ',',
      );
      
      if (rows.isEmpty) {
        errors.add('CSV file is empty');
        return CsvImportResult(
          results: [],
          errors: errors,
          successCount: 0,
          errorCount: 1,
        );
      }

      // Parse header row (case-insensitive)
      final headerRow = rows[0].map((e) => e.toString().toLowerCase().trim()).toList();
      
      // Map column indices
      final dateIndex = _findColumnIndex(headerRow, ['date', 'datum']);
      final disciplineIndex = _findColumnIndex(headerRow, ['discipline', 'disciplin']);
      final pointsIndex = _findColumnIndex(headerRow, ['points', 'points made', 'punten']);
      final inningsIndex = _findColumnIndex(headerRow, ['innings', 'beurten']);
      final highestRunIndex = _findColumnIndex(headerRow, ['highest run', 'hoogste serie', 'serie']);
      final adversaryIndex = _findColumnIndex(headerRow, ['adversary', 'opponent', 'tegenstander']);
      final competitionIndex = _findColumnIndex(headerRow, ['competition', 'competitie', 'tournament']);
      final outcomeIndex = _findColumnIndex(headerRow, ['outcome', 'result', 'uitslag', 'resultaat']);

      // Validate required columns
      if (dateIndex == -1) {
        errors.add('Required column "Date" not found in CSV');
      }
      if (disciplineIndex == -1) {
        errors.add('Required column "Discipline" not found in CSV');
      }
      if (pointsIndex == -1) {
        errors.add('Required column "Points" not found in CSV');
      }
      if (inningsIndex == -1) {
        errors.add('Required column "Innings" not found in CSV');
      }
      if (highestRunIndex == -1) {
        errors.add('Required column "Highest Run" not found in CSV');
      }
      if (competitionIndex == -1) {
        errors.add('Required column "Competition" not found in CSV');
      }

      if (errors.isNotEmpty) {
        return CsvImportResult(
          results: [],
          errors: errors,
          successCount: 0,
          errorCount: errors.length,
        );
      }

      // Process data rows (skip header)
      for (int i = 1; i < rows.length; i++) {
        final row = rows[i];
        final rowNum = i + 1;

        try {
          // Skip empty rows
          if (row.isEmpty || row.every((cell) => cell.toString().trim().isEmpty)) {
            continue;
          }

          // Parse required fields
          final dateStr = row[dateIndex].toString().trim();
          final discipline = row[disciplineIndex].toString().trim();
          final pointsStr = row[pointsIndex].toString().trim();
          final inningsStr = row[inningsIndex].toString().trim();
          final highestRunStr = row[highestRunIndex].toString().trim();
          final competition = row[competitionIndex].toString().trim();

          if (dateStr.isEmpty) {
            errors.add('Row $rowNum: Date is required');
            continue;
          }
          if (discipline.isEmpty) {
            errors.add('Row $rowNum: Discipline is required');
            continue;
          }
          if (competition.isEmpty) {
            errors.add('Row $rowNum: Competition is required');
            continue;
          }

          // Parse date with multiple formats
          DateTime? date;
          try {
            date = _parseDate(dateStr);
          } catch (e) {
            errors.add('Row $rowNum: Invalid date format "$dateStr". Expected formats: YYYY-MM-DD, DD/MM/YYYY, or MM/DD/YYYY');
            continue;
          }

          // Parse numeric fields
          int? points;
          try {
            points = int.parse(pointsStr);
            if (points < 0) {
              errors.add('Row $rowNum: Points must be >= 0');
              continue;
            }
          } catch (e) {
            errors.add('Row $rowNum: Invalid points value "$pointsStr"');
            continue;
          }

          int? innings;
          try {
            innings = int.parse(inningsStr);
            if (innings <= 0) {
              errors.add('Row $rowNum: Innings must be > 0');
              continue;
            }
          } catch (e) {
            errors.add('Row $rowNum: Invalid innings value "$inningsStr"');
            continue;
          }

          int? highestRun;
          try {
            highestRun = int.parse(highestRunStr);
            if (highestRun < 0) {
              errors.add('Row $rowNum: Highest run must be >= 0');
              continue;
            }
            if (highestRun > points) {
              errors.add('Row $rowNum: Highest run ($highestRun) cannot exceed points ($points)');
              continue;
            }
          } catch (e) {
            errors.add('Row $rowNum: Invalid highest run value "$highestRunStr"');
            continue;
          }

          // Parse optional fields
          String? adversary;
          if (adversaryIndex != -1 && adversaryIndex < row.length) {
            final value = row[adversaryIndex].toString().trim();
            adversary = value.isEmpty ? null : value;
          }

          String? outcome;
          if (outcomeIndex != -1 && outcomeIndex < row.length) {
            final value = row[outcomeIndex].toString().toLowerCase().trim();
            if (value.isNotEmpty) {
              if (value == 'won' || value == 'gewonnen' || value == 'w' || value == 'g') {
                outcome = 'won';
              } else if (value == 'lost' || value == 'verloren' || value == 'l' || value == 'v') {
                outcome = 'lost';
              } else if (value == 'draw' || value == 'gelijk' || value == 'd') {
                outcome = 'draw';
              } else {
                errors.add('Row $rowNum: Warning - Invalid outcome "$value", will be imported as unknown');
              }
            }
          }

          // Create result object
          final result = Result(
            discipline: discipline,
            date: date,
            pointsMade: points,
            innings: innings,
            highestRun: highestRun,
            adversary: adversary,
            competition: competition,
            outcome: outcome,
          );

          validResults.add(result);
        } catch (e) {
          errors.add('Row $rowNum: Unexpected error - $e');
        }
      }

      return CsvImportResult(
        results: validResults,
        errors: errors,
        successCount: validResults.length,
        errorCount: errors.length,
      );
    } catch (e) {
      errors.add('Failed to parse CSV file: $e');
      return CsvImportResult(
        results: [],
        errors: errors,
        successCount: 0,
        errorCount: 1,
      );
    }
  }

  static int _findColumnIndex(List<String> headers, List<String> possibleNames) {
    for (final name in possibleNames) {
      final index = headers.indexWhere((h) => h == name);
      if (index != -1) return index;
    }
    return -1;
  }

  static DateTime _parseDate(String dateStr) {
    // Try common date formats
    final formats = [
      DateFormat('yyyy-MM-dd'),      // 2025-01-15
      DateFormat('dd/MM/yyyy'),      // 15/01/2025
      DateFormat('MM/dd/yyyy'),      // 01/15/2025
      DateFormat('yyyy/MM/dd'),      // 2025/01/15
      DateFormat('dd-MM-yyyy'),      // 15-01-2025
      DateFormat('MM-dd-yyyy'),      // 01-15-2025
      DateFormat('d/M/yyyy'),        // 1/1/2025
      DateFormat('M/d/yyyy'),        // 1/1/2025
    ];

    for (final format in formats) {
      try {
        return format.parseStrict(dateStr);
      } catch (_) {
        // Try next format
      }
    }

    throw FormatException('Unable to parse date: $dateStr');
  }

  static String generateExampleCsv() {
    return '''Date,Discipline,Points,Innings,Highest Run,Adversary,Competition,Outcome
2025-01-15,Free game - Small table,45,30,8,John Doe,Winter League,won
2025-01-20,3-cushion - Match table,25,25,5,Jane Smith,,lost
2025-01-22,Free game - Small table,38,28,6,,,draw''';
  }
}
