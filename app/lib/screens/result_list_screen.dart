import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../models/result.dart';
import '../models/classification_level.dart';
import '../services/database_service.dart';
import '../widgets/background_wrapper.dart';
import 'add_result_screen.dart';

class ResultListScreen extends StatefulWidget {
  final String? discipline;
  final String? competition;
  final DateTime? seasonStart;
  final DateTime? seasonEnd;

  const ResultListScreen({
    super.key,
    this.discipline,
    this.competition,
    this.seasonStart,
    this.seasonEnd,
  }) : assert(discipline != null || competition != null, 
         'Either discipline or competition must be provided');

  @override
  State<ResultListScreen> createState() => _ResultListScreenState();
}

class _ResultListScreenState extends State<ResultListScreen> {
  List<Result> _allResults = [];
  List<Result> _filteredResults = [];
  List<String> _competitions = [];
  List<String> _adversaries = [];
  ClassificationLevel? _classificationLevel;
  
  String? _selectedCompetition;
  String? _selectedAdversary;
  
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadResults();
  }

  Future<void> _loadResults() async {
    setState(() => _isLoading = true);

    final db = DatabaseService.instance;
    List<Result> results;

    // Load results based on discipline or competition
    if (widget.discipline != null) {
      if (widget.seasonStart != null && widget.seasonEnd != null) {
        results = await db.getResultsByDisciplineAndSeason(
          discipline: widget.discipline!,
          seasonStart: widget.seasonStart!,
          seasonEnd: widget.seasonEnd!,
        );
      } else {
        results = await db.getResultsByDiscipline(widget.discipline!);
      }
    } else if (widget.competition != null) {
      if (widget.seasonStart != null && widget.seasonEnd != null) {
        results = await db.getResultsByCompetitionAndSeason(
          competition: widget.competition!,
          seasonStart: widget.seasonStart!,
          seasonEnd: widget.seasonEnd!,
        );
      } else {
        results = await db.getResultsByCompetition(widget.competition!);
      }
    } else {
      results = [];
    }

    // Sort by date descending (newest first)
    results.sort((a, b) => b.date.compareTo(a.date));

    // Extract unique competitions and adversaries
    final competitions = results
        .where((r) => r.competition != null && r.competition!.isNotEmpty)
        .map((r) => r.competition!)
        .toSet()
        .toList()
      ..sort();

    final adversaries = results
        .where((r) => r.adversary != null && r.adversary!.isNotEmpty)
        .map((r) => r.adversary!)
        .toSet()
        .toList()
      ..sort();

    // Load classification level if viewing by discipline
    ClassificationLevel? classification;
    if (widget.discipline != null) {
      classification = await db.getClassificationLevel(
        widget.discipline!,
        seasonStart: widget.seasonStart,
        seasonEnd: widget.seasonEnd,
      );
    }

    setState(() {
      _allResults = results;
      _filteredResults = results;
      _competitions = competitions;
      _adversaries = adversaries;
      _classificationLevel = classification;
      _isLoading = false;
    });
  }

  void _applyFilters() {
    setState(() {
      _filteredResults = _allResults.where((result) {
        if (_selectedCompetition != null && 
            result.competition != _selectedCompetition) {
          return false;
        }
        if (_selectedAdversary != null && 
            result.adversary != _selectedAdversary) {
          return false;
        }
        return true;
      }).toList();
    });
  }

  void _clearFilters() {
    setState(() {
      _selectedCompetition = null;
      _selectedAdversary = null;
      _filteredResults = _allResults;
    });
  }

  Future<void> _showFilterDialog() async {
    final l10n = AppLocalizations.of(context)!;
    
    String? tempCompetition = _selectedCompetition;
    String? tempAdversary = _selectedAdversary;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(l10n.filterResults),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String?>(
                decoration: InputDecoration(
                  labelText: l10n.filterByCompetition,
                ),
                initialValue: tempCompetition,
                items: [
                  DropdownMenuItem(
                    value: null,
                    child: Text(l10n.allCompetitions),
                  ),
                  ..._competitions.map((c) => DropdownMenuItem(
                        value: c,
                        child: Text(c),
                      )),
                ],
                onChanged: (value) {
                  setDialogState(() => tempCompetition = value);
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String?>(
                decoration: InputDecoration(
                  labelText: l10n.filterByAdversary,
                ),
                initialValue: tempAdversary,
                items: [
                  DropdownMenuItem(
                    value: null,
                    child: Text(l10n.allAdversaries),
                  ),
                  ..._adversaries.map((a) => DropdownMenuItem(
                        value: a,
                        child: Text(a),
                      )),
                ],
                onChanged: (value) {
                  setDialogState(() => tempAdversary = value);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedCompetition = null;
                  _selectedAdversary = null;
                });
                _clearFilters();
                Navigator.of(context).pop();
              },
              child: Text(l10n.clearFilters),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedCompetition = tempCompetition;
                  _selectedAdversary = tempAdversary;
                });
                _applyFilters();
                Navigator.of(context).pop();
              },
              child: Text(l10n.applyFilters),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editResult(Result result) async {
    final updated = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => AddResultScreen(existingResult: result),
      ),
    );

    if (updated == true) {
      _loadResults();
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.resultUpdated)),
        );
      }
    }
  }

  Future<void> _deleteResult(Result result) async {
    final l10n = AppLocalizations.of(context)!;
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmDelete),
        content: Text(l10n.confirmDeleteMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: Text(l10n.deleteResult),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await DatabaseService.instance.deleteResult(result.id!);
      _loadResults();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.resultDeleted)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final titlePrefix = widget.discipline ?? widget.competition ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('$titlePrefix - ${l10n.resultList}'),
        actions: [
          if (_competitions.isNotEmpty || _adversaries.isNotEmpty)
            IconButton(
              icon: Badge(
                isLabelVisible: _selectedCompetition != null || _selectedAdversary != null,
                child: const Icon(Icons.filter_list),
              ),
              onPressed: _showFilterDialog,
            ),
        ],
      ),
      body: BackgroundWrapper(
        child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _filteredResults.isEmpty
              ? Center(
                  child: Text(
                    _selectedCompetition != null || _selectedAdversary != null
                        ? l10n.noMatchingResults
                        : l10n.noDataAvailable,
                  ),
                )
              : ListView.builder(
                  itemCount: _filteredResults.length,
                  itemBuilder: (context, index) {
                    final result = _filteredResults[index];
                    return ResultListItem(
                      result: result,
                      classification: _classificationLevel,
                      onEdit: () => _editResult(result),
                      onDelete: () => _deleteResult(result),
                    );
                  },
                ),
      ),
    );
  }
}

