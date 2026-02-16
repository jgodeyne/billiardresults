import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/result.dart';
import '../models/classification_level.dart';
import '../services/database_service.dart';
import '../utils/season_helper.dart';
import '../widgets/background_wrapper.dart';
import 'result_list_screen.dart';

class DisciplineDetailScreen extends StatefulWidget {
  final String discipline;
  final String currentSeasonLabel;
  final DateTime? selectedSeasonStart;
  final DateTime? selectedSeasonEnd;
  final bool isAllSeasonsView;

  const DisciplineDetailScreen({
    super.key,
    required this.discipline,
    required this.currentSeasonLabel,
    this.selectedSeasonStart,
    this.selectedSeasonEnd,
    this.isAllSeasonsView = false,
  });

  @override
  State<DisciplineDetailScreen> createState() => _DisciplineDetailScreenState();
}

class _DisciplineDetailScreenState extends State<DisciplineDetailScreen> {
  List<Result> _results = [];
  ClassificationLevel? _classificationLevel;
  bool _isLoading = true;
  DateTime? _currentSeasonStart;
  DateTime? _currentSeasonEnd;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final db = DatabaseService.instance;
    final settings = await db.getUserSettings();
    
    List<Result> results;
    DateTime? seasonStart;
    DateTime? seasonEnd;
    
    // If in all seasons view, load all results for this discipline
    if (widget.isAllSeasonsView) {
      results = await db.getResultsByDiscipline(widget.discipline);
      seasonStart = null;
      seasonEnd = null;
    }
    // Use the season passed from the dashboard, or fall back to current season
    else if (widget.selectedSeasonStart != null && widget.selectedSeasonEnd != null) {
      seasonStart = widget.selectedSeasonStart;
      seasonEnd = widget.selectedSeasonEnd;
      results = await db.getResultsByDisciplineAndSeason(
        discipline: widget.discipline,
        seasonStart: seasonStart!,
        seasonEnd: seasonEnd!,
      );
    } else if (settings != null) {
      final season = SeasonHelper.getCurrentSeason(settings);
      seasonStart = season.$1;
      seasonEnd = season.$2;
      results = await db.getResultsByDisciplineAndSeason(
        discipline: widget.discipline,
        seasonStart: seasonStart,
        seasonEnd: seasonEnd,
      );
    } else {
      results = await db.getResultsByDiscipline(widget.discipline);
    }

    // Sort by date ascending for charts
    results.sort((a, b) => a.date.compareTo(b.date));

    final classification = await db.getClassificationLevel(widget.discipline);

