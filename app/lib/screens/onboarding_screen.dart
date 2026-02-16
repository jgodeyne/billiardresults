import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/user_settings.dart';
import '../services/database_service.dart';

/// First-time onboarding screen for setting up user profile
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  int? _selectedDay;
  int? _selectedMonth;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
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
    if (_selectedMonth == null) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.selectMonthFirst)),
      );
      return;
    }

    final maxDays = _getMaxDaysInMonth(_selectedMonth!);
    final initialDay = _selectedDay ?? 1;
    
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
                  _selectedDay = tempDay;
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

  Future<void> _completeOnboarding() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDay == null || _selectedMonth == null) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.seasonStartError)),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Get device locale for default language
      final locale = Localizations.localeOf(context);
      String language = locale.languageCode;
      if (!['en', 'nl', 'fr'].contains(language)) {
        language = 'en'; // Fallback to English
      }

      final settings = UserSettings(
        name: _nameController.text.trim(),
        seasonStartDay: _selectedDay!,
        seasonStartMonth: _selectedMonth!,
        language: language,
      );

      await DatabaseService.instance.saveUserSettings(settings);

      if (!mounted) return;

      // Navigate to main app (replace entire navigation stack)
      Navigator.of(context).pushReplacementNamed('/home');
    } catch (e) {
      if (!mounted) return;
      
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${l10n.errorSavingSettings}: $e')),
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

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Welcome icon
                  Image.asset(
                    'assets/CaromStats.png',
                    width: 120,
                    height: 120,
                  ),
                  const SizedBox(height: 24),
                  
                  // Welcome text
                  Text(
                    l10n.onboardingWelcome,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.onboardingSubtitle,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  
                  // Name input
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: l10n.nameLabel,
                      hintText: l10n.nameHint,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.person),
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.nameError;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  
                  // Season start date - Month dropdown (first)
                  DropdownButtonFormField<int>(
                    value: _selectedMonth,
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
                        _selectedMonth = value;
                        // Adjust day if it exceeds max days for new month
                        if (_selectedDay != null && value != null) {
                          final maxDays = _getMaxDaysInMonth(value);
                          if (_selectedDay! > maxDays) {
                            _selectedDay = maxDays;
                          }
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Season start date - Day spinner (second)
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
                        _selectedDay != null ? '$_selectedDay' : l10n.selectDay,
                        style: _selectedDay != null
                            ? theme.textTheme.bodyLarge
                            : theme.textTheme.bodyLarge?.copyWith(
                                color: theme.hintColor,
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  
                  // Get Started button
                  FilledButton(
                    onPressed: _isLoading ? null : _completeOnboarding,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              l10n.getStarted,
                              style: const TextStyle(fontSize: 16),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
