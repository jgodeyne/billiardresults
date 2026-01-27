# Billiard Results Tracker - Copilot Instructions

## Project Overview
A Flutter mobile application for billiards players to track competition results and statistics across multiple disciplines. The app works completely offline with optional premium cloud sync.

## Technical Stack
- **Framework:** Flutter (iOS & Android)
- **Architecture:** Offline-first, local storage primary
- **Premium Features:** Cloud sync, statistics sharing

## Key Constraints
- Must work completely offline
- No notifications or reminders
- No help/tutorial sections
- No data export/import (except premium sharing)
- No GDPR compliance requirements

## Domain Knowledge

### Billiard Disciplines
Track each discipline separately by table size:
- **Free game**
- **1-cushion**
- **3-cushion:** Small table, Match table
- **Balkline:** 
  - Small table: 38/2, 57/2
  - Match table: 47/2, 47/1, 71/2

### Season Definition
- Start: Last Monday of August
- End: Last Sunday of August the following year
- Automatically created by the app

### Core Calculations
- **Average:** Points made ÷ Number of innings
- **Highest Run:** Track both single-match and all-time highest
- **Performance Trends:** Based on last 5 matches (arrows: up/down/stable)

### Result Entry
**Required fields:**
- Date (allows multiple per date)
- Points made (> 0)
- Number of innings (> 0)
- Highest run (≤ points made)

**Optional fields:**
- Adversary (free text, no suggestions)
- Match outcome (won/lost/draw - user determined)
- Competition (free text, no suggestions)

### Classification Levels
- Format: Min-Max average range
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

### Graphs & Visualizations
- **Line charts:** Average evolution, highest run
- **Pie chart:** Win/loss/draw ratio
- Simplified view when only 1-2 results
- No zoom/pan interactions (future feature)

### Result List View
- Summary view with expansion capability
- Direct edit/delete from list (with confirmation)
- Filter by: competition, adversary
- Default sort: date

### User Interactions
- Confirmation dialogs for ALL destructive actions
- No auto-suggestions or auto-fill in forms
- Trend indicators as arrows (up/down/stable)

## Data Management

### Local Storage
- Primary storage, no automatic cleanup
- Indefinite retention unless user deletes
- User can reset/delete all data via settings
- Error recovery options if storage fails

### Cloud Sync (Premium)
- Automatic when internet available
- Status indicator: synced/syncing/not synced
- Conflict resolution: Most recent edit wins
- Auto-retry on failure with queuing

## Premium Features
- **Price:** €5-10 one-time payment
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
- Update classification levels
- Cloud sync settings (premium)
- Data management (delete all with confirmation)

## Code Guidelines

### Validation Rules
Always enforce:
- Points made > 0
- Number of innings > 0
- Highest run ≤ points made

### State Management
- Remember: user-defined card order
- Don't remember: season filter selection (always default to current)

### Timeframe Handling
- Default view: Current season
- Allow custom timeframe selection
- Support all-seasons view

### Error Handling
- Storage failures: Show error with recovery options
- Sync failures: Auto-retry and queue changes
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
- Test season transitions (last Monday of August)
- Test conflict resolution in cloud sync
- Test with insufficient data (1-2 results)
- Test validation rules strictly

## Important Notes
- User determines match outcome (won/lost/draw) - no automatic calculation
- Each discipline/table size combination is tracked separately
- No notifications, reminders, or help sections
- Forms never auto-suggest or remember previous entries
- Always show confirmation for destructive actions
