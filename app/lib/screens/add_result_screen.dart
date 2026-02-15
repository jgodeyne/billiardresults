import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_localizations.dart';
import '../models/result.dart';
import '../services/database_service.dart';
import '../utils/constants.dart';

class AddResultScreen extends StatefulWidget {
  final Result? existingResult;

  const AddResultScreen({
    super.key,
    this.existingResult,
  });

  @override
  State<AddResultScreen> createState() => _AddResultScreenState();
}

class _AddResultScreenState extends State<AddResultScreen> {
  final _formKey = GlobalKey<FormState>();
  final _disciplineController = TextEditingController();
  final _pointsController = TextEditingController();
  final _inningsController = TextEditingController();
  final _highestRunController = TextEditingController();
  final _adversaryController = TextEditingController();
  final _competitionController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String? _selectedOutcome;
  bool _isLoading = false;
  List<String> _allDisciplines = [];
  List<String> _disciplineSuggestions = [];

  @override
  void initState() {
    super.initState();
    _loadDisciplines();
    
    // Pre-fill form if editing
    if (widget.existingResult != null) {
      final result = widget.existingResult!;
      _disciplineController.text = result.discipline;
      _selectedDate = result.date;
      _pointsController.text = result.pointsMade.toString();
      _inningsController.text = result.innings.toString();
      _highestRunController.text = result.highestRun.toString();
      _adversaryController.text = result.adversary ?? '';
      _selectedOutcome = result.outcome;
      _competitionController.text = result.competition ?? '';
    }
    
    // Listen to discipline changes for autocomplete
    _disciplineController.addListener(_updateDisciplineSuggestions);
  }

  @override
  void dispose() {
    _disciplineController.dispose();
    _pointsController.dispose();
    _inningsController.dispose();
    _highestRunController.dispose();
    _adversaryController.dispose();
    _competitionController.dispose();
    super.dispose();
  }

  Future<void> _loadDisciplines() async {
    final disciplines = await DatabaseService.instance.getAllDisciplines();
    setState(() {
      _allDisciplines = disciplines;
    });
  }

  void _updateDisciplineSuggestions() {
    final text = _disciplineController.text.toLowerCase();
    if (text.isEmpty) {
      setState(() {
        _disciplineSuggestions = [];
      });
      return;
    }

    final l10n = AppLocalizations.of(context)!;
    
    // Get localized suggested disciplines
    final suggestedDisciplines = [
      l10n.disciplineFreeSmall,
      l10n.disciplineFreeMatch,
      l10n.discipline1CushionSmall,
      l10n.discipline1CushionMatch,
      l10n.discipline3CushionSmall,
      l10n.discipline3CushionMatch,
      l10n.disciplineBalkline382Small,
      l10n.disciplineBalkline572Small,
      l10n.disciplineBalkline472Match,
      l10n.disciplineBalkline471Match,
      l10n.disciplineBalkline712Match,
    ];

    // Combine suggested and previously used disciplines
    final allOptions = [
      ...suggestedDisciplines,
      ..._allDisciplines,
    ];

    // Remove duplicates and filter
    final uniqueOptions = allOptions.toSet().toList();
    final filtered = uniqueOptions
        .where((d) => d.toLowerCase().contains(text))
        .toList();

    setState(() {
      _disciplineSuggestions = filtered;
    });
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String? _validatePoints(String? value) {
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty) {
      return l10n.pointsMadeError;
    }
    final points = int.tryParse(value);
    if (points == null || points < 0) {
      return l10n.pointsMadeError;
    }
    return null;
  }