class ResultListItem extends StatelessWidget {
  final Result result;
  final ClassificationLevel? classification;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ResultListItem({
    super.key,
    required this.result,
    this.classification,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final dateFormat = DateFormat.yMMMd();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row with date, outcome dot, and actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (result.outcome != null) ...[
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: _getOutcomeColor(result.outcome!),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      dateFormat.format(result.date),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      tooltip: l10n.editResult,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: onEdit,
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20),
                      tooltip: l10n.deleteResult,
                      color: Colors.red,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: onDelete,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Main statistics in a single row with abbreviations
            Row(
              children: [
                Expanded(
                  child: _buildStatBox(
                    l10n.pointsAbbr,  // Localized Points abbreviation
                    result.pointsMade.toString(),
                    theme,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _buildStatBox(
                    l10n.inningsAbbr,  // Localized Innings abbreviation
                    result.innings.toString(),
                    theme,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _buildStatBox(
                    l10n.averageAbbr,  // Localized Average abbreviation
                    result.average.toStringAsFixed(2),
                    theme,
                    isHighlight: true,
                    classificationColor: _getAverageColor(),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _buildStatBox(
                    l10n.highestRunAbbr,  // Localized Highest Series abbreviation
                    result.highestRun.toString(),
                    theme,
                  ),
                ),
              ],
            ),
            
            // Competition and adversary info
            if (result.competition != null && result.competition!.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildInfoRow(
                Icons.emoji_events,
                l10n.competitionLabel,
                result.competition!,
                theme,
              ),
            ],
            if (result.adversary != null && result.adversary!.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.person,
                l10n.adversaryLabel,
                result.adversary!,
                theme,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatBox(
    String label,
    String value,
    ThemeData theme, {
    bool isHighlight = false,
    Color? classificationColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: classificationColor ?? (isHighlight
            ? theme.primaryColor.withValues(alpha: 0.1)
            : theme.colorScheme.surfaceContainerHighest),
        borderRadius: BorderRadius.circular(8),
        border: isHighlight && classificationColor == null
            ? Border.all(color: theme.primaryColor.withValues(alpha: 0.3))
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              fontSize: 10,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value,
    ThemeData theme,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: theme.textTheme.bodyMedium,
              children: [
                TextSpan(
                  text: '$label: ',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                TextSpan(
                  text: value,
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Color? _getAverageColor() {
    if (classification == null) return null;

    if (result.average > classification!.maxAverage) {
      return Colors.green.shade100;
    } else if (result.average < classification!.minAverage) {
      return Colors.red.shade100;
    }
    return null;
  }

  Color? _getOutcomeColor(String outcome) {
    switch (outcome) {
      case 'won':
        return Colors.green;
      case 'lost':
        return Colors.red;
      case 'draw':
        return Colors.orange;
      default:
        return null;
    }
  }
}
