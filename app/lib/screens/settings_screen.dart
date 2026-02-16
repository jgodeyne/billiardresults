import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../l10n/app_localizations.dart';
import '../models/user_settings.dart';
import '../models/classification_level.dart';
import '../services/database_service.dart';
import '../services/csv_import_service.dart';
import '../main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _nameController = TextEditingController();
  int? _seasonStartDay;
  int? _seasonStartMonth;
  String? _selectedLanguage;
  List<String> _disciplines = [];
  Map<String, ClassificationLevel> _classifications = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    try {
      final settings = await DatabaseService.instance.getUserSettings();
      final disciplines = await DatabaseService.instance.getAllDisciplines();
      final classifications = await DatabaseService.instance.getAllClassificationLevels();

      if (mounted) {
        setState(() {
          if (settings != null) {
            _nameController.text = settings.name;
            _seasonStartDay = settings.seasonStartDay;
            _seasonStartMonth = settings.seasonStartMonth;
            _selectedLanguage = settings.language;
          }
          _disciplines = disciplines;
          _classifications = {
            for (var c in classifications) c.discipline: c
          };
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.errorLoadingSettings}: $e')),
        );
      }
    }
  }

  String _getMonthName(BuildContext context, int month) {
    final l10n = AppLocalizations.of(context)!;
    switch (month) {
      case 1:
        return l10n.january;
      case 2:
        return l10n.february;
      case 3:
        return l10n.march;
      case 4:
        return l10n.april;
      case 5:
        return l10n.may;
      case 6:
        return l10n.june;
      case 7:
        return l10n.july;
      case 8:
        return l10n.august;
      case 9:
        return l10n.september;
      case 10:
        return l10n.october;
      case 11:
        return l10n.november;
      case 12:
        return l10n.december;
      default:
        return '';
    }
  }

  Future<void> _saveSettings() async {
    final l10n = AppLocalizations.of(context)!;
    
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.nameError)),
      );
      return;
    }

    if (_seasonStartDay == null || _seasonStartMonth == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.seasonStartError)),
      );
      return;
    }

    try {
      final settings = UserSettings(
        name: _nameController.text.trim(),
        seasonStartDay: _seasonStartDay!,
        seasonStartMonth: _seasonStartMonth!,
        language: _selectedLanguage ?? 'en',
      );

      await DatabaseService.instance.saveUserSettings(settings);
      
      if (mounted) {
        // Update app state
        context.read<AppState>().updateSettings(settings);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.settingsSaved)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.errorSavingSettings}: $e')),
        );
      }
    }
  }

  Future<void> _importFromCsv() async {
    final l10n = AppLocalizations.of(context)!;
    
    try {
      // Pick CSV file
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        withData: false,
        withReadStream: false,
      );

      if (result == null || result.files.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.noFileSelected)),
          );
        }
        return;
      }

      final filePath = result.files.first.path;
      if (filePath == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.importFailed)),
          );
        }
        return;
      }

      // Show loading indicator
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      // Parse and validate CSV
      final importResult = await CsvImportService.parseAndValidateCsv(filePath);
      
      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      if (!importResult.hasResults && importResult.hasErrors) {
        // Show errors
        if (mounted) {
          _showImportErrors(importResult.errors);
        }
        return;
      }

      // Show preview and confirmation
      if (mounted) {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(l10n.importConfirmTitle(importResult.successCount)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.importConfirmMessage(importResult.successCount)),
                if (importResult.hasErrors) ...[
                  const SizedBox(height: 16),
                  Text(
                    l10n.importErrors(importResult.errorCount),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.cancel),
              ),
              if (importResult.hasErrors)
                TextButton(
                  onPressed: () => _showImportErrors(importResult.errors),
                  child: Text('View Errors'),
                ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(l10n.importResults),
              ),
            ],
          ),
        );

        if (confirmed != true || !mounted) return;

        // Import results to database
        final db = DatabaseService.instance;
        int imported = 0;
        
        for (final result in importResult.results) {
          try {
            await db.createResult(result);
            imported++;
          } catch (e) {
            // Skip failed inserts
          }
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.importSuccess(imported))),
          );
          
          // Reload settings to refresh disciplines list
          _loadSettings();
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.importFailed}: $e')),
        );
      }
    }
  }

  void _showImportErrors(List<String> errors) {
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.importErrors(errors.length)),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: errors.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                '\u2022 ${errors[index]}',
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }

  void _showCsvFormatHelp() {
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.csvFormatHelp),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.csvFormatDescription),
              const SizedBox(height: 16),
              const Text(
                'Example:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  CsvImportService.generateExampleCsv(),
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAllData() async {
    final l10n = AppLocalizations.of(context)!;
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteAllDataConfirmTitle),
        content: Text(l10n.deleteAllDataConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      await DatabaseService.instance.deleteAllResults();
      await DatabaseService.instance.deleteDatabase();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.dataDeleted)),
        );
        
        // Navigate to onboarding
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/onboarding',
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _editClassification(String discipline) async {
    final l10n = AppLocalizations.of(context)!;
    final existing = _classifications[discipline];
    
    final minController = TextEditingController(
      text: existing?.minAverage.toString() ?? '',
    );
    final maxController = TextEditingController(
      text: existing?.maxAverage.toString() ?? '',
    );

    final result = await showDialog<ClassificationLevel>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(discipline),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: minController,
                decoration: InputDecoration(
                  labelText: l10n.minimumAverage,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*[.,]?\d*')),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: maxController,
                decoration: InputDecoration(
                  labelText: l10n.maximumAverage,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*[.,]?\d*')),
                ],
              ),
            ],
          ),
        ),
        actions: [
          if (existing != null)
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: Text(l10n.delete),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              // Replace comma with period for parsing (European number format)
              final min = double.tryParse(minController.text.replaceAll(',', '.'));
              final max = double.tryParse(maxController.text.replaceAll(',', '.'));
              
              if (min != null && max != null && min < max) {
                Navigator.pop(
                  context,
                  ClassificationLevel(
                    discipline: discipline,
                    minAverage: min,
                    maxAverage: max,
                  ),
                );
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );

    // Dispose controllers after a small delay to let dialog animation complete
    Future.delayed(const Duration(milliseconds: 100), () {
      minController.dispose();
      maxController.dispose();
    });

    if (!mounted) return;

    if (result == null && existing != null) {
      // Delete classification
      final l10nDialog = AppLocalizations.of(context)!;
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10nDialog.deleteClassificationTitle),
          content: Text(l10nDialog.deleteClassificationMessage(discipline)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10nDialog.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              child: Text(l10nDialog.delete),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        await DatabaseService.instance.deleteClassificationLevel(discipline);
        setState(() {
          _classifications.remove(discipline);
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.classificationDeleted)),
          );
        }
      }
    } else if (result != null) {
      // Save classification
      await DatabaseService.instance.saveClassificationLevel(result);
      setState(() {
        _classifications[discipline] = result;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.classificationSaved)),
        );
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

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Profile section
        Text(
          l10n.editProfile,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        // Name field
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: l10n.nameLabel,
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.person),
          ),
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 16),
        
        // Season start - Day dropdown
        DropdownButtonFormField<int>(
          initialValue: _seasonStartDay,
          decoration: InputDecoration(
            labelText: l10n.seasonStartLabel,
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.calendar_today),
          ),
          hint: const Text('Day'),
          items: List.generate(31, (index) {
            final day = index + 1;
            return DropdownMenuItem(
              value: day,
              child: Text('$day'),
            );
          }),
          onChanged: (value) {
            setState(() {
              _seasonStartDay = value;
            });
          },
        ),
        const SizedBox(height: 16),
        
        // Season start - Month dropdown
        DropdownButtonFormField<int>(
          initialValue: _seasonStartMonth,
          decoration: const InputDecoration(
            labelText: 'Month',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.calendar_month),
          ),
          hint: const Text('Month'),
          items: List.generate(12, (index) {
            final month = index + 1;
            return DropdownMenuItem(
              value: month,
              child: Text(_getMonthName(context, month)),
            );
          }),
          onChanged: (value) {
            setState(() {
              _seasonStartMonth = value;
            });
          },
        ),
        const SizedBox(height: 16),
        
        // Language selector
        DropdownButtonFormField<String>(
          initialValue: _selectedLanguage,
          decoration: InputDecoration(
            labelText: l10n.languageLabel,
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.language),
          ),
          items: [
            DropdownMenuItem(value: 'en', child: Text(l10n.english)),
            DropdownMenuItem(value: 'nl', child: Text(l10n.dutch)),
            DropdownMenuItem(value: 'fr', child: Text(l10n.french)),
          ],
          onChanged: (value) {
            setState(() {
              _selectedLanguage = value;
            });
            if (value != null) {
              context.read<AppState>().updateLanguage(value);
            }
          },
        ),
        const SizedBox(height: 24),
        
        // Save button
        FilledButton(
          onPressed: _saveSettings,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(l10n.save),
          ),
        ),
        
        const SizedBox(height: 32),
        const Divider(),
        const SizedBox(height: 16),
        
        // Classification levels section
        Text(
          l10n.classificationLevels,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.classificationLevelsSubtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        
        if (_disciplines.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                l10n.noDisciplines,
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
              ),
            ),
          )
        else
          ..._disciplines.map((discipline) {
            final classification = _classifications[discipline];
            return Card(
              child: ListTile(
                title: Text(discipline),
                subtitle: classification != null
                    ? Text('${classification.minAverage} - ${classification.maxAverage}')
                    : Text(l10n.notSet),
                trailing: const Icon(Icons.edit),
                onTap: () => _editClassification(discipline),
              ),
            );
          }),
        
        const SizedBox(height: 32),
        const Divider(),
        const SizedBox(height: 16),
        
        // Data management section
        Text(
          l10n.dataManagement,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        // Import from CSV
        ListTile(
          leading: const Icon(Icons.upload_file),
          title: Text(l10n.importData),
          subtitle: Text(l10n.importDataDescription),
          onTap: _importFromCsv,
        ),
        const SizedBox(height: 8),
        
        // CSV Format Help
        OutlinedButton.icon(
          onPressed: _showCsvFormatHelp,
          icon: const Icon(Icons.help_outline),
          label: Text(l10n.csvFormatHelp),
        ),
        
        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 16),
        
        OutlinedButton(
          onPressed: _deleteAllData,
          style: OutlinedButton.styleFrom(
            foregroundColor: theme.colorScheme.error,
            side: BorderSide(color: theme.colorScheme.error),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(l10n.deleteAllData),
          ),
        ),
      ],
    );
  }
}

