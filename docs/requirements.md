# Billiard Results Tracker - Requirements Document

## 1. Overview
A mobile application for billiards players to track competition results and statistics across multiple disciplines.

**Platform:** iOS and Android

**Framework:** Flutter

**Connectivity:** App must work completely offline

**No Notifications/Reminders:** App does not send any notifications or reminders

## 2. User Profile & Settings

### 2.1 First-Time Setup
- User must provide their name
- User can optionally provide their official classification level per billiard discipline (range: minimum-maximum average)

### 2.2 Profile Management
- Users can change their name after initial setup
- Users can track results for multiple disciplines simultaneously
- Users can update their classification level over time as they improve

### 2.3 Settings Page
Settings page includes:
- Edit name
- Update classification levels (min-max average per discipline)
- Cloud sync settings (if premium)
- Data management options (delete all data with confirmation)

## 3. Main Page (Dashboard)

### 3.1 Display Elements
- Player's name
- One card per discipline (only shown if there are results for the current season)
- Cards appear in user-defined order (drag-and-drop directly on cards)

### 3.2 Empty State
- When user has no results: Display prompt to add first result

### 3.3 Card Content (Current Season)
Each discipline card displays:
- Current average
- Highest run (across all matches in the season)
- Number of won/lost/draw matches
- Background: graph showing average per match over time (line chart)
- Comparison to target average (from official classification level):
  - Green indicator when above maximum target
  - Red indicator when below minimum target
  - No color when within range
  - Hidden if classification level not provided

### 3.4 Performance Trends
- Display trend arrows (up/down/stable) based on last 5 matches

### 3.5 Actions
- **Add Result Button (+)**: Opens a form to record a single result
- **Season Filter**: Allows switching between different seasons (if multiple seasons exist)
  - Always defaults to current season on app launch (does not remember last selection)

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
- User can select custom timeframe or view all seasons

### 4.5 Graph Interaction
- Clicking any graph navigates to result list view

### 4.6 Performance Trends
- Display performance trends over the selected timeframe
- Trend based on last 5 matches (arrows: up/down/stable)

## 5. Result List View

### 5.1 Display Format
- Summary view with option to expand for each result
- Shows all fields when expanded: date, points, innings, average, highest run, adversary, outcome, competition

### 5.2 Actions
- Edit result directly from list
- Delete result directly from list (with confirmation dialog)

### 5.3 Filtering & Sorting
- Filter by competition
- Filter by adversary
- Sortable by date (default)

### 5.4 Total Sum Display
- Display the sum of all total points from results that match the current filter criteria
- Position: Right side above the list, on the same level as the filter criteria
- Label: "Total"
- Updates dynamically when filter criteria change

## 6. Result Entry & Management

### 6.1 Adding Results
Users can record a single result via the + button with the following fields:

**Required fields:**
- Date (multiple results can be entered for the same date)
- Points made (must be > 0)
- Number of innings (must be > 0)
- Highest run (must be ≤ points made)

**Optional fields:**
- Adversary name (free text, no auto-suggestions)
- Match outcome (won/lost/draw) - user determines the outcome
- Competition name (free text, no auto-suggestions)

### 6.2 Form Behavior
- No auto-fill or suggestions from previous entries
- No pattern-based auto-completion

### 6.3 Managing Results
- Users can edit results after entry
- Users can delete results after entry
- Confirmation dialogs for all destructive actions

### 6.4 Validation Rules
- Points made cannot be negative
- Number of innings cannot be zero
- Highest run cannot exceed points made

## 7. Data Definitions

### 7.1 Season
- Start: Last Monday of August
- End: Last Sunday of August the following year
- Seasons are automatically created by the app
- No manual custom seasons

### 7.2 Average Calculation
- Formula: Points made ÷ Number of innings

### 7.3 Billiard Disciplines
Each discipline with different table sizes is tracked separately:

- **Free game**
- **1-cushion**
- **3-cushion**
  - Small table
  - Match table
- **Balkline**
  - Small table: 38/2, 57/2
  - Match table: 47/2, 47/1, 71/2

### 7.4 Highest Run
- Display both highest run in a single match AND highest run across all matches

## 8. Statistics & Analytics

### 8.1 Opponent Statistics
- If adversary name is provided, track statistics against specific opponents
- Show performance metrics per opponent

### 8.2 Competition Statistics
- If competition name is provided, track competition-specific statistics
- Show performance metrics per competition

### 8.3 Performance Tracking
- Display performance trends (arrows: up/down/stable)
- Trends calculated based on last 5 matches
- Compare current performance to target average (official classification level)
- Show average per match evolution

## 9. Data Storage

### 9.1 Local Storage
- Primary data storage on the device
- All data stored locally with no automatic cleanup
- Data retained indefinitely unless manually deleted by user
- Users can completely reset/delete all their data via settings

### 9.2 Error Handling - Local Storage
- If local storage fails or becomes corrupted: Display error message with recovery options

### 9.3 Cloud Storage (Premium Feature)
- Optional cloud backup/sync feature
- One-time payment: €5-10
- No trial period
- Enables syncing across multiple devices

### 9.4 Cloud Sync Behavior
- Automatic synchronization when internet available
- Sync status indicator (synced, syncing, not synced)
- Conflict resolution: Most recent edit wins
- If sync fails: Automatically retry and queue changes for next sync

## 10. Premium Features

### 10.1 Payment Model
- One-time payment for premium features
- Price range: €5-10

### 10.2 Premium Feature List
- Cloud storage and sync across devices
- Share statistics with others (generate shareable image/screenshot of specific graphs)

### 10.3 Sharing Feature
- Generate shareable image/screenshot (initial implementation)
- Can share specific graphs
- Only available with premium

### 10.4 Free Features
- No data export (CSV, PDF)
- No data import from other sources

## 11. Additional Features & Constraints

### 11.1 Multi-Season View
- Option to view graphs across all seasons (not just current season)
- User-selectable timeframe for all statistics and graphs

### 11.2 No Help/Tutorial Section
- No about/help section with instructions

### 11.3 Data Privacy
- No specific data privacy or compliance requirements
- No GDPR compliance needed
- No privacy policy required