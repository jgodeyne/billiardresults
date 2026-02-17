import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../models/user_settings.dart';
import '../models/classification_level.dart';
import '../services/database_service.dart';
import '../services/csv_import_service.dart';
import '../services/cloud_backup_service.dart';
import '../utils/season_helper.dart';
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
  UserSettings? _settings;
  List<String> _disciplines = [];
  Map<String, ClassificationLevel> _classifications = {};
  bool _isLoading = true;
  
  // Season selection for classification levels
  DateTime? _selectedClassificationSeasonStart;
  DateTime? _selectedClassificationSeasonEnd;
  List<(DateTime, DateTime)> _availableSeasons = [];

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
      
      // Get available seasons
      final firstResultDate = await DatabaseService.instance.getFirstResultDate();
      final lastResultDate = DateTime.now();
      final availableSeasons = firstResultDate != null
          ? SeasonHelper.getAvailableSeasons(settings!, firstResultDate, lastResultDate)
          : <(DateTime, DateTime)>[];
      
      // Default to current season
      final currentSeason = settings != null 
          ? SeasonHelper.getCurrentSeason(settings)
          : null;
      
      // Load classifications for current season
      final classifications = settings != null && currentSeason != null
          ? await DatabaseService.instance.getAllClassificationLevels(
              seasonStart: currentSeason.$1,
              seasonEnd: currentSeason.$2,
            )
          : await DatabaseService.instance.getAllClassificationLevels();

      if (mounted) {
        setState(() {
          _settings = settings;
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
          _availableSeasons = availableSeasons;
          _selectedClassificationSeasonStart = currentSeason?.$1;
          _selectedClassificationSeasonEnd = currentSeason?.$2;
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

  int _getMaxDaysInMonth(int month) {
    switch (month) {
      case 2:
        return 29; // February (allowing for leap years)
      case 4:
      case 6:
      case 9:
      case 11:
        return 30;
      default:
        return 31;
    }
  }

  Future<void> _showDayPicker(BuildContext context) async {
    if (_seasonStartMonth == null) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.selectMonthFirst)),
      );
      return;
    }

    final maxDays = _getMaxDaysInMonth(_seasonStartMonth!);
    final initialDay = _seasonStartDay ?? 1;
    
    await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        int tempDay = initialDay > maxDays ? maxDays : initialDay;
        
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.selectDay),
          content: SizedBox(
            height: 250,
            width: 100,
            child: ListWheelScrollView.useDelegate(
              itemExtent: 50,
              diameterRatio: 1.5,
              physics: const FixedExtentScrollPhysics(),
              controller: FixedExtentScrollController(
                initialItem: tempDay - 1,
              ),
              onSelectedItemChanged: (index) {
                tempDay = index + 1;
              },
              childDelegate: ListWheelChildBuilderDelegate(
                builder: (context, index) {
                  if (index < 0 || index >= maxDays) return null;
                  final day = index + 1;
                  return Center(
                    child: Text(
                      '$day',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  );
                },
                childCount: maxDays,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            FilledButton(
              onPressed: () {
                setState(() {
                  _seasonStartDay = tempDay;
                });
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.confirm),
            ),
          ],
        );
      },
    );
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

  String _formatBackupDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return DateFormat.Hm().format(date);
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat.yMd().format(date);
    }
  }

  Future<void> _backupToCloud() async {
    final l10n = AppLocalizations.of(context)!;
    
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 20),
            Expanded(child: Text(l10n.backingUp)),
          ],
        ),
      ),
    );
    
    try {
      final backupService = CloudBackupService();
      await backupService.backupToCloud();
      
      // Close loading dialog
      if (mounted) Navigator.of(context).pop();
      
      // Reload settings to show updated timestamp
      await _loadSettings();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.backupSuccessful)),
        );
      }
    } catch (e) {
      // Close loading dialog
      if (mounted) Navigator.of(context).pop();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.backupFailed}: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _restoreFromCloud() async {
    final l10n = AppLocalizations.of(context)!;
    
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.restoreConfirmTitle),
        content: Text(l10n.restoreConfirmMessage),
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
            child: Text(l10n.restoreFromCloud),
          ),
        ],
      ),
    );
    
    if (confirmed != true || !mounted) return;
    
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 20),
            Expanded(child: Text(l10n.restoring)),
          ],
        ),
      ),
    );
    
    try {
      final backupService = CloudBackupService();
      await backupService.restoreFromCloud(merge: false);
      
      // Close loading dialog
      if (mounted) Navigator.of(context).pop();
      
      // Reload settings
      await _loadSettings();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.restoreSuccessful)),
        );
      }
    } catch (e) {
      // Close loading dialog
      if (mounted) Navigator.of(context).pop();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.restoreFailed}: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _updateAutoBackupEnabled(bool enabled) async {
    if (_settings == null) return;
    
    try {
      final updated = _settings!.copyWith(autoBackupEnabled: enabled);
      await DatabaseService.instance.saveUserSettings(updated);
      await _loadSettings();
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.errorSavingSettings}: $e')),
        );
      }
    }
  }

  Future<void> _selectAutoBackupFrequency() async {
    final l10n = AppLocalizations.of(context)!;
    
    final selected = await showDialog<AutoBackupFrequency>(
      context: context,
      builder: (context) {
        AutoBackupFrequency? tempValue = _settings?.autoBackupFrequency ?? AutoBackupFrequency.disabled;
        
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text(l10n.autoBackupFrequency),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildFrequencyOption(
                  context,
                  l10n.disabled,
                  AutoBackupFrequency.disabled,
                  tempValue,
                  (value) {
                    setState(() => tempValue = value);
                    Navigator.pop(context, value);
                  },
                ),
                _buildFrequencyOption(
                  context,
                  l10n.afterResults,
                  AutoBackupFrequency.afterResults,
                  tempValue,
                  (value) {
                    setState(() => tempValue = value);
                    Navigator.pop(context, value);
                  },
                ),
                _buildFrequencyOption(
                  context,
                  l10n.daily,
                  AutoBackupFrequency.daily,
                  tempValue,
                  (value) {
                    setState(() => tempValue = value);
                    Navigator.pop(context, value);
                  },
                ),
                _buildFrequencyOption(
                  context,
                  l10n.weekly,
                  AutoBackupFrequency.weekly,
                  tempValue,
                  (value) {
                    setState(() => tempValue = value);
                    Navigator.pop(context, value);
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.cancel),
              ),
            ],
          ),
        );
      },
    );
    
    if (selected != null && _settings != null) {
      try {
        final updated = _settings!.copyWith(autoBackupFrequency: selected);
        await DatabaseService.instance.saveUserSettings(updated);
        await _loadSettings();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${l10n.errorSavingSettings}: $e')),
          );
        }
      }
    }
  }

  Widget _buildFrequencyOption(
    BuildContext context,
    String title,
    AutoBackupFrequency value,
    AutoBackupFrequency? currentValue,
    Function(AutoBackupFrequency) onTap,
  ) {
    final isSelected = value == currentValue;
    return ListTile(
      title: Text(title),
      leading: Icon(
        isSelected ? Icons.check_circle : Icons.circle_outlined,
        color: isSelected ? Theme.of(context).colorScheme.primary : null,
      ),
      onTap: () => onTap(value),
    );
  }

  Future<void> _selectAutoBackupResultCount() async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(
      text: (_settings?.autoBackupResultCount ?? 10).toString(),
    );
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.autoBackupResultCount),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            labelText: l10n.numberOfResults,
            hintText: '10',
          ),
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
    
    if (confirmed == true && _settings != null) {
      final count = int.tryParse(controller.text) ?? 10;
      if (count > 0) {
        try {
          final updated = _settings!.copyWith(autoBackupResultCount: count);
          await DatabaseService.instance.saveUserSettings(updated);
          await _loadSettings();
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${l10n.errorSavingSettings}: $e')),
            );
          }
        }
      }
    }
    
    controller.dispose();
  }

  String _getFrequencyLabel(AutoBackupFrequency frequency) {
    final l10n = AppLocalizations.of(context)!;
    switch (frequency) {
      case AutoBackupFrequency.disabled:
        return l10n.disabled;
      case AutoBackupFrequency.afterResults:
        return l10n.afterResults;
      case AutoBackupFrequency.daily:
        return l10n.daily;
      case AutoBackupFrequency.weekly:
        return l10n.weekly;
    }
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

  Future<void> _onClassificationSeasonChanged((DateTime, DateTime) season) async {
    setState(() => _isLoading = true);
    
    try {
      final classifications = await DatabaseService.instance.getAllClassificationLevels(
        seasonStart: season.$1,
        seasonEnd: season.$2,
      );
      
      if (mounted) {
        setState(() {
          _selectedClassificationSeasonStart = season.$1;
          _selectedClassificationSeasonEnd = season.$2;
          _classifications = {
            for (var c in classifications) c.discipline: c
          };
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.errorLoadingSettings}: $e')),
        );
      }
    }
  }

  Future<void> _editClassification(String discipline) async {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final existing = _classifications[discipline];
    
    // If no existing level for this season, try to inherit from previous season
    double? inheritedMin;
    double? inheritedMax;
    
    if (existing == null && 
        _selectedClassificationSeasonStart != null && 
        _selectedClassificationSeasonEnd != null) {
      final previousLevel = await DatabaseService.instance.getPreviousSeasonClassification(
        discipline,
        _selectedClassificationSeasonStart!,
        _selectedClassificationSeasonEnd!,
      );
      
      if (previousLevel != null) {
        inheritedMin = previousLevel.minAverage;
        inheritedMax = previousLevel.maxAverage;
      }
    }
    
    final minController = TextEditingController(
      text: existing?.minAverage.toString() ?? inheritedMin?.toString() ?? '',
    );
    final maxController = TextEditingController(
      text: existing?.maxAverage.toString() ?? inheritedMax?.toString() ?? '',
    );

    final result = await showDialog<ClassificationLevel>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(discipline),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (inheritedMin != null && inheritedMax != null && existing == null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    'Values inherited from previous season',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                    ),
                  ),
                ),
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
                    seasonStartDate: _selectedClassificationSeasonStart,
                    seasonEndDate: _selectedClassificationSeasonEnd,
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
        await DatabaseService.instance.deleteClassificationLevel(
          discipline,
          seasonStart: _selectedClassificationSeasonStart,
          seasonEnd: _selectedClassificationSeasonEnd,
        );
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
        
        // Season start - Month dropdown (first)
        DropdownButtonFormField<int>(
          initialValue: _seasonStartMonth,
          decoration: InputDecoration(
            labelText: l10n.seasonStartLabel,
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.calendar_month),
          ),
          hint: Text(l10n.selectMonth),
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
              // Adjust day if it exceeds max days for new month
              if (_seasonStartDay != null && value != null) {
                final maxDays = _getMaxDaysInMonth(value);
                if (_seasonStartDay! > maxDays) {
                  _seasonStartDay = maxDays;
                }
              }
            });
          },
        ),
        const SizedBox(height: 16),
        
        // Season start - Day spinner (second)
        InkWell(
          onTap: () => _showDayPicker(context),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: l10n.selectDay,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.calendar_today),
              suffixIcon: const Icon(Icons.arrow_drop_down),
            ),
            child: Text(
              _seasonStartDay != null ? '$_seasonStartDay' : l10n.selectDay,
              style: _seasonStartDay != null
                  ? Theme.of(context).textTheme.bodyLarge
                  : Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).hintColor,
                    ),
            ),
          ),
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
        
        // Season selector for classification levels
        if (_availableSeasons.isNotEmpty)
          DropdownButtonFormField<(DateTime, DateTime)>(
            value: _selectedClassificationSeasonStart != null && 
                   _selectedClassificationSeasonEnd != null
                ? (_selectedClassificationSeasonStart!, _selectedClassificationSeasonEnd!)
                : null,
            decoration: InputDecoration(
              labelText: l10n.selectSeason,
              border: const OutlineInputBorder(),
            ),
            items: _availableSeasons.map((season) {
              final label = SeasonHelper.formatSeason(season.$1, season.$2);
              return DropdownMenuItem(
                value: season,
                child: Text(label),
              );
            }).toList(),
            onChanged: (season) {
              if (season != null) {
                _onClassificationSeasonChanged(season);
              }
            },
          ),
        
        if (_availableSeasons.isNotEmpty)
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
        
        // Cloud Backup section
        Text(
          l10n.cloudBackup,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        // Last backup timestamp
        if (_settings != null && _settings!.lastBackupDate != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              '${l10n.lastBackup}: ${_formatBackupDate(_settings!.lastBackupDate!)}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
        
        // Auto-Backup Settings
        SwitchListTile(
          title: Text(l10n.autoBackupEnabled),
          subtitle: Text(l10n.autoBackupEnabledDescription),
          value: _settings?.autoBackupEnabled ?? false,
          onChanged: (value) => _updateAutoBackupEnabled(value),
        ),
        
        if (_settings?.autoBackupEnabled ?? false) ...[
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.schedule),
            title: Text(l10n.autoBackupFrequency),
            subtitle: Text(_getFrequencyLabel(_settings?.autoBackupFrequency ?? AutoBackupFrequency.disabled)),
            onTap: _selectAutoBackupFrequency,
          ),
          
          if (_settings?.autoBackupFrequency == AutoBackupFrequency.afterResults) ...[
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.numbers),
              title: Text(l10n.autoBackupResultCount),
              subtitle: Text('${l10n.backupAfter} ${_settings?.autoBackupResultCount ?? 10} ${l10n.results}'),
              onTap: _selectAutoBackupResultCount,
            ),
          ],
        ],
        
        const SizedBox(height: 16),
        
        // Backup to Cloud
        ListTile(
          leading: const Icon(Icons.cloud_upload),
          title: Text(l10n.backupToCloud),
          subtitle: Text(
            Platform.isIOS ? l10n.backupToICloud : l10n.backupToGoogleDrive,
          ),
          onTap: _backupToCloud,
        ),
        const SizedBox(height: 8),
        
        // Restore from Cloud
        ListTile(
          leading: const Icon(Icons.cloud_download),
          title: Text(l10n.restoreFromCloud),
          subtitle: Text(
            Platform.isIOS ? l10n.restoreFromICloud : l10n.restoreFromGoogleDrive,
          ),
          onTap: _restoreFromCloud,
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

