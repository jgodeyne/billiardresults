# Billiard Results Tracker - Implementation Plan

**Project Status:** In Progress (Milestone 2 Complete)  
**Last Updated:** February 14, 2026

## Progress Overview

```
Overall Progress: 2/8 milestones (25%)

[✅] Milestone 1: Project Setup & Foundation
[✅] Milestone 2: Database & Data Models
[ ] Milestone 3: Onboarding & User Settings
[ ] Milestone 4: Core Result Entry
[ ] Milestone 5: Dashboard/Main Page
[ ] Milestone 6: Discipline Detail View
[ ] Milestone 7: Result List View
[ ] Milestone 8: Polish & Final Features
```

---

## Milestone 1: Project Setup & Foundation

**Status:** ✅ Complete  
**Duration:** 1-2 days  
**Dependencies:** None
**Completed:** February 14, 2026

### Objectives
- Set up Flutter project structure
- Configure dependencies
- Implement internationalization (i18n) framework
- Set up navigation structure
- Configure theme and design system

### Tasks
- [x] Clean up default Flutter template (already started)
- [x] Add required dependencies to `pubspec.yaml`:
  - [x] `sqflite` for SQLite database
  - [x] `path_provider` for local storage paths
  - [x] `intl` for internationalization and date formatting
  - [x] `provider` for state management
  - [x] `fl_chart` for graphs/charts
  - [x] `reorderable_grid_view` for drag-and-drop
- [x] Set up project folder structure:
  - [x] `/lib/models` - Data models
  - [x] `/lib/screens` - UI screens
  - [x] `/lib/widgets` - Reusable widgets
  - [x] `/lib/services` - Database and business logic
  - [x] `/lib/utils` - Helper functions
  - [x] `/lib/l10n` - Localization files
- [x] Configure internationalization:
  - [x] Enable Flutter localization in `pubspec.yaml`
  - [x] Create ARB files for Dutch, French, English
  - [x] Set up locale detection and switching
- [x] Implement theme:
  - [x] Light pastel color scheme
  - [x] Billiard accent colors (blue, red, orange)
  - [x] Typography
  - [x] Component styles
- [x] Set up bottom navigation bar structure

### Acceptance Criteria
- ✓ App runs without errors on iOS and Android
- ✓ All dependencies installed and configured
- ✓ Theme applied with correct colors
- ✓ Language can be switched between Dutch, French, English
- ✓ Bottom navigation shows 3 tabs: Dashboard, Results, Settings
- ✓ Navigation between tabs works

### Testing
- Run app on iOS simulator
- Run app on Android emulator
- Switch between languages - verify all system text changes
- Navigate between tabs

---

## Milestone 2: Database & Data Models

**Status:** ✅ Complete  
**Duration:** 2-3 days  
**Dependencies:** Milestone 1
**Completed:** February 14, 2026

### Objectives
- Design and implement SQLite database schema
- Create data models
- Implement database service layer
- Add CRUD operations for all entities

### Tasks
- [x] Design database schema:
  - [x] `user_settings` table (name, season_start_day, season_start_month, language)
  - [x] `results` table (id, discipline, date, points, innings, highest_run, adversary, outcome, competition)
  - [x] `classification_levels` table (id, discipline, min_average, max_average)
  - [x] `discipline_order` table (discipline, order_index)
- [x] Create data models:
  - [x] `UserSettings` model
  - [x] `Result` model
  - [x] `ClassificationLevel` model
  - [x] `Season` model (computed from settings)
- [x] Implement database service:
  - [x] Database initialization
  - [x] Database version management/migrations
  - [x] Error handling for storage failures
- [x] Implement CRUD operations:
  - [x] User settings (create, read, update)
  - [x] Results (create, read, update, delete)
  - [x] Classification levels (create, read, update, delete)
  - [x] Discipline ordering (read, update)
- [x] Add helper functions:
  - [x] Season calculation based on user-defined start date
  - [x] Filter results by season
  - [x] Filter results by discipline
  - [x] Query for statistics calculation
  - [x] Statistics helper service with validation

### Acceptance Criteria
- ✓ Database created on first app launch
- ✓ All tables created with correct schema
- ✓ Can insert, read, update, delete records
- ✓ Database handles errors gracefully (storage full, corruption)
- ✓ Season boundaries calculated correctly based on user date
- ✓ Data persists between app restarts