    setState(() {
      _results = results;
      _classificationLevel = classification;
      _currentSeasonStart = seasonStart;
      _currentSeasonEnd = seasonEnd;
      _isLoading = false;
    });
  }

  /// Aggregate results by season for chart display
  /// Returns list of (seasonLabel, average, highestRun) tuples
  Future<List<(String seasonLabel, double average, int highestRun)>> _aggregateResultsBySeason() async {
    if (_results.isEmpty) return [];
    
    final db = DatabaseService.instance;
    final settings = await db.getUserSettings();
    if (settings == null) return [];

    // Group results by season
    final Map<String, List<Result>> resultsBySeason = {};
    for (final result in _results) {
      final season = SeasonHelper.getSeasonForDate(settings, result.date);
      final seasonLabel = SeasonHelper.formatSeason(season.$1, season.$2);
      resultsBySeason.putIfAbsent(seasonLabel, () => []).add(result);
    }

    // Sort season labels chronologically
    final sortedSeasonLabels = resultsBySeason.keys.toList()..sort();

    // Calculate aggregated stats for each season
    final aggregatedData = <(String, double, int)>[];
    for (final seasonLabel in sortedSeasonLabels) {
      final seasonResults = resultsBySeason[seasonLabel]!;
      
      int totalPoints = 0;
      int totalInnings = 0;
      int maxHighestRun = 0;

      for (final result in seasonResults) {
        totalPoints += result.pointsMade;
        totalInnings += result.innings;
        if (result.highestRun > maxHighestRun) {
          maxHighestRun = result.highestRun;
        }
      }

      final seasonAverage = totalInnings > 0 ? totalPoints / totalInnings : 0.0;
      aggregatedData.add((seasonLabel, seasonAverage, maxHighestRun));
    }

    return aggregatedData;
  }

  String _getTrendText() {
    if (_results.length < 2) return '';
    
    final recentResults = _results.length <= 5 
        ? _results 
        : _results.sublist(_results.length - 5);
    
    final averages = recentResults
        .map((r) => r.pointsMade / r.innings)
        .toList();
    
    if (averages.length < 2) return '';
    
    final firstHalf = averages.sublist(0, averages.length ~/ 2);
    final secondHalf = averages.sublist(averages.length ~/ 2);
    
    final firstAvg = firstHalf.reduce((a, b) => a + b) / firstHalf.length;
    final secondAvg = secondHalf.reduce((a, b) => a + b) / secondHalf.length;
    
    final difference = secondAvg - firstAvg;
    final threshold = 0.05;
    
    final l10n = AppLocalizations.of(context)!;
    if (difference > threshold) return l10n.improving;
    if (difference < -threshold) return l10n.declining;
    return l10n.stable;
  }

  IconData _getTrendIcon() {
    if (_results.length < 2) return Icons.trending_flat;
    
    final recentResults = _results.length <= 5 
        ? _results 
        : _results.sublist(_results.length - 5);
    
    final averages = recentResults
        .map((r) => r.pointsMade / r.innings)
        .toList();
    
    if (averages.length < 2) return Icons.trending_flat;
    
    final firstHalf = averages.sublist(0, averages.length ~/ 2);
    final secondHalf = averages.sublist(averages.length ~/ 2);
    
    final firstAvg = firstHalf.reduce((a, b) => a + b) / firstHalf.length;
    final secondAvg = secondHalf.reduce((a, b) => a + b) / secondHalf.length;
    
    final difference = secondAvg - firstAvg;
    final threshold = 0.05;
    
    if (difference > threshold) return Icons.trending_up;
    if (difference < -threshold) return Icons.trending_down;
    return Icons.trending_flat;
  }

  Future<void> _navigateToResultList() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => ResultListScreen(
          discipline: widget.discipline,
          seasonStart: _currentSeasonStart,
          seasonEnd: _currentSeasonEnd,
        ),
      ),
    );

    // Reload data if changes were made
    if (result == true) {
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.detailTitle(widget.discipline)),
      ),
      floatingActionButton: _results.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _navigateToResultList,
              icon: const Icon(Icons.list),
              label: Text(l10n.resultList),
            )
          : null,
      body: BackgroundWrapper(
        child: Column(
        children: [
          // Season header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            color: theme.colorScheme.inversePrimary.withValues(alpha: 0.2),
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 20),
                const SizedBox(width: 8),
                Text(
                  widget.currentSeasonLabel,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          // Performance trend indicator
          if (_results.length >= 2)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Icon(_getTrendIcon(), size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '${l10n.performanceTrend}: ${_getTrendText()}',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          
          // Classification comparison
          if (_classificationLevel != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _buildClassificationComparison(),
            ),

          const Divider(),

          // Scrollable graphs
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _results.isEmpty
                    ? Center(child: Text(l10n.noDataAvailable))
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Average Evolution Chart
                            _buildChartSection(
                              l10n.averageEvolution,
                              _buildAverageEvolutionChart(),
                              theme,
                            ),
                            
                            const Divider(height: 32),
                            
                            // Highest Run Chart
                            _buildChartSection(
                              l10n.highestRunEvolution,
                              _buildHighestRunChart(),
                              theme,
                            ),
                            
                            const Divider(height: 32),
                            
                            // Outcome Ratio Chart
                            _buildChartSection(
                              l10n.outcomeRatio,
                              _buildOutcomeRatioChart(),
                              theme,
                            ),
                            
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildChartSection(String title, Widget chart, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 300,
          child: chart,
        ),
      ],
    );
  }

  Widget _buildClassificationComparison() {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    
    if (_results.isEmpty || _classificationLevel == null) {
      return const SizedBox.shrink();
    }

    final totalPoints = _results.fold<double>(
      0,
      (sum, r) => sum + r.pointsMade,
    );
    final totalInnings = _results.fold<double>(
      0,
      (sum, r) => sum + r.innings,
    );
    final currentAverage = totalPoints / totalInnings;

    final min = _classificationLevel!.minAverage;
    final max = _classificationLevel!.maxAverage;

    String status;
    Color color;
    
    if (currentAverage > max) {
      status = l10n.aboveTarget;
      color = Colors.green;
    } else if (currentAverage < min) {
      status = l10n.belowTarget;
      color = Colors.red;
    } else {
      status = l10n.withinTarget;
      color = theme.colorScheme.primary;
    }

    return Row(
      children: [
        Icon(Icons.flag, size: 20, color: color),
        const SizedBox(width: 8),
        Text(
          '$status: ${currentAverage.toStringAsFixed(2)} (${min.toStringAsFixed(2)} - ${max.toStringAsFixed(2)})',
          style: theme.textTheme.bodyMedium?.copyWith(color: color),
        ),
      ],
    );
  }

  Widget _buildAverageEvolutionChart() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder<List<(String, double, int)>>(
        future: widget.isAllSeasonsView ? _aggregateResultsBySeason() : Future.value([]),
        builder: (context, snapshot) {
          // Build chart data based on mode
          List<FlSpot> spots;
          int dataPointCount;
          List<String>? xAxisLabels;
          
          if (widget.isAllSeasonsView && snapshot.hasData && snapshot.data!.isNotEmpty) {
            // Season-aggregated mode
            final seasonData = snapshot.data!;
            spots = seasonData.asMap().entries.map((entry) {
              return FlSpot(entry.key.toDouble(), entry.value.$2);
            }).toList();
            dataPointCount = seasonData.length;
            xAxisLabels = seasonData.map((d) => d.$1).toList();
          } else {
            // Match-by-match mode
            spots = _results.asMap().entries.map((entry) {
              final index = entry.key;
              final result = entry.value;
              final average = result.pointsMade / result.innings;
              return FlSpot(index.toDouble(), average);
            }).toList();
            dataPointCount = _results.length;
          }

          return LineChart(
            LineChartData(
              gridData: const FlGridData(show: true),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toStringAsFixed(1),
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: xAxisLabels != null ? 50 : 30,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= dataPointCount) {
                        return const SizedBox.shrink();
                      }
                      if (xAxisLabels != null) {
                        // Show season labels
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Transform.rotate(
                            angle: -0.5,
                            child: Text(
                              xAxisLabels[index],
                              style: const TextStyle(fontSize: 9),
                            ),
                          ),
                        );
                      } else {
                        // Show match numbers
                        return Text(
                          '${index + 1}',
                          style: const TextStyle(fontSize: 10),
                        );
                      }
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: true),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: Theme.of(context).colorScheme.primary,
                  barWidth: 3,
                  dotData: const FlDotData(show: true),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  ),
                ),
                // Add target line if classification is set
                if (_classificationLevel != null && dataPointCount > 0)
                  LineChartBarData(
                    spots: [
                      FlSpot(0, _classificationLevel!.maxAverage),
                      FlSpot(
                        (dataPointCount - 1).toDouble(),
                        _classificationLevel!.maxAverage,
                      ),
                    ],
                    isCurved: false,
                    color: Colors.green.withValues(alpha: 0.5),
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
                    dashArray: [5, 5],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHighestRunChart() {
    final allTimeHigh = _results.fold<double>(
      0,
      (max, r) => r.highestRun > max ? r.highestRun.toDouble() : max,
    );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder<List<(String, double, int)>>(
        future: widget.isAllSeasonsView ? _aggregateResultsBySeason() : Future.value([]),
        builder: (context, snapshot) {
          // Build chart data based on mode
          List<FlSpot> spots;
          int dataPointCount;
          List<String>? xAxisLabels;
          
          if (widget.isAllSeasonsView && snapshot.hasData && snapshot.data!.isNotEmpty) {
            // Season-aggregated mode
            final seasonData = snapshot.data!;
            spots = seasonData.asMap().entries.map((entry) {
              return FlSpot(entry.key.toDouble(), entry.value.$3.toDouble());
            }).toList();
            dataPointCount = seasonData.length;
            xAxisLabels = seasonData.map((d) => d.$1).toList();
          } else {
            // Match-by-match mode
            spots = _results.asMap().entries.map((entry) {
              final index = entry.key;
              final result = entry.value;
              return FlSpot(index.toDouble(), result.highestRun.toDouble());
            }).toList();
            dataPointCount = _results.length;
          }

          return LineChart(
            LineChartData(
              gridData: const FlGridData(show: true),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: xAxisLabels != null ? 50 : 30,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= dataPointCount) {
                        return const SizedBox.shrink();
                      }
                      if (xAxisLabels != null) {
                        // Show season labels
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Transform.rotate(
                            angle: -0.5,
                            child: Text(
                              xAxisLabels[index],
                              style: const TextStyle(fontSize: 9),
                            ),
                          ),
                        );
                      } else {
                        // Show match numbers
                        return Text(
                          '${index + 1}',
                          style: const TextStyle(fontSize: 10),
                        );
                      }
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: true),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: Theme.of(context).colorScheme.secondary,
                  barWidth: 3,
                  dotData: FlDotData(
                    show: true,
                    checkToShowDot: (spot, barData) {
                      // Highlight all-time high
                      return spot.y == allTimeHigh;
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOutcomeRatioChart() {
    final wonCount = _results.where((r) => r.outcome == 'won').length;
    final lostCount = _results.where((r) => r.outcome == 'lost').length;
    final drawCount = _results.where((r) => r.outcome == 'draw').length;
    final unknownCount = _results.where((r) => r.outcome == null).length;

    final total = _results.length;
    if (total == 0) {
      final l10n = AppLocalizations.of(context)!;
      return Center(child: Text(l10n.noDataAvailable));
    }

    final l10n = AppLocalizations.of(context)!;
    final sections = <PieChartSectionData>[];

    if (wonCount > 0) {
      sections.add(PieChartSectionData(
        value: wonCount.toDouble(),
        title: '${l10n.won}\n${(wonCount * 100 / total).toStringAsFixed(1)}%',
        color: Colors.green,
        radius: 100,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ));
    }

    if (lostCount > 0) {
      sections.add(PieChartSectionData(
        value: lostCount.toDouble(),
        title: '${l10n.lost}\n${(lostCount * 100 / total).toStringAsFixed(1)}%',
        color: Colors.red,
        radius: 100,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ));
    }

    if (drawCount > 0) {
      sections.add(PieChartSectionData(
        value: drawCount.toDouble(),
        title: '${l10n.draw}\n${(drawCount * 100 / total).toStringAsFixed(1)}%',
        color: Colors.orange,
        radius: 100,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ));
    }

    if (unknownCount > 0) {
      sections.add(PieChartSectionData(
        value: unknownCount.toDouble(),
        title: '${l10n.unknown}\n${(unknownCount * 100 / total).toStringAsFixed(1)}%',
        color: Colors.grey,
        radius: 100,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ));
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: PieChart(
        PieChartData(
          sections: sections,
          sectionsSpace: 2,
          centerSpaceRadius: 0,
        ),
      ),
    );
  }
}
