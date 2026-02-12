# Billiard Results Tracker - Copilot Instructions

## Project Overview
A Flutter mobile application for billiards players to track competition results and statistics across multiple disciplines. The app works completely offline.

**Note:** Premium features (cloud sync, sharing) are out-of-scope for initial version.

## Technical Stack
- **Framework:** Flutter (iOS & Android)
- **Architecture:** Offline-first, local storage only
- **Database:** SQLite for structured data storage
- **Languages:** Multi-language support (Dutch, French, English)

## Key Constraints
- Must work completely offline
- No notifications or reminders
- No help/tutorial sections
- No data export/import
- No GDPR compliance requirements
- Premium features (cloud sync, sharing) are out-of-scope

## Domain Knowledge

### Billiard Disciplines
Disciplines are **user-defined free text** with auto-complete suggestions for c ommon disciplines:

**Suggested Disciplines:**
- **Free game - Small table**
- **Free game - Match table**
- **1-cushion - Small table**
- **1-cushion - Match table**
- **3-cushion - Small table**
- **3-cushion - Match table**
- **Balkline 38/2 - Small table**
- **Balkline 57/2 - Small table**
- **Balkline 47/2 - Match table**
- **Balkline 47/1 - Match table**
- **Balkline 71/2 - Match table**

**Note:** Each unique discipline name is tracked separately.

### Season Definition
- Start: **User-defined date** (day and month) set during first-time setup
- End: Day before the next season start date
- Automatically created by the app
- Example: If user sets "September 1st", every season runs Sept 1 - Aug 31

### Core Calculations
- **Average:** Points made ÷ Number of innings
- **Highest Run:** Track both single-match and all-time highest
- **Performance Trends:** Based on last 5 matches (arrows: up/down/stable)

### Result Entry
**Required fields:**
- Discipline (free text with auto-complete suggestions)
- Date (allows multiple per discipline per date)
- Points made (>= 0, warning for values > 500)
- Number of innings (> 0, warning for values > 200)
- Highest run (>= 0, <= points made, warning for values > 300)

**Optional fields:**
- Adversary (free text, no auto-suggestions)
- Match outcome (won/lost/draw - user determined, shows as "unknown" if not provided)
- Competition (free text, no auto-suggestions)

### Classification Levels
- Format: Two number fields (Min-Max average range)
- Set per unique discipline name in settings
- Example: Min: 1.5, Max: 2.0
- Used for target comparison with visual indicators:
  - Green: Above maximum
  - Red: Below minimum
  - No color: Within range
  - Hidden if not provided

## UI/UX Guidelines

### Main Dashboard
- Show discipline cards ONLY if current season has results
- Empty state: Prompt to add first result
- Card ordering: Drag-and-drop directly on cards
- Always default to current season on launch
- Card background: Line chart of average per match
- **Tap card:** Navigate to discipline detail view
- **+ button:** Global floating action button to add result (user selects discipline in form)

### Graphs & Visualizations
- **Line charts:** Average evolution, highest run
- **Pie chart:** Win/loss/draw ratio
- Simplified view when only 1-2 results
- No zoom/pan interactions (future feature)

### Result List View
- Summary view with expansion capability
- Direct edit/delete from list (with confirmation)
- Filter by: competition, adversary (via filter icon/button that opens filter sheet)
- Default sort: date
- **Navigation:** Tap any graph in discipline detail view

### User Interactions
- Confirmation dialogs for ALL destructive actions
- Auto-complete for discipline names as user types
- No auto-suggestions for adversary or competition names
- Trend indicators as arrows (up/down/stable)
- Warnings for unusually high values (but still allow entry)

## Data Management

### Local Storage
- Primary storage, no automatic cleanup
- Indefinite retention unless user deletes
- User can reset/delete all data via settings
- Error recovery options if storage fails
- SQLite database for structured data
- All past seasons accessible and editable

### Storage Full Error
- Show error message suggesting to delete old data or free up device storage

## First-Time Setup
- **Required onboarding screen** on first launch
- Cannot skip - must complete before using app
- Collect: User name, season start date (day and month)
- Classification levels optional, can be set later

## Premium Features (Out-of-Scope)
- Cloud sync, sharing, and premium features are NOT included in initial version
- Focus on local-only functionality
- **Features:** Cloud sync, share statistics (image/screenshot of graphs)
- **No trial period**

## Statistics & Analytics

### Opponent Tracking
- Automatic if adversary name provided
- Track performance metrics per opponent

### Competition Tracking
- Automatic if competition name provided
- Track performance metrics per competition

### Display Requirements
- Show both single-match and all-time highest run
- Comparison to target average (from classification level)
- Performance trends (last 5 matches)
- Win/loss/draw ratio

## Settings Page
Include:
- Edit name
- Edit season start date (day and month)
- Language selection (Dutch, French, English)
- Update classification levels (per discipline)
- Data management (delete all with confirmation)

## Code Guidelines

### Validation Rules
Always enforce:
- Points made >= 0
- Number of innings > 0
- Highest run >= 0 and <= points made
- Warn for high values (points > 500, innings > 200, highest run > 300) but allow entry

### State Management
- Remember: user-defined card order
- Don't remember: season filter selection (always default to current)

### Timeframe Handling
- Default view: Current season
- Allow custom timeframe selection
- Support all-seasons view

### Error Handling
- Storage failures: Show error with recovery options
- Storage full: Suggest deleting old data or free device space
- Always provide user feedback for errors

## Development Priorities
1. Offline-first architecture
2. Clean, simple UI (no help needed)
3. Data integrity and validation
4. Smooth drag-and-drop experience
5. Clear visual indicators (trends, targets)

## Testing Considerations
- Test with multiple results per date
- Test with missing optional fields (adversary, competition, classification)
- Test season transitions (user-defined season start date)
- Test with insufficient data (1-2 results)
- Test validation rules strictly

## Important Notes
- User determines match outcome (won/lost/draw) - no automatic calculation
- Each unique discipline name is tracked separately
- No notifications, reminders, or help sections
- Forms never auto-suggest or remember previous entries except discipline (which has auto-complete)
- Always show confirmation for destructive actions

## Internationalization
- **Supported languages:** Dutch, French, English
- **Default language:** Device system language (fallback to English)
- **All UI text must be translatable** - use Flutter's localization system
- User-entered data (disciplines, names) is NOT translated
- Use device locale for date and number formatting
