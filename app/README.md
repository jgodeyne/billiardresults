# Billiard Results Tracker

A Flutter mobile application for billiards players to track competition results and statistics across multiple disciplines. The app works completely offline with local SQLite storage.

## Features

### Core Functionality
- **Result Entry**: Track points made, number of innings, highest run, adversary, outcome (won/lost/draw), and competition
- **CSV Import**: Import existing results from Numbers or Excel via CSV export
- **Statistics Dashboard**: View aggregated statistics per discipline with visual indicators
- **Detailed Graphs**: Three chart types showing average evolution, highest run progression, and win/loss/draw ratio
- **Result Management**: Filter, edit, and delete results with confirmation dialogs
- **Multi-Discipline Support**: Track any billiard discipline with autocomplete suggestions for common types

### User Experience
- **Offline-First**: All data stored locally, no internet required
- **Multi-Language**: Full support for Dutch, French, and English
- **Season Management**: User-defined season start date with automatic season calculations
- **Classification Levels**: Set target average ranges per discipline with visual indicators (green/red)
- **Performance Trends**: Automatic trend calculation from last 5 matches

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
├── models/              # Data models (Result, UserSettings, etc.)
├── screens/             # UI screens (Dashboard, AddResult, etc.)
├── widgets/             # Reusable widgets (DisciplineCard, etc.)
├── services/            # Business logic (DatabaseService, etc.)
├── utils/               # Helper functions (SeasonHelper, Constants)
├── l10n/                # Localization files (ARB format)
└── main.dart            # App entry point
```

## Architecture

- **State Management**: Provider for global app state
- **Database**: SQLite (sqflite) for local data persistence
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

## Importing Data

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

## Validation Rules

- Points made: ≥ 0 (warning if > 500)
- Number of innings: > 0 (warning if > 200)
- Highest run: ≥ 0 and ≤ points made (warning if > 300)
- Warnings are non-blocking - users can still save

## Known Limitations

### Current Version
- No cloud sync or data export (CSV import supported)
- No drag-and-drop card reordering (deferred to future version)
- No dark mode support
- No graph zoom/pan interactions
- No notifications or reminders

### Future Enhancements
See [implementation-plan.md](../docs/implementation-plan.md) for planned features including:
- Premium cloud sync
- Data export/sharing
- Advanced analytics
- Dark mode

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
**Last Updated**: February 15, 2026