### Testing
- Create test data
- Verify data persists after app restart
- Test with different season start dates
- Test storage error scenarios
- Query results by season and discipline

---

## Milestone 3: Onboarding & User Settings

**Status:** ⚪ Not Started  
**Duration:** 2-3 days  
**Dependencies:** Milestone 2

### Objectives
- Implement first-time onboarding screen
- Create settings page
- Implement user preferences management

### Tasks
- [ ] Create onboarding screen:
  - [ ] Welcome message
  - [ ] Name input field with validation
  - [ ] Season start date picker (day and month only)
  - [ ] Cannot skip - required fields
  - [ ] Save settings to database
  - [ ] Navigate to dashboard after completion
- [ ] Implement first-launch detection:
  - [ ] Check if user settings exist
  - [ ] Show onboarding if no settings
  - [ ] Show dashboard if settings exist
- [ ] Create settings page:
  - [ ] Edit name field
  - [ ] Edit season start date (day and month)
  - [ ] Language selection dropdown (Dutch, French, English)
  - [ ] Classification levels section (per discipline)
  - [ ] Delete all data button with confirmation dialog
- [ ] Implement classification level management:
  - [ ] List all unique disciplines from results
  - [ ] Add/edit classification for each discipline
  - [ ] Two number fields: minimum and maximum average
  - [ ] Delete classification level
- [ ] Add confirmation dialogs:
  - [ ] Delete all data confirmation (with warning)
  - [ ] Delete classification level confirmation

### Acceptance Criteria
- ✓ Onboarding shown on first launch only
- ✓ User cannot skip onboarding (name + season date required)
- ✓ Settings saved to database
- ✓ Settings page accessible from bottom navigation
- ✓ Can edit all user settings
- ✓ Language change takes effect immediately
- ✓ Classification levels can be set per discipline
- ✓ Delete all data works with confirmation
- ✓ All destructive actions require confirmation

### Testing
- Fresh install - verify onboarding shows
- Complete onboarding - verify saved
- Restart app - verify onboarding doesn't show again
- Edit all settings - verify changes persist
- Change language - verify UI updates
- Delete all data - verify database cleared
- Set classification levels for multiple disciplines

---

## Milestone 4: Core Result Entry

**Status:** ⚪ Not Started  
**Duration:** 3-4 days  
**Dependencies:** Milestone 2, Milestone 3

### Objectives
- Implement add result form
- Add discipline auto-complete
- Implement validation rules
- Save results to database

### Tasks
- [ ] Create add result form screen:
  - [ ] Discipline field with auto-complete
  - [ ] Date picker (default: today)
  - [ ] Points made number input
  - [ ] Number of innings number input
  - [ ] Highest run number input
  - [ ] Adversary text input (optional)
  - [ ] Match outcome dropdown: Won/Lost/Draw (optional)
  - [ ] Competition text input (optional)
  - [ ] Save button
  - [ ] Cancel button
- [ ] Implement discipline auto-complete:
  - [ ] Text field with suggestions
  - [ ] Suggest as user types
  - [ ] Suggestions include all 11 common disciplines
  - [ ] Allow free text entry
  - [ ] Track previously used disciplines
- [ ] Implement validation:
  - [ ] Points made >= 0 (required)
  - [ ] Number of innings > 0 (required)
  - [ ] Highest run >= 0 and <= points made (required)
  - [ ] Show warnings for high values (points > 500, innings > 200, highest run > 300)
  - [ ] Still allow entry after warning
  - [ ] Highlight validation errors
- [ ] Implement save logic:
  - [ ] Validate all fields
  - [ ] Calculate average (points / innings)
  - [ ] Save to database
  - [ ] Handle storage errors
  - [ ] Navigate back to dashboard
  - [ ] Show success feedback
- [ ] Add floating action button (+) on dashboard:
  - [ ] Opens add result form
  - [ ] Positioned over bottom nav

### Acceptance Criteria
- ✓ + button visible on dashboard
- ✓ Tapping + opens add result form
- ✓ Discipline auto-complete shows suggestions as typing
- ✓ Can select from suggestions or type custom discipline
- ✓ All validation rules enforced
- ✓ Warnings shown for high values but entry still allowed
- ✓ Cannot save with validation errors
- ✓ Result saved to database successfully
- ✓ Returns to dashboard after save
- ✓ New result visible immediately after saving

