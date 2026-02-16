# Billiard Results Tracker - Requirements Document

## 1. Overview
A mobile application for billiards players to track competition results and statistics across multiple disciplines and per season.

**Platform:** iOS and Android

**Framework:** Flutter

**Connectivity:** App must work completely offline

**Languages:** Multi-language support (Dutch, French, English)

**No Notifications/Reminders:** App does not send any notifications or reminders

## 2. User Profile & Settings

### 2.1 First-Time Setup (Onboarding)
- **Required on first launch:** Dedicated onboarding screen that must be completed before using the app
- User must provide their name
- User must provide season start date (day and month only, e.g., "September 1st")
  - This date will be used to automatically calculate season boundaries each year
  - Cannot be skipped - required to use the app
- Classification levels are optional and can be set later per discipline


### 2.2 Profile Management
- Users can change their name after initial setup
- Users can change their season start date in settings
- Users can track results for multiple user-defined disciplines simultaneously
- Users can set classification levels per discipline
  - Each unique discipline name can have its own classification level
  - Format: Two number fields (minimum and maximum average)
  - Example: Min: 1.5, Max: 2.0
  - Optional: Can be set/updated at any time in settings

### 2.3 Settings Page
Settings page includes:
- Edit name
- Edit season start date (day and month)
- Language selection (Dutch, French, English)
- Update classification levels (min-max average per discipline)
- Data management options (delete all data with confirmation)

**Note:** Cloud sync and premium features are out-of-scope for initial version

## 3. Main Page (Dashboard)

### 3.1 Display Elements
- Player's name & current season displayed at top
- **View Mode Toggle**: Segmented button to switch between:
  - **Discipline View**: One card per discipline (only shown if there are results for the current season)
  - **Competition View**: One card per competition (only shown if there are results for the current season)
- Cards appear in alphabetical order
- Selected view mode is preserved when navigating to/from detail screens

### 3.2 Empty State
- When user has no results: Display prompt to add first result

### 3.3 Card Content (Current Season)
Each card (discipline or competition) displays:
- Current average (centrally displayed, large font)
- Highest run (across all matches in the season) (below average, little smaller font)
- Total points made (top left corner, small font)
- Total innings played (top right corner, small font)
- Number of won/lost/draw matches (bottom center, small font)
  - Shows counts for won/lost/draw/unknown (unknown marked with '?' for results without outcome)
- Comparison to target average (from official classification level) - **discipline cards only**:
  - Green indicator when above maximum target
  - Red indicator when below minimum target
  - No color when within range
  - Hidden if classification level not provided

### 3.4 Card Interaction
- **Tap discipline card:** Navigate to discipline detail view (graphs and statistics)
- **Tap competition card:** Navigate to competition detail view (graphs and statistics)

### 3.5 Performance Trends
- Display trend arrows (up/down/stable) based on last 5 matches

### 3.6 Actions
- **Add Result Button (+)**: Global floating action button that opens form to record a result
  - User selects discipline within the form
- **Season Filter**: Allows switching between different seasons (if multiple seasons exist)
  - Remembers last selected season when navigating to/from detail screens
  - Remembers view mode (discipline/competition) selection

## 4. Discipline Detail View

### 4.1 Navigation
- Accessed by selecting a discipline card from the main page

### 4.2 Display Elements
Multiple graph pages accessible via pager/tabs:
- **Average evolution graph** (line chart showing average per match over time)
- **Highest run graph** (line chart)
- **Win/loss/draw ratio graph** (pie chart showing overall ratio)

### 4.3 Graph Types
- Line charts for average and highest run
- Bar chart for win/loss/draw ratio
- Simplified view when insufficient data (1-2 results)
- No zoom, pan, or other interactions (future feature)

### 4.4 Timeframe Selection
- Default: Current season only
- User can select other seasons or view all seasons

### 4.5 Graph Interaction
- Clicking any graph navigates to result list view

### 4.6 Performance Trends
- Display performance trends over the selected timeframe
- Trend based on last 5 matches (arrows: up/down/stable)

### 4.7 Navigation to Result List
- **Tap any graph:** Navigate to result list view for that discipline

## 5. Competition Detail View

### 5.1 Navigation
- Accessed by selecting a competition card from the main page

