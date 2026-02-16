import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/user_settings.dart';
import '../models/result.dart';
import '../models/discipline_stats.dart';
import '../models/competition_stats.dart';
import '../models/classification_level.dart';
import '../services/database_service.dart';
import '../utils/season_helper.dart';
import '../widgets/stats_card.dart';
import 'discipline_detail_screen.dart';
import 'competition_detail_screen.dart';

enum DashboardViewMode { discipline, competition }

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  UserSettings? _settings;
  List<DisciplineStats> _disciplineStats = [];
  List<CompetitionStats> _competitionStats = [];
  Map<String, ClassificationLevel> _classifications = {};
  DateTime? _selectedSeasonStart;
  DateTime? _selectedSeasonEnd;
  DateTime? _currentSeasonStart;
  DateTime? _currentSeasonEnd;
  List<(DateTime, DateTime)> _availableSeasons = [];
  bool _isLoading = true;
  bool _isAllSeasonsView = false;
  DashboardViewMode _viewMode = DashboardViewMode.discipline;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// Public method to refresh dashboard data (called after adding/editing results)
  Future<void> refresh() async {
    await _loadData();
  }

  /// Refresh dashboard while preserving current season/view selection
  Future<void> _refreshCurrentView() async {
    if (_isAllSeasonsView) {
      await _onAllSeasonsSelected();
    } else if (_selectedSeasonStart != null && _selectedSeasonEnd != null) {
      await _onSeasonChanged((_selectedSeasonStart!, _selectedSeasonEnd!));
    } else {
      await _loadData();
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get user settings
      final settings = await DatabaseService.instance.getUserSettings();
      if (settings == null || !mounted) return;

      // Get current season
      final currentSeason = SeasonHelper.getCurrentSeason(settings);

      // Get available seasons
      final firstResultDate = await DatabaseService.instance.getFirstResultDate();
      final lastResultDate = DateTime.now();
      final availableSeasons = SeasonHelper.getAvailableSeasons(
        settings,
        firstResultDate,
        lastResultDate,
      );

      // Get results for current season
      final results = await DatabaseService.instance.getResultsBySeason(
        seasonStart: currentSeason.$1,
        seasonEnd: currentSeason.$2,
      );

      // Group by discipline and calculate stats
      final Map<String, List<Result>> resultsByDiscipline = {};
      for (final result in results) {
        resultsByDiscipline.putIfAbsent(result.discipline, () => []).add(result);
      }

      final disciplineStats = resultsByDiscipline.entries
          .map((entry) => DisciplineStats.fromResults(entry.key, entry.value))
          .toList();

      // Sort by discipline name
      disciplineStats.sort((a, b) => a.discipline.compareTo(b.discipline));

      // Group by competition and calculate stats
      final Map<String, List<Result>> resultsByCompetition = {};
      for (final result in results) {
        final competition = result.competition ?? '';
        if (competition.isNotEmpty) {
          resultsByCompetition.putIfAbsent(competition, () => []).add(result);
        }
      }

      final competitionStats = resultsByCompetition.entries
          .map((entry) => CompetitionStats.fromResults(entry.key, entry.value))
          .toList();

      // Sort by competition name
      competitionStats.sort((a, b) => a.competition.compareTo(b.competition));

      // Get classification levels
      final classificationsList = await DatabaseService.instance.getAllClassificationLevels();
      final classifications = {
        for (var c in classificationsList) c.discipline: c
      };

      if (mounted) {
        setState(() {
          _settings = settings;
          _selectedSeasonStart = currentSeason.$1;
          _selectedSeasonEnd = currentSeason.$2;
          _currentSeasonStart = currentSeason.$1;
          _currentSeasonEnd = currentSeason.$2;
          _availableSeasons = availableSeasons;
          _disciplineStats = disciplineStats;
          _competitionStats = competitionStats;
          _classifications = classifications;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _onSeasonChanged((DateTime, DateTime)? season) async {
    if (season == null || _settings == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Get results for selected season
      final results = await DatabaseService.instance.getResultsBySeason(
        seasonStart: season.$1,
        seasonEnd: season.$2,
      );

      // Group by discipline and calculate stats
      final Map<String, List<Result>> resultsByDiscipline = {};
      for (final result in results) {
        resultsByDiscipline.putIfAbsent(result.discipline, () => []).add(result);
      }

      final disciplineStats = resultsByDiscipline.entries
          .map((entry) => DisciplineStats.fromResults(entry.key, entry.value))
          .toList();

      // Sort by discipline name
      disciplineStats.sort((a, b) => a.discipline.compareTo(b.discipline));

      // Group by competition and calculate stats
      final Map<String, List<Result>> resultsByCompetition = {};
      for (final result in results) {
        final competition = result.competition ?? '';
        if (competition.isNotEmpty) {
          resultsByCompetition.putIfAbsent(competition, () => []).add(result);
        }
      }

      final competitionStats = resultsByCompetition.entries
          .map((entry) => CompetitionStats.fromResults(entry.key, entry.value))
          .toList();

      // Sort by competition name
      competitionStats.sort((a, b) => a.competition.compareTo(b.competition));

      if (mounted) {
        setState(() {
          _selectedSeasonStart = season.$1;
          _selectedSeasonEnd = season.$2;
          _disciplineStats = disciplineStats;
          _competitionStats = competitionStats;
          _isAllSeasonsView = false;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _onAllSeasonsSelected() async {
    if (_settings == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Get all results
      final allResults = await DatabaseService.instance.getAllResults();
      
      if (allResults.isEmpty) {
        if (mounted) {
          setState(() {
            _disciplineStats = [];
            _competitionStats = [];
            _isAllSeasonsView = true;
            _selectedSeasonStart = null;
            _selectedSeasonEnd = null;
            _isLoading = false;
          });
        }
        return;
      }

      // Group by discipline first
      final Map<String, List<Result>> resultsByDiscipline = {};
      for (final result in allResults) {
        resultsByDiscipline.putIfAbsent(result.discipline, () => []).add(result);
      }

      // For each discipline, aggregate by season
      final disciplineStats = <DisciplineStats>[];
      for (final entry in resultsByDiscipline.entries) {
        final discipline = entry.key;
        final results = entry.value;

        // Group results by season
        final Map<String, List<Result>> resultsBySeason = {};
        for (final result in results) {
          final season = SeasonHelper.getSeasonForDate(_settings!, result.date);
          final seasonKey = SeasonHelper.formatSeason(season.$1, season.$2);
          resultsBySeason.putIfAbsent(seasonKey, () => []).add(result);
        }

        // Create season-aggregated stats
        final seasonAverages = <double>[];
        int totalPoints = 0;
        int totalInnings = 0;
        int highestRunOverall = 0;
        int wonCount = 0;
        int lostCount = 0;
        int drawCount = 0;
        int unknownCount = 0;

        // Sort seasons chronologically
        final sortedSeasons = resultsBySeason.keys.toList()..sort();

        for (final seasonKey in sortedSeasons) {
          final seasonResults = resultsBySeason[seasonKey]!;
          
          // Calculate season totals
          int seasonPoints = 0;
          int seasonInnings = 0;
          int seasonHighestRun = 0;

          for (final result in seasonResults) {
            seasonPoints += result.pointsMade;
            seasonInnings += result.innings;
            if (result.highestRun > seasonHighestRun) {
              seasonHighestRun = result.highestRun;
            }
            if (result.highestRun > highestRunOverall) {
              highestRunOverall = result.highestRun;
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

          totalPoints += seasonPoints;
          totalInnings += seasonInnings;

          // Calculate season average
          final seasonAverage = seasonInnings > 0 ? seasonPoints / seasonInnings : 0.0;
          seasonAverages.add(seasonAverage);
        }

        final currentAverage = totalInnings > 0 ? totalPoints / totalInnings : 0.0;

        disciplineStats.add(DisciplineStats(
          discipline: discipline,
          results: results,
          currentAverage: currentAverage,
          highestRun: highestRunOverall,
          totalPoints: totalPoints,
          totalInnings: totalInnings,
          matchCount: results.length,
          wonCount: wonCount,
          lostCount: lostCount,
          drawCount: drawCount,
          unknownCount: unknownCount,
          averagesPerMatch: seasonAverages, // These are now season averages
        ));
      }

      // Sort by discipline name
      disciplineStats.sort((a, b) => a.discipline.compareTo(b.discipline));

      // Now do the same for competitions
      final Map<String, List<Result>> resultsByCompetition = {};
      for (final result in allResults) {
        final competition = result.competition ?? '';
        if (competition.isNotEmpty) {
          resultsByCompetition.putIfAbsent(competition, () => []).add(result);
        }
      }

      final competitionStats = <CompetitionStats>[];
      for (final entry in resultsByCompetition.entries) {
        final competition = entry.key;
        final results = entry.value;

        // Group results by season
        final Map<String, List<Result>> resultsBySeason = {};
        for (final result in results) {
          final season = SeasonHelper.getSeasonForDate(_settings!, result.date);
          final seasonKey = SeasonHelper.formatSeason(season.$1, season.$2);
          resultsBySeason.putIfAbsent(seasonKey, () => []).add(result);
        }

        // Create season-aggregated stats
        final seasonAverages = <double>[];
        int totalPoints = 0;
        int totalInnings = 0;
        int highestRunOverall = 0;
        int wonCount = 0;
        int lostCount = 0;
        int drawCount = 0;
        int unknownCount = 0;

        // Sort seasons chronologically
        final sortedSeasons = resultsBySeason.keys.toList()..sort();

        for (final seasonKey in sortedSeasons) {
          final seasonResults = resultsBySeason[seasonKey]!;
          
          // Calculate season totals
          int seasonPoints = 0;
          int seasonInnings = 0;
          int seasonHighestRun = 0;

          for (final result in seasonResults) {
            seasonPoints += result.pointsMade;
            seasonInnings += result.innings;
            if (result.highestRun > seasonHighestRun) {
              seasonHighestRun = result.highestRun;
            }
            if (result.highestRun > highestRunOverall) {
              highestRunOverall = result.highestRun;
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

          totalPoints += seasonPoints;
          totalInnings += seasonInnings;

          // Calculate season average
          final seasonAverage = seasonInnings > 0 ? seasonPoints / seasonInnings : 0.0;
          seasonAverages.add(seasonAverage);
        }

        final currentAverage = totalInnings > 0 ? totalPoints / totalInnings : 0.0;

        competitionStats.add(CompetitionStats(
          competition: competition,
          results: results,
          currentAverage: currentAverage,
          highestRun: highestRunOverall,
          totalPoints: totalPoints,
          totalInnings: totalInnings,
          matchCount: results.length,
          wonCount: wonCount,
          lostCount: lostCount,
          drawCount: drawCount,
          unknownCount: unknownCount,
          averagesPerMatch: seasonAverages, // These are now season averages
        ));
      }

      // Sort by competition name
      competitionStats.sort((a, b) => a.competition.compareTo(b.competition));

      if (mounted) {
        setState(() {
          _disciplineStats = disciplineStats;
          _competitionStats = competitionStats;
          _isAllSeasonsView = true;
          _selectedSeasonStart = null;
          _selectedSeasonEnd = null;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_settings == null) {
      return Center(
        child: Text(l10n.noResultsYet),
      );
    }

    return Column(
      children: [
        // Header with user name and season selector
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          color: theme.colorScheme.inversePrimary.withValues(alpha: 0.3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  _settings!.name,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (_availableSeasons.isNotEmpty) const SizedBox(height: 8),

              // Season selector
              if (_availableSeasons.isNotEmpty)
                DropdownButtonFormField<String>(
                  initialValue: _isAllSeasonsView
                      ? '__all_seasons__'
                      : (_selectedSeasonStart != null && _selectedSeasonEnd != null
                          ? SeasonHelper.formatSeason(_selectedSeasonStart!, _selectedSeasonEnd!)
                          : null),
                  decoration: InputDecoration(
                    labelText: l10n.selectSeason,
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: [
                    // All Seasons option
                    DropdownMenuItem(
                      value: '__all_seasons__',
                      child: Text(l10n.allSeasons),
                    ),
                    // Individual seasons
                    ..._availableSeasons.map((season) {
                      final seasonStr = SeasonHelper.formatSeason(season.$1, season.$2);
                      final isCurrentSeason = _currentSeasonStart == season.$1 &&
                          _currentSeasonEnd == season.$2;
                      return DropdownMenuItem(
                        value: seasonStr,
                        child: Text(
                          seasonStr +
                              (isCurrentSeason ? ' (${l10n.currentSeason})' : ''),
                        ),
                      );
                    }),
                  ],
                  onChanged: (String? value) {
                    if (value == null) return;
                    if (value == '__all_seasons__') {
                      _onAllSeasonsSelected();
                    } else {
                      // Find the season that matches this string
                      final season = _availableSeasons.firstWhere(
                        (s) => SeasonHelper.formatSeason(s.$1, s.$2) == value,
                      );
                      _onSeasonChanged(season);
                    }
                  },
                ),
              
              // View mode toggle
              if (_availableSeasons.isNotEmpty) const SizedBox(height: 12),
              if (_availableSeasons.isNotEmpty)
                SegmentedButton<DashboardViewMode>(
                  selected: {_viewMode},
                  onSelectionChanged: (Set<DashboardViewMode> newSelection) {
                    setState(() {
                      _viewMode = newSelection.first;
                    });
                  },
                  segments: [
                    ButtonSegment<DashboardViewMode>(
                      value: DashboardViewMode.discipline,
                      label: Text(l10n.viewByDiscipline),
                      icon: const Icon(Icons.sports),
                    ),
                    ButtonSegment<DashboardViewMode>(
                      value: DashboardViewMode.competition,
                      label: Text(l10n.viewByCompetition),
                      icon: const Icon(Icons.emoji_events),
                    ),
                  ],
                ),
            ],
          ),
        ),

        // Content
        Expanded(
          child: _buildContent(l10n),
        ),
      ],
    );
  }

  Widget _buildContent(AppLocalizations l10n) {
    final hasData = _viewMode == DashboardViewMode.discipline
        ? _disciplineStats.isNotEmpty
        : _competitionStats.isNotEmpty;

    if (!hasData) {
      return _buildEmptyState(l10n);
    }

    return _viewMode == DashboardViewMode.discipline
        ? _buildStatsGrid(_disciplineStats)
        : _buildStatsGrid(_competitionStats);
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _availableSeasons.isEmpty
                  ? l10n.noResultsYet
                  : l10n.noResultsThisSeason,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
            const SizedBox(height: 8),
            if (_availableSeasons.isEmpty)
              Text(
                l10n.addFirstResult,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade500,
                    ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(List<dynamic> statsList) {
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.68,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: statsList.length,
      itemBuilder: (context, index) {
        final stats = statsList[index];
        
        if (stats is DisciplineStats) {
          return _buildDisciplineCard(stats);
        } else if (stats is CompetitionStats) {
          return _buildCompetitionCard(stats);
        }
        
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildDisciplineCard(DisciplineStats stats) {
    final classification = _classifications[stats.discipline];
    final l10n = AppLocalizations.of(context)!;
    
    return StatsCard.fromDiscipline(
      stats: stats,
      classification: classification,
      onTap: () async {
        final seasonLabel = _isAllSeasonsView
            ? l10n.allSeasons
            : (_selectedSeasonStart != null && _selectedSeasonEnd != null
                ? SeasonHelper.formatSeason(_selectedSeasonStart!, _selectedSeasonEnd!)
                : l10n.currentSeason);
        
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DisciplineDetailScreen(
              discipline: stats.discipline,
              currentSeasonLabel: seasonLabel,
              selectedSeasonStart: _selectedSeasonStart,
              selectedSeasonEnd: _selectedSeasonEnd,
              isAllSeasonsView: _isAllSeasonsView,
            ),
          ),
        );
        
        // Refresh dashboard after returning (in case results were edited/deleted)
        if (mounted) {
          _refreshCurrentView();
        }
      },
    );
  }

  Widget _buildCompetitionCard(CompetitionStats stats) {
    final l10n = AppLocalizations.of(context)!;
    
    return StatsCard.fromCompetition(
      stats: stats,
      onTap: () async {
        final seasonLabel = _isAllSeasonsView
            ? l10n.allSeasons
            : (_selectedSeasonStart != null && _selectedSeasonEnd != null
                ? SeasonHelper.formatSeason(_selectedSeasonStart!, _selectedSeasonEnd!)
                : l10n.currentSeason);
        
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CompetitionDetailScreen(
              competition: stats.competition,
              currentSeasonLabel: seasonLabel,
              selectedSeasonStart: _selectedSeasonStart,
              selectedSeasonEnd: _selectedSeasonEnd,
              isAllSeasonsView: _isAllSeasonsView,
            ),
          ),
        );
        
        // Refresh dashboard after returning (in case results were edited/deleted)
        if (mounted) {
          _refreshCurrentView();
        }
      },
    );
  }
}