### Testing
- Add result with all fields
- Add result with only required fields
- Test discipline auto-complete with various inputs
- Enter invalid values - verify validation messages
- Enter high values - verify warnings shown but can save
- Save multiple results same day, same discipline
- Verify storage error handling

---

## Milestone 5: Dashboard/Main Page

**Status:** ⚪ Not Started  
**Duration:** 4-5 days  
**Dependencies:** Milestone 4

### Objectives
- Display discipline cards for current season
- Calculate and display statistics
- Implement season filtering
- Add empty state
- Enable card interactions

### Tasks
- [ ] Implement dashboard screen:
  - [ ] Display user name and current season at top
  - [ ] Season filter dropdown
  - [ ] Grid/list of discipline cards
  - [ ] Show only disciplines with results for selected season
  - [ ] Empty state when no results
- [ ] Create discipline card widget:
  - [ ] Current average (large, centered)
  - [ ] Highest run (below average, smaller)
  - [ ] Total points (top left corner, small)
  - [ ] Total innings (top right corner, small)
  - [ ] W/L/D/? counts (bottom center, small)
  - [ ] Background: line chart of average per match
  - [ ] Classification level indicator (green/red/none)
- [ ] Implement statistics calculations:
  - [ ] Current average for season
  - [ ] Highest run in season
  - [ ] Total points in season
  - [ ] Total innings in season
  - [ ] Win/loss/draw/unknown counts
  - [ ] Average per match for chart
  - [ ] Performance trend (last 5 matches)
- [ ] Add season filtering:
  - [ ] Dropdown showing all available seasons
  - [ ] Always defaults to current season on launch
  - [ ] Update cards when season changes
  - [ ] Show empty state if no results in selected season
- [ ] Implement classification level comparison:
  - [ ] Fetch classification for each discipline
  - [ ] Compare current average to min/max
  - [ ] Show green indicator if above max
  - [ ] Show red indicator if below min
  - [ ] No indicator if within range or not set
- [ ] Add card tap navigation:
  - [ ] Navigate to discipline detail view
  - [ ] Pass discipline and season context
- [ ] Implement empty state:
  - [ ] Message prompting to add first result
  - [ ] Show when no results exist
  - [ ] + button still visible

### Acceptance Criteria
- ✓ Dashboard shows all disciplines with results for current season
- ✓ Each card displays correct statistics
- ✓ Average calculated correctly (points / innings)
- ✓ W/L/D counts correct, unknown shown for missing outcomes
- ✓ Background chart shows average progression
- ✓ Classification indicators (green/red) show correctly
- ✓ Season filter works and shows all seasons
- ✓ Always defaults to current season on launch
- ✓ Empty state shows when no results
- ✓ Tapping card navigates to detail view
- ✓ Performance updates when adding new results

### Testing
- Add results for multiple disciplines
- Verify statistics calculations
- Switch between seasons
- Verify classification indicators
- Tap cards to navigate
- Test with no results (empty state)
- Test with results but no classification levels
- Verify card background charts

---

## Milestone 6: Discipline Detail View

**Status:** ⚪ Not Started  
**Duration:** 4-5 days  
**Dependencies:** Milestone 5

### Objectives
- Display detailed graphs for a discipline
- Implement multiple graph types
- Add timeframe selection
- Enable navigation to result list

### Tasks
- [ ] Create discipline detail screen:
  - [ ] App bar with discipline name
  - [ ] Timeframe selector (current season, all seasons, custom)
  - [ ] Tab view or pager for multiple graphs
  - [ ] Performance trend indicators
- [ ] Implement average evolution graph (line chart):
  - [ ] X-axis: Match date or match number
  - [ ] Y-axis: Average
  - [ ] Plot average for each match
  - [ ] Show trend line if enough data
  - [ ] Simplify view if only 1-2 results
- [ ] Implement highest run graph (line chart):
  - [ ] X-axis: Match date or match number
  - [ ] Y-axis: Highest run
  - [ ] Plot highest run for each match
  - [ ] Highlight all-time highest run
  - [ ] Simplify view if only 1-2 results
- [ ] Implement win/loss/draw ratio (pie chart):
  - [ ] Sections for Won/Lost/Draw/Unknown
  - [ ] Show percentages
  - [ ] Use different colors for each
  - [ ] Show count and percentage labels
