# Billiard Results Tracker

A Flutter mobile application for billiards players to track competition results and statistics across multiple disciplines. The app works completely offline with local SQLite storage.

## Features

### Core Functionality
- **Result Entry**: Track points made, number of innings, highest run, adversary, outcome (won/lost/draw), and competition
- **CSV Import**: Import existing results from Numbers or Excel via CSV export
- **Statistics Dashboard**: View aggregated statistics per discipline or competition with visual indicators
- **Flexible Grouping**: Toggle between viewing stats by discipline or by competition
- **Detailed Graphs**: Three chart types showing average evolution, highest run progression, and win/loss/draw ratio
- **Advanced Filtering**: Filter results by competition and/or adversary in result list view
- **Result Management**: Edit and delete results with confirmation dialogs
- **Multi-Discipline Support**: Track any billiard discipline with autocomplete suggestions for common types
- **Cloud Backup**: Backup and restore your data using iCloud Drive (iOS) or Google Drive (Android)

### User Experience
- **Offline-First**: All data stored locally, no internet required
- **Multi-Language**: Full support for Dutch, French, and English
- **Season Management**: User-defined season start date with automatic season calculations
- **All Seasons View**: View statistics across all seasons or select specific seasons
- **Classification Levels**: Set target average ranges per discipline with visual indicators (green/red)
- **Performance Trends**: Automatic trend calculation from last 5 matches
- **Competition Analytics**: Dedicated detail screens for competition-specific statistics

### Technical Features
- Clean Material 3 design with light blue theme
- Responsive layout supporting various screen sizes
- Comprehensive input validation with warnings for unusual values
- SQLite database with proper data models
- 32 unit tests covering core logic

## Screenshots

*(Add screenshots here)*

## Getting Started

### Prerequisites
- Flutter SDK 3.10.8 or higher
- Dart SDK 3.10.8 or higher
- iOS Simulator (for iOS development) or Android Emulator (for Android development)

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd billiardresults/app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Running Tests
```bash
flutter test
```

### Building for Production

#### Android
```bash
flutter build apk --release
```

#### iOS
```bash
flutter build ios --release
```

## Project Structure

```
lib/
├── models/              # Data models (Result, UserSettings, DisciplineStats, CompetitionStats, etc.)
├── screens/             # UI screens (Dashboard, AddResult, DisciplineDetail, CompetitionDetail, etc.)
├── widgets/             # Reusable widgets (StatsCard, etc.)
├── services/            # Business logic (DatabaseService, CloudBackupService, etc.)
├── utils/               # Helper functions (SeasonHelper, Constants)
├── l10n/                # Localization files (ARB format)
└── main.dart            # App entry point
```

## Architecture

- **State Management**: Provider for global app state
- **Database**: SQLite (sqflite) for local data persistence
- **Cloud Storage**: iCloud Drive (iOS) / Google Drive (Android) for backups
- **Localization**: Flutter's built-in i18n with ARB files
- **Charts**: fl_chart for data visualization
- **Navigation**: Standard Flutter Navigator

## Database Schema

### Tables
1. **user_settings**: User preferences (name, season start date, language)
2. **results**: Match results with all tracked fields
3. **classification_levels**: Target average ranges per discipline
4. **discipline_order**: Card ordering preferences (future feature)

## Supported Disciplines

The app suggests 11 common billiard disciplines (localized):
- Free game (Small/Match table)
- 1-cushion (Small/Match table)
- 3-cushion (Small/Match table)
- Balkline 38/2, 57/2, 47/2, 47/1, 71/2

Users can also enter custom discipline names.

## Data Management

### CSV Import
You can import existing results from Numbers, Excel, or other spreadsheet applications:

1. **Export your data** to CSV format from Numbers or Excel
2. Go to **Settings** → **Data Management** → **Import from CSV**
3. Select your CSV file and review the import preview
4. Confirm to import all valid results

**Required CSV columns**: Date, Discipline, Points, Innings, Highest Run  
**Optional columns**: Adversary, Competition, Outcome

Supported date formats: `YYYY-MM-DD`, `DD/MM/YYYY`, `MM/DD/YYYY`

For detailed instructions and a sample CSV file, see:
- [CSV Import Guide](../docs/csv-import-guide.md)
- [Sample CSV](../docs/sample-import.csv)

The import feature:
- Validates all data before importing
- Shows clear error messages for invalid rows
- Imports valid rows even if some rows have errors
- Supports multiple language variations for column names

### Cloud Backup & Restore
Protect your data with cloud backup:

- **iOS**: Automatic backup to iCloud Drive
- **Android**: Backup to Google Drive (requires sign-in)
- **Restore**: Easily restore your data from the cloud on a new device

Access via **Settings** → **Cloud Backup**

## Validation Rules

- Points made: ≥ 0 (warning if > 500)
- Number of innings: > 0 (warning if > 200)
- Highest run: ≥ 0 and ≤ points made (warning if > 300)
- Warnings are non-blocking - users can still save

## Dashboard Features

### View Modes
- **By Discipline**: See statistics grouped by billiard discipline
- **By Competition**: See statistics grouped by competition name
- Toggle between views using the segmented button at the top of the dashboard

### Detail Screens
Tap any card to view detailed statistics including:
- Average evolution chart (line graph)
- Highest run progression (line graph)
- Win/Loss/Draw ratio (pie chart)
- Performance trend indicators
- Season-specific or all-time statistics

### Filtering Results
In the result list screen:
- Filter by specific competition
- Filter by specific adversary
- Combined filters supported
- Direct access to edit or delete results

## Known Limitations

### Current Version
- No data export (CSV import and cloud backup supported)
- No drag-and-drop card reordering (deferred to future version)
- No dark mode support
- No graph zoom/pan interactions
- No notifications or reminders

### Future Enhancements
See [implementation-plan.md](../docs/implementation-plan.md) for planned features including:
- Data export/sharing capabilities
- Advanced analytics and insights
- Dark mode
- Drag-and-drop card reordering
- Graph zoom/pan interactions

## Contributing

This is a personal project. If you'd like to contribute:
1. Fork the repository
2. Create a feature branch
3. Make your changes with tests
4. Submit a pull request

## License

*(Add license information)*

## Acknowledgments

- Flutter and Dart teams for the excellent framework
- fl_chart library for charts/graphs
- sqflite for local database support

## Contact

*(Add contact information)*

---

**Version**: 1.0.0  
**Last Updated**: February 16, 2026
