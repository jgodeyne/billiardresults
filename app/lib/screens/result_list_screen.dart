import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../models/result.dart';
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

    setState(() {
      _allResults = results;
      _filteredResults = results;
      _competitions = competitions;
      _adversaries = adversaries;
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
                      onEdit: () => _editResult(result),
                      onDelete: () => _deleteResult(result),
                    );
                  },
                ),
      ),
    );
  }
}

class ResultListItem extends StatefulWidget {
  final Result result;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ResultListItem({
    super.key,
    required this.result,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<ResultListItem> createState() => _ResultListItemState();
}

class _ResultListItemState extends State<ResultListItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final dateFormat = DateFormat.yMMMd();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        children: [
          ListTile(
            title: Text(dateFormat.format(widget.result.date)),
            subtitle: Text(
              '${l10n.average}: ${widget.result.average.toStringAsFixed(2)}${widget.result.outcome != null ? ' • ${_getOutcomeText(widget.result.outcome!, l10n)}' : ''}',
            ),
            trailing: IconButton(
              icon: Icon(
                _isExpanded ? Icons.expand_less : Icons.expand_more,
              ),
              onPressed: () {
                setState(() => _isExpanded = !_isExpanded);
              },
            ),
            onTap: () {
              setState(() => _isExpanded = !_isExpanded);
            },
          ),
          if (_isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow(
                    l10n.pointsMadeLabel,
                    widget.result.pointsMade.toString(),
                    theme,
                  ),
                  _buildDetailRow(
                    l10n.inningsLabel,
                    widget.result.innings.toString(),
                    theme,
                  ),
                  _buildDetailRow(
                    l10n.highestRunLabel,
                    widget.result.highestRun.toString(),
                    theme,
                  ),
                  if (widget.result.adversary != null &&
                      widget.result.adversary!.isNotEmpty)
                    _buildDetailRow(
                      l10n.adversaryLabel,
                      widget.result.adversary!,
                      theme,
                    ),
                  if (widget.result.outcome != null)
                    _buildDetailRow(
                      l10n.outcomeLabel,
                      _getOutcomeText(widget.result.outcome!, l10n),
                      theme,
                    ),
                  if (widget.result.competition != null &&
                      widget.result.competition!.isNotEmpty)
                    _buildDetailRow(
                      l10n.competitionLabel,
                      widget.result.competition!,
                      theme,
                    ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        tooltip: l10n.editResult,
                        onPressed: widget.onEdit,
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        tooltip: l10n.deleteResult,
                        color: Colors.red,
                        onPressed: widget.onDelete,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  String _getOutcomeText(String outcome, AppLocalizations l10n) {
    switch (outcome) {
      case 'won':
        return l10n.won;
      case 'lost':
        return l10n.lost;
      case 'draw':
        return l10n.draw;
      default:
        return l10n.unknown;
    }
  }
}
