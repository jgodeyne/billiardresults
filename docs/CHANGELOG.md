# Changelog

All notable changes to the Billiard Results Tracker will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Competition view mode on dashboard (February 16, 2026)
  - Users can now toggle between viewing cards grouped by discipline or competition
  - Segmented button in dashboard allows switching between views
  - Competition detail screen with same graph capabilities as discipline detail screen
  - Season and view mode selection preserved when navigating to/from detail screens
  - CompetitionStats model for aggregating competition-specific statistics
  - Generic StatsCard widget replacing DisciplineCard for both disciplines and competitions
- Cloud backup functionality (February 15, 2026)
  - Google Sign-In integration for authentication
  - Cloud Firestore backup and restore
  - Automatic backup on result create/update/delete
  - Manual backup and restore options in settings
  - Conflict resolution (most recent wins)
- CSV import functionality (February 15, 2026)
  - Import historical results from CSV files
  - Automatic date format detection
  - Validation and error handling
  - Success/error reporting with detailed feedback

### Changed
- Dashboard navigation now preserves season selection when returning from detail screens (February 16, 2026)
- Result filtering improved in result list view (February 15, 2026)
- Dashboard cards use alphabetical ordering instead of custom drag-and-drop (February 16, 2026)

### Fixed
- Nullable competition field handling in competition grouping (February 16, 2026)
- Season selection reset bug when navigating between screens (February 16, 2026)

## [1.0.0] - 2026-02-15

### Added
- Initial release with core features
- Multi-discipline result tracking
- Season-based organization (user-defined season start date)
- Dashboard with discipline cards showing key statistics
- Discipline detail screens with graphs:
  - Average evolution line chart
  - Highest run line chart
  - Win/loss/draw ratio pie chart
- Result entry form with validation
  - Required fields: discipline, date, points, innings, highest run, competition
  - Optional fields: adversary, match outcome
  - Autocomplete for disciplines and competitions
  - Warnings for unusually high values
- Result list view with filtering (competition, adversary)
- Settings page:
  - Edit name
  - Edit season start date
  - Language selection
  - Classification level management per discipline
  - Data management (delete all)
- Onboarding screen for first-time setup
- Multi-language support:
  - Dutch (Nederlands)
  - French (Français)
  - English
- Performance trend indicators (improving/declining/stable based on last 5 matches)
- Classification level comparison for discipline cards:
  - Green indicator when above maximum target
  - Red indicator when below minimum target
  - No color when within range
- Local SQLite database storage
- Light pastel color scheme with billiard accent colors
- Material 3 design system
- 32 comprehensive unit tests

### Technical Details
- **Framework:** Flutter 3.10.8 or higher
- **Database:** SQLite (sqflite package)
- **State Management:** Provider
- **Charts:** fl_chart package
- **Platforms:** iOS and Android
- **Offline-first:** Complete offline functionality

### Known Limitations
- No data export/import (except CSV import added Feb 15)
- No graph zoom/pan interactions
- No dark mode
- No drag-and-drop card ordering on dashboard (cards in alphabetical order)
- Classification levels only apply to disciplines, not competitions