### 5.2 Display Elements
Multiple graph pages accessible via pager/tabs:
- **Average evolution graph** (line chart showing average per match over time)
- **Highest run graph** (line chart)
- **Win/loss/draw ratio graph** (pie chart showing overall ratio)

### 5.3 Graph Types
- Line charts for average and highest run
- Pie chart for win/loss/draw ratio
- Simplified view when insufficient data (1-2 results)
- No zoom, pan, or other interactions (future feature)

### 5.4 Timeframe Selection
- Default: Current season only
- User can select other seasons or view all seasons

### 5.5 Graph Interaction
- Clicking any graph navigates to result list view filtered by competition

### 5.6 Performance Trends
- Display performance trends over the selected timeframe
- Trend based on last 5 matches (arrows: up/down/stable)
- No classification comparison (not applicable to competitions)

### 5.7 Navigation to Result List
- **Tap any graph:** Navigate to result list view for that competition

## 6. Result List View

### 6.1 Display Format
- Summary view with option to expand for each result
- Shows all fields when expanded: date, points, innings, average, highest run, adversary, outcome, competition

### 6.2 Actions
- Edit result directly from list
- Delete result directly from list (with confirmation dialog)

### 6.3 Filtering & Sorting
- **Filter UI:** Filter icon/button that opens a filter sheet/modal
Filter by competition
  - Filter by adversary
- Sortable by date (default)

### 6.4 Navigation
- Accessible from discipline detail view or competition detail view by tapping any graph
- Displays results for the selected discipline/competition and timeframe

## 7. Result Entry & Management

### 7.1 Adding Results
Users can record a single result via the global + button with the following fields:

**Required fields:**
- **Discipline** (free text with auto-complete suggestions)
  - User can type any discipline name
  - Auto-complete suggests known disciplines as user types (e.g., "Free game", "1-cushion", "3-cushion - Small table", "3-cushion - Match table", "Balkline 38/2 - Small table", etc.)
  - Multiple results can be entered for the same discipline on the same date
- Date (allows multiple results per date per discipline)
- Points made (must be >= 0)
  - Warning shown for unusually high values (e.g., > 500) but still allowed
- Number of innings (must be > 0)
  - Warning shown for unusually high values (e.g., > 200) but still allowed
- Highest run (must be >= 0 and ≤ points made)
- **Competition name** (free text with auto-suggestions based on previously entered competitions)

**Optional fields:**
- Adversary name (free text, no auto-suggestions/auto-fill)
- Match outcome (won/lost/draw) - user determines the outcome
  - If not provided, result is counted as "unknown" in statistics

### 7.2 Form Behavior
- Auto-suggestions for discipline (from common disciplines) and competition (from previously entered competitions)
- No auto-suggestions for adversary names
- No pattern-based auto-completion

### 7.3 Managing Results
- Users can edit results after entry
- Users can delete results after entry
- Confirmation dialogs for all destructive actions

### 7.4 Validation Rules
- Points made must be >= 0 (zero is allowed)
- Number of innings must be > 0 (cannot be zero)
- Highest run must be >= 0 and cannot exceed points made
- No hard maximum limits on values
- Show warning (but allow entry) for unusually high values:
  - Points made > 500
  - Number of innings > 200
  - Highest run > 300

## 8. Data Definitions

### 8.1 Season
- **Start:** User-defined date (day and month only) configured during first-time setup
  - Example: If user sets "September 1st", every season starts on September 1st
- **End:** Day before the next season start date (August 31st in the example above)
- **Automatic Creation:** Seasons are automatically created by the app based on the user-defined start date
- **Year Calculation:** Season year is based on the start date (e.g., "Season 2025" starts Sept 1, 2025 and ends Aug 31, 2026)
- No manual custom seasons
- **Historical Access:** Users can view and edit results from any past season

### 8.2 Average Calculation
- Formula: Points made ÷ Number of innings (3 decimal places)

### 8.3 Billiard Disciplines
**User-Defined:** Disciplines are free-text fields that users can define however they prefer.

**Suggested Disciplines:** The app provides auto-complete suggestions based on common billiard disciplines:
- Free game - Small table
- Free game - Match table
- 1-cushion - Small table
- 1-cushion - Match table
- 3-cushion - Small table
- 3-cushion - Match table
- Balkline 38/2 - Small table
- Balkline 57/2 - Small table
- Balkline 47/2 - Match table
- Balkline 47/1 - Match table
- Balkline 71/2 - Match table