- [ ] Add performance trends display:
  - [ ] Calculate trend from last 5 matches
  - [ ] Show up/down/stable arrow
  - [ ] Display comparison to classification level
- [ ] Implement timeframe selection:
  - [ ] Current season (default)
  - [ ] All seasons
  - [ ] Custom date range (future enhancement)
  - [ ] Update all graphs when timeframe changes
- [ ] Add graph tap navigation:
  - [ ] Tap any graph to open result list
  - [ ] Pass discipline and timeframe context

### Acceptance Criteria
- ✓ Screen accessible by tapping discipline card
- ✓ All three graph types displayed
- ✓ Graphs show correct data for selected timeframe
- ✓ Average evolution chart plots correctly
- ✓ Highest run chart shows all-time high
- ✓ Pie chart shows W/L/D/Unknown ratio
- ✓ Performance trends calculated from last 5 matches
- ✓ Timeframe selector works correctly
- ✓ Defaults to current season
- ✓ Simplified view when only 1-2 results
- ✓ Tapping any graph navigates to result list
- ✓ Classification level comparison displayed

### Testing
- Navigate from dashboard card
- Verify all graphs display
- Switch timeframes - verify data updates
- Test with 1-2 results (simplified view)
- Test with many results (full charts)
- Verify performance trend calculations
- Tap graphs to navigate to result list

---

## Milestone 7: Result List View

**Status:** ⚪ Not Started  
**Duration:** 3-4 days  
**Dependencies:** Milestone 6

### Objectives
- Display list of results
- Implement expand/collapse
- Add filter functionality
- Enable edit and delete actions

### Tasks
- [ ] Create result list screen:
  - [ ] App bar with discipline name and timeframe
  - [ ] Filter button/icon
  - [ ] List of results (summary view)
  - [ ] Expandable items
  - [ ] Sort by date (default, most recent first)
- [ ] Create result list item widget:
  - [ ] Summary view: Date, Average, Outcome
  - [ ] Expanded view: All fields
  - [ ] Expand/collapse on tap
  - [ ] Edit button
  - [ ] Delete button
- [ ] Implement filtering:
  - [ ] Filter icon/button opens filter sheet
  - [ ] Filter by competition (dropdown of all competitions)
  - [ ] Filter by adversary (dropdown of all adversaries)
  - [ ] Apply filters button
  - [ ] Clear filters button
  - [ ] Update list when filters applied
- [ ] Implement edit result:
  - [ ] Open edit form (reuse add result form)
  - [ ] Pre-populate all fields
  - [ ] Save updates to database
  - [ ] Show success feedback
  - [ ] Return to list view
- [ ] Implement delete result:
  - [ ] Show confirmation dialog
  - [ ] Delete from database
  - [ ] Remove from list
  - [ ] Show success feedback
  - [ ] Update dashboard statistics
- [ ] Add empty state:
  - [ ] Show when no results match filters
  - [ ] Suggest clearing filters

### Acceptance Criteria
- ✓ List accessible by tapping any graph in detail view
- ✓ Results displayed in date order (newest first)
- ✓ Summary shows date, average, outcome
- ✓ Expanded view shows all fields
- ✓ Filter sheet opens with competition and adversary options
- ✓ Filters work correctly
- ✓ Edit opens form with pre-filled data
- ✓ Saving edits updates database and refreshes list
- ✓ Delete shows confirmation dialog
- ✓ Delete removes result and updates statistics
- ✓ Empty state shown when no results match filters

### Testing
- Navigate from detail view
- Expand/collapse result items
- Filter by competition
- Filter by adversary
- Edit a result - verify changes saved
- Delete a result - verify confirmation and removal
- Verify dashboard updates after edit/delete
- Test with no results matching filters

---

## Milestone 8: Polish & Final Features

**Status:** ⚪ Not Started  
**Duration:** 3-4 days  
**Dependencies:** All previous milestones

### Objectives
- Implement drag-and-drop card ordering
- Add all performance indicators
- Implement all warning dialogs
- Final testing and bug fixes
- Polish UI/UX

### Tasks
- [ ] Implement drag-and-drop card ordering:
  - [ ] Enable long-press to drag discipline cards
  - [ ] Visual feedback during drag
  - [ ] Save order to database
  - [ ] Restore order on app restart
  - [ ] Works across all seasons
