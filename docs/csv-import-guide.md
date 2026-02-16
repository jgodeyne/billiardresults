# CSV Import Guide

## Overview
You can import your existing billiard results from Numbers, Excel, or any spreadsheet application by exporting to CSV format and using the import feature in the Settings screen.

## How to Import

1. **Prepare Your Data**:
   - Open your Numbers file with results
   - If you have multiple tabs (seasons), you can export each tab separately or combine them into one CSV
   
2. **Export to CSV**:
   - In Numbers: File → Export To → CSV
   - In Excel: File → Save As → CSV (Comma delimited)
   
3. **Import in App**:
   - Open the app and go to Settings
   - Scroll to "Data Management" section
   - Tap "Import from CSV"
   - Select your CSV file
   - Review the import preview
   - Tap "Import Results" to complete

## CSV Format Requirements

### Required Columns
Your CSV file must include these columns (column names are case-insensitive):

- **Date**: The date of the match
  - Supported formats: `YYYY-MM-DD`, `DD/MM/YYYY`, `MM/DD/YYYY`
  - Examples: `2025-01-15`, `15/01/2025`, `1/15/2025`

- **Discipline**: The billiard discipline name
  - Examples: `Free game - Small table`, `3-cushion - Match table`
  - Any text is accepted; this will create/use the discipline in your app

- **Points**: Total points made
  - Must be a whole number >= 0
  - Example: `45`

- **Innings**: Number of innings played
  - Must be a whole number > 0
  - Example: `30`

- **Highest Run**: Highest run achieved in the match
  - Must be a whole number >= 0
  - Cannot exceed the total points
  - Example: `8`

- **Competition**: Name of the competition/tournament
  - Example: `Winter League 2025`
  - Any text is accepted

### Optional Columns
These columns are optional but recommended:

- **Adversary**: Name of your opponent
  - Example: `John Doe`
  - Leave empty if not applicable

- **Outcome**: Result of the match
  - Valid values: `won`, `lost`, `draw`
  - Also accepts: `w`, `l`, `d` (case-insensitive)
  - Leave empty if unknown

## Column Name Variations

The import supports multiple language variations for column names:

| English | Dutch | French |
|---------|-------|--------|
| Date | Datum | Date |
| Discipline | Disciplin | Discipline |
| Points | Punten | Points |
| Innings | Beurten | Manches |
| Highest Run | Hoogste Serie | Série la Plus Élevée |
| Adversary | Tegenstander | Adversaire |
| Competition | Competitie | Compétition |
| Outcome | Uitslag | Résultat |

Alternative column names are also supported:
- "Points Made" instead of "Points"
- "Serie" instead of "Highest Run"
- "Opponent" instead of "Adversary"
- "Tournament" instead of "Competition"
- "Result" or "Resultaat" instead of "Outcome"

## Example CSV

```csv
Date,Discipline,Points,Innings,Highest Run,Adversary,Competition,Outcome
2025-01-15,Free game - Small table,45,30,8,John Doe,Winter League,won
2025-01-20,3-cushion - Match table,25,25,5,Jane Smith,,lost
2025-01-22,Free game - Small table,38,28,6,,,draw
2025-02-01,1-cushion - Small table,52,35,10,John Doe,Winter League,won
```

## Tips for Success

1. **Export by Season**: If you have tabs per season in Numbers, export each tab separately or combine them
2. **Check Dates**: Ensure date formats are consistent throughout your CSV
3. **Validate Numbers**: Make sure innings > 0 and highest run <= points
4. **Review Preview**: Always check the import preview before confirming
5. **Error Messages**: If there are errors, the app will show which rows failed and why
6. **Partial Import**: Valid rows will be imported even if some rows have errors

## Common Issues

### Date Format Errors
**Problem**: "Invalid date format"
**Solution**: Use one of the supported formats: `YYYY-MM-DD`, `DD/MM/YYYY`, or `MM/DD/YYYY`

### Validation Errors
**Problem**: "Highest run cannot exceed points"
**Solution**: Check your data and ensure highest run values are less than or equal to points made

### Missing Columns
**Problem**: "Required column 'X' not found"
**Solution**: Ensure your CSV has all required column headers (Date, Discipline, Points, Innings, Highest Run)

### Empty Rows
**Problem**: Import skips some rows
**Solution**: Empty rows are automatically skipped - this is normal behavior

## After Importing

- Imported results will appear on the dashboard
- Disciplines will be added automatically if they don't exist
- You can edit or delete imported results just like manually entered ones
- The app will show how many results were successfully imported

## Backup Recommendation

Before importing large datasets:
1. Make sure your current app data is backed up (if you have any)
2. Test with a small sample CSV first
3. Once confirmed working, import your full dataset

## Need Help?

If you encounter issues:
1. Check the error messages - they indicate which rows and what problems
2. Verify your CSV format matches the requirements
3. Try the "CSV Format Help" button in the app for a quick reference
4. Test with the example CSV provided in the app