  String? _validateInnings(String? value) {
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty) {
      return l10n.inningsError;
    }
    final innings = int.tryParse(value);
    if (innings == null || innings <= 0) {
      return l10n.inningsError;
    }
    return null;
  }

  String? _validateHighestRun(String? value) {
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty) {
      return l10n.highestRunError;
    }
    final highestRun = int.tryParse(value);
    if (highestRun == null || highestRun < 0) {
      return l10n.highestRunError;
    }

    final points = int.tryParse(_pointsController.text);
    if (points != null && highestRun > points) {
      return l10n.highestRunError;
    }

    return null;
  }

  Future<void> _showWarnings() async {
    final l10n = AppLocalizations.of(context)!;
    final warnings = <String>[];

    final points = int.tryParse(_pointsController.text);
    if (points != null && points > AppConstants.warningPointsThreshold) {
      warnings.add(l10n.warningHighPoints(AppConstants.warningPointsThreshold));
    }

    final innings = int.tryParse(_inningsController.text);
    if (innings != null && innings > AppConstants.warningInningsThreshold) {
      warnings.add(l10n.warningHighInnings(AppConstants.warningInningsThreshold));
    }

    final highestRun = int.tryParse(_highestRunController.text);
    if (highestRun != null && highestRun > AppConstants.warningHighestRunThreshold) {
      warnings.add(l10n.warningHighRun(AppConstants.warningHighestRunThreshold));
    }

    if (warnings.isNotEmpty) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Icon(Icons.warning, color: Colors.orange, size: 48),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: warnings
                .map((w) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(w),
                    ))
                .toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.save),
            ),
          ],
        ),
      );

      if (confirmed != true) {
        return;
      }
    }

    await _saveResult();
  }

  Future<void> _saveResult() async {
    final l10n = AppLocalizations.of(context)!;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = Result(
        id: widget.existingResult?.id,
        discipline: _disciplineController.text.trim(),
        date: _selectedDate,
        pointsMade: int.parse(_pointsController.text),
        innings: int.parse(_inningsController.text),
        highestRun: int.parse(_highestRunController.text),
        adversary: _adversaryController.text.trim().isEmpty
            ? null
            : _adversaryController.text.trim(),
        outcome: _selectedOutcome,
        competition: _competitionController.text.trim().isEmpty
            ? null
            : _competitionController.text.trim(),
      );

      if (widget.existingResult != null) {
        await DatabaseService.instance.updateResult(result);
      } else {
        await DatabaseService.instance.createResult(result);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.resultSaved)),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${l10n.errorSavingResult}: $e')),
      );
    } finally {
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
    final isEditing = widget.existingResult != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? l10n.editResult : l10n.addResult),
        backgroundColor: theme.colorScheme.inversePrimary,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Required fields section
            Text(
              l10n.requiredFields,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),

            // Discipline field with autocomplete
            Autocomplete<String>(
              optionsBuilder: (textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<String>.empty();
                }
                return _disciplineSuggestions;
              },
              onSelected: (selection) {
                _disciplineController.text = selection;
              },
              fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                // Sync with our controller
                controller.text = _disciplineController.text;
                controller.addListener(() {
                  _disciplineController.text = controller.text;
                });

                return TextFormField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    labelText: l10n.disciplineLabel,
                    hintText: l10n.disciplineHint,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.sports),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.disciplineError;
                    }
                    return null;
                  },
                  onEditingComplete: onEditingComplete,
                );
              },
            ),
            const SizedBox(height: 16),

            // Date picker
            InkWell(
              onTap: _selectDate,
              borderRadius: BorderRadius.circular(4),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: l10n.dateLabel,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.calendar_today),
                ),
                child: Text(
                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Points made
            TextFormField(
              controller: _pointsController,
              decoration: InputDecoration(
                labelText: l10n.pointsMadeLabel,
                hintText: l10n.pointsMadeHint,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.sports_score),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: _validatePoints,
            ),
            const SizedBox(height: 16),

            // Number of innings
            TextFormField(
              controller: _inningsController,
              decoration: InputDecoration(
                labelText: l10n.inningsLabel,
                hintText: l10n.inningsHint,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.numbers),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: _validateInnings,
            ),
            const SizedBox(height: 16),

            // Highest run
            TextFormField(
              controller: _highestRunController,
              decoration: InputDecoration(
                labelText: l10n.highestRunLabel,
                hintText: l10n.highestRunHint,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.trending_up),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: _validateHighestRun,
            ),
            const SizedBox(height: 32),

            // Optional fields section
            Text(
              l10n.optionalFields,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),

            // Adversary
            TextFormField(
              controller: _adversaryController,
              decoration: InputDecoration(
                labelText: l10n.adversaryLabel,
                hintText: l10n.adversaryHint,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.person_outline),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),

            // Match outcome
            DropdownButtonFormField<String>(
              initialValue: _selectedOutcome,
              decoration: InputDecoration(
                labelText: l10n.outcomeLabel,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.emoji_events),
              ),
              items: [
                DropdownMenuItem(value: 'won', child: Text(l10n.outcomeWon)),
                DropdownMenuItem(value: 'lost', child: Text(l10n.outcomeLost)),
                DropdownMenuItem(value: 'draw', child: Text(l10n.outcomeDraw)),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedOutcome = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // Competition
            TextFormField(
              controller: _competitionController,
              decoration: InputDecoration(
                labelText: l10n.competitionLabel,
                hintText: l10n.competitionHint,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.emoji_events_outlined),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 32),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(l10n.cancel),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: FilledButton(
                    onPressed: _isLoading ? null : _showWarnings,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(l10n.save),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