- [ ] Add performance trend arrows:
  - [ ] Calculate trend from last 5 matches
  - [ ] Show up arrow (improving)
  - [ ] Show down arrow (declining)
  - [ ] Show stable indicator (no change)
  - [ ] Display on dashboard cards
  - [ ] Display in detail view
- [ ] Implement all warning validations:
  - [ ] Points > 500: Show warning dialog
  - [ ] Innings > 200: Show warning dialog
  - [ ] Highest run > 300: Show warning dialog
  - [ ] Allow user to proceed or edit
- [ ] Add error handling:
  - [ ] Storage full error with suggestions
  - [ ] Database corruption recovery
  - [ ] Network errors (future cloud sync)
  - [ ] User-friendly error messages
- [ ] Polish UI/UX:
  - [ ] Smooth animations and transitions
  - [ ] Loading indicators
  - [ ] Empty states for all screens
  - [ ] Consistent spacing and typography
  - [ ] Accessibility improvements
  - [ ] Dark mode support (optional)
- [ ] Final testing:
  - [ ] Test all user flows
  - [ ] Test with various data scenarios
  - [ ] Test season transitions
  - [ ] Test multi-language switching
  - [ ] Test on multiple device sizes
  - [ ] Performance testing
  - [ ] Memory leak testing
- [ ] Documentation:
  - [ ] Code comments
  - [ ] README with setup instructions
  - [ ] Known issues/limitations

### Acceptance Criteria
- ✓ Cards can be reordered by drag-and-drop
- ✓ Card order persists between sessions
- ✓ Performance trends show correctly
- ✓ All warnings display for high values
- ✓ User can proceed after warnings
- ✓ Error handling works for all scenarios
- ✓ UI is polished and consistent
- ✓ App performs well with large datasets
- ✓ No memory leaks
- ✓ Works on various device sizes
- ✓ All languages display correctly
- ✓ All user flows tested and working

### Testing
- Full end-to-end testing of all features
- Test with 100+ results
- Test season transitions
- Test all error scenarios
- Test on iOS and Android
- Test on different screen sizes
- Performance profiling
- User acceptance testing

---

## Definition of Done

Each milestone is considered complete when:
- ✅ All tasks checked off
- ✅ All acceptance criteria met
- ✅ All tests passing
- ✅ Code reviewed (if team project)
- ✅ No critical bugs
- ✅ Documentation updated
- ✅ Works on both iOS and Android

---

## Risk Management

### High Risk Items
1. **Complex Statistics Calculations** - Mitigation: Unit tests for all calculations
2. **Graph Performance with Large Datasets** - Mitigation: Pagination, data limiting
3. **Season Boundary Calculations** - Mitigation: Comprehensive test cases
4. **Multi-language Implementation** - Mitigation: Early setup, test with all languages

### Dependencies
- Flutter SDK stability
- Third-party package compatibility
- Device storage availability

---

## Post-Launch Enhancements (Future)

1. **Premium Cloud Sync**
   - User authentication
   - Firebase/backend integration
   - Conflict resolution
   - Payment integration

2. **Data Export/Sharing**
   - Export to CSV
   - Generate shareable images
   - PDF reports

3. **Advanced Analytics**
   - More graph types
   - Comparison between seasons
   - Opponent head-to-head stats
   - Competition performance analysis

4. **UI Enhancements**
   - Graph zoom/pan
   - Dark mode
   - Custom themes
   - Widget customization

---

## Progress Tracking

### Update Log
- **February 14, 2026** - Milestone 1 completed
  - All dependencies installed (sqflite, provider, fl_chart, intl, etc.)
  - Project folder structure created
  - Internationalization configured for Dutch, French, English
  - Theme implemented with pastel colors and billiard accents
  - Bottom navigation bar implemented with 3 tabs
  - App compiles and runs without errors
- **February 14, 2026** - Milestone 2 completed
  - Database schema designed and implemented (4 tables)
  - All data models created (UserSettings, Result, ClassificationLevel, Season)
  - DatabaseService implemented with full CRUD operations
  - StatisticsHelper created with calculation and validation functions
  - 32 comprehensive tests written and passing (17 model + 15 statistics tests)
  - Season calculation logic fully tested

### Current Sprint
- **Sprint:** Milestone 2 Complete (25% of project)
- **Focus:** Moving to Milestone 3 - Onboarding & User Settings
- **Blockers:** None
- **ETA:** Ready to start Milestone 3
