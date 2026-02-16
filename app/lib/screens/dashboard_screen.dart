import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/user_settings.dart';
import '../models/result.dart';
import '../models/discipline_stats.dart';
import '../models/classification_level.dart';
import '../services/database_service.dart';
import '../utils/season_helper.dart';
import '../widgets/discipline_card.dart';
import 'discipline_detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  UserSettings? _settings;
  List<DisciplineStats> _disciplineStats = [];
  Map<String, ClassificationLevel> _classifications = {};
  DateTime? _selectedSeasonStart;
  DateTime? _selectedSeasonEnd;
  List<(DateTime, DateTime)> _availableSeasons = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// Public method to refresh dashboard data (called after adding/editing results)
  Future<void> refresh() async {
    await _loadData();
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
          _availableSeasons = availableSeasons;
          _disciplineStats = disciplineStats;
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

      if (mounted) {
        setState(() {
          _selectedSeasonStart = season.$1;
          _selectedSeasonEnd = season.$2;
          _disciplineStats = disciplineStats;
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
          padding: const EdgeInsets.all(16.0),
          color: theme.colorScheme.inversePrimary.withValues(alpha: 0.3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  _settings!.name,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Season selector
              if (_availableSeasons.isNotEmpty)
                DropdownButtonFormField<String>(
                  initialValue: _selectedSeasonStart != null && _selectedSeasonEnd != null
                      ? SeasonHelper.formatSeason(_selectedSeasonStart!, _selectedSeasonEnd!)
                      : null,
                  decoration: InputDecoration(
                    labelText: l10n.selectSeason,
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: _availableSeasons.map((season) {
                    final seasonStr = SeasonHelper.formatSeason(season.$1, season.$2);
                    final isCurrentSeason = _selectedSeasonStart == season.$1 &&
                        _selectedSeasonEnd == season.$2;
                    return DropdownMenuItem(
                      value: seasonStr,
                      child: Text(
                        seasonStr +
                            (isCurrentSeason ? ' (${l10n.currentSeason})' : ''),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    if (value == null) return;
                    // Find the season that matches this string
                    final season = _availableSeasons.firstWhere(
                      (s) => SeasonHelper.formatSeason(s.$1, s.$2) == value,
                    );
                    _onSeasonChanged(season);
                  },
                ),
            ],
          ),
        ),

        // Content
        Expanded(
          child: _disciplineStats.isEmpty
              ? _buildEmptyState(l10n)
              : _buildDisciplineGrid(),
        ),
      ],
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sports_baseball,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
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

  Widget _buildDisciplineGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.68,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _disciplineStats.length,
      itemBuilder: (context, index) {
        final stats = _disciplineStats[index];
        final classification = _classifications[stats.discipline];

        return DisciplineCard(
          stats: stats,
          classification: classification,
          onTap: () async {
            final l10n = AppLocalizations.of(context)!;
            final seasonLabel = _selectedSeasonStart != null && _selectedSeasonEnd != null
                ? SeasonHelper.formatSeason(_selectedSeasonStart!, _selectedSeasonEnd!)
                : l10n.currentSeason;
            
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisciplineDetailScreen(
                  discipline: stats.discipline,
                  currentSeasonLabel: seasonLabel,
                ),
              ),
            );
            
            // Refresh dashboard after returning (in case results were edited/deleted)
            if (mounted) {
              _loadData();
            }
          },
        );
      },
    );
  }
}