**Note:** Each unique discipline name is tracked separately (e.g., "3-cushion - Small table" and "3-cushion - Match table" are different disciplines)

### 8.4 Highest Run
- Display both highest run in a single match AND highest run across all matches

## 9. Statistics & Analytics

### 9.1 Opponent Statistics
- If adversary name is provided, track statistics against specific opponents
- Show performance metrics per opponent

### 9.2 Competition Statistics
- Competition name is required for all results
- Track competition-specific statistics
- Show performance metrics per competition

### 9.3 Performance Tracking
- Display performance trends (arrows: up/down/stable)
- Trends calculated based on last 5 matches
- Compare current performance to target average (official classification level)
- Show average per match evolution

## 10. Data Storage

### 10.1 Local Storage
- Primary data storage on the device
- All data stored locally with no automatic cleanup
- Data retained indefinitely unless manually deleted by user
- Users can completely reset/delete all their data via settings
- Use SQLite for structured data storage

### 10.2 Error Handling - Local Storage
- If local storage fails or becomes corrupted: Display error message with recovery options
- If device storage is full: Show error message suggesting to delete old data or free up device storage

### 10.3 Premium Features - OUT OF SCOPE
**Note:** Cloud storage, cloud sync, premium payment, and sharing features are out-of-scope for the initial version of the app.

The initial version includes:
- Local storage only
- No data export/import
- No sharing capabilities

## 11. Premium Features (Future Enhancement - Out of Scope)

The following features are planned for future versions but NOT included in the initial build:

### 11.1 Payment Model (Future)
- One-time payment for premium features
- Price range: €5-10
- No trial period

### 11.2 Premium Feature List (Future)
- Cloud storage and sync across devices
- Share statistics with others (generate shareable image/screenshot)
- Conflict resolution: Most recent edit wins

### 11.3 Free Version (Current Scope)
- Local storage only
- No cloud backup
- No data export (CSV, PDF)
- No data import from other sources
- No sharing capabilities

## 12. Navigation Flow

### 12.1 Screen Hierarchy
```
First Launch
└─> Onboarding (required)
    └─> Dashboard (Main Page)
        ├─> + Button → Add Result Form
        ├─> Tap Discipline Card → Discipline Detail View (Graphs)
        │   └─> Tap Graph → Result List View
        │       ├─> Tap Result → Edit Result Form
        │       └─> Delete → Confirmation Dialog
        └─> Bottom Nav
            ├─> Dashboard
            ├─> [Future: All Results]
            └─> Settings
```

### 12.2 Navigation Details
- **First Launch:** Show onboarding screen (name + season date setup)
- **Main Navigation:** Bottom navigation bar (Dashboard, Results, Settings)
- **Add Result:** Global floating action button (+) accessible from dashboard
- **View Discipline Details:** Tap any discipline card on dashboard
- **View Results List:** Tap any graph in discipline detail view
- **Edit/Delete Result:** Available from result list view
- **Back Navigation:** Standard back button/gesture on all screens

## 13. Additional Features & Constraints

### 13.1 Multi-Season View
- Option to view graphs across all seasons (not just current season)
- User-selectable timeframe for all statistics and graphs
- All past seasons are accessible and editable

### 13.2 No Help/Tutorial Section
- No about/help section with instructions

### 13.3 Data Privacy
- No specific data privacy or compliance requirements
- No GDPR compliance needed
- No privacy policy required

## 14. Internationalization (i18n)

### 14.1 Supported Languages
- Dutch (Nederlands)
- French (Français)
- English

### 14.2 Language Selection
- Default language: Device system language (if supported), otherwise English
- User can change language in Settings
- Language preference saved locally
- All UI text, labels, and messages must be translatable

### 14.3 Localization Scope
- All static UI text and labels
- All error messages and dialogs
- All hints and placeholder text
- Graph labels and axis titles
- Confirmation dialogs

### 14.4 Non-Localized Content
- User-entered data (discipline names, adversary names, competition names)
- Dates follow device locale formatting
- Numbers follow device locale formatting (decimal separators)

## 15. Design & UI
### 15.1 Color Scheme
- I want a light pastel color scheme with a clean and modern design
- The colors related to carom billiards (blue, red, orange,white) can be used as accent colors for specific elements (e.g., indicators, buttons)
- Overall, the design should be visually appealing and user-friendly, with a focus on simplicity and ease of use.