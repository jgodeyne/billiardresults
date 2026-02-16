import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'utils/app_theme.dart';
import 'screens/dashboard_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/add_result_screen.dart';
import 'widgets/background_wrapper.dart';
import 'l10n/app_localizations.dart';
import 'services/database_service.dart';
import 'models/user_settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: Consumer<AppState>(
        builder: (context, appState, _) {
          return MaterialApp(
            title: 'CaromStats',
            theme: AppTheme.lightTheme,
            locale: appState.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'), // English
              Locale('nl'), // Dutch
              Locale('fr'), // French
            ],
            home: const InitialScreen(),
            routes: {
              '/home': (context) => const MyHomePage(),
              '/onboarding': (context) => const OnboardingScreen(),
            },
          );
        },
      ),
    );
  }
}

/// Initial screen that determines whether to show onboarding or main app
class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: DatabaseService.instance.hasUserSettings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        }

        final hasSettings = snapshot.data ?? false;

        // Load settings into app state if they exist
        if (hasSettings) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            final settings = await DatabaseService.instance.getUserSettings();
            if (settings != null && context.mounted) {
              context.read<AppState>().updateSettings(settings);
            }
          });
          return const MyHomePage();
        } else {
          return const OnboardingScreen();
        }
      },
    );
  }
}

/// Global app state for managing user settings and locale
class AppState extends ChangeNotifier {
  UserSettings? _settings;
  Locale? _locale;

  Locale? get locale => _locale;
  UserSettings? get settings => _settings;

  void updateSettings(UserSettings settings) {
    _settings = settings;
    _locale = Locale(settings.language);
    notifyListeners();
  }

  void updateLanguage(String languageCode) {
    if (_settings != null) {
      _settings = _settings!.copyWith(language: languageCode);
      _locale = Locale(languageCode);
      notifyListeners();
    }
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  int _dashboardRefreshKey = 0;

  List<Widget> get _screens => <Widget>[
    DashboardScreen(key: ValueKey(_dashboardRefreshKey)),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(l10n.appTitle),
      ),
      body: BackgroundWrapper(
        child: _screens[_selectedIndex],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to add result screen
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (context) => const AddResultScreen(),
            ),
          );
          
          // Refresh dashboard if result was saved
          if (result == true && mounted) {
            setState(() {
              _dashboardRefreshKey++;
            });
          }
        },
        tooltip: l10n.addResult,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard),
            label: l10n.dashboard,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: l10n.settings,
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
