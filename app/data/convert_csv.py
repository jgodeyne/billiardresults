#!/usr/bin/env python3
"""
Script to convert Dutch CSV files to the format required by the CaromStats app.
"""

import csv
import os
import re
from datetime import datetime

# Dutch month mapping
DUTCH_MONTHS = {
    'jan': 1, 'feb': 2, 'mrt': 3, 'apr': 4, 'mei': 5, 'jun': 6,
    'jul': 7, 'aug': 8, 'sep': 9, 'okt': 10, 'nov': 11, 'dec': 12
}

def parse_dutch_date(date_str):
    """
    Parse Dutch date format like 'do 16 sep 2021' to YYYY-MM-DD
    Format: [day_name] day month year
    """
    if not date_str or date_str.strip() == '':
        return None
    
    # Match pattern: optional day name, day number, month name, year
    # Example: "do 16 sep 2021" or "16 sep 2021"
    match = re.match(r'(?:\w+\s+)?(\d{1,2})\s+(\w+)\s+(\d{4})', date_str.strip())
    if not match:
        print(f"Warning: Could not parse date '{date_str}'")
        return None
    
    day = int(match.group(1))
    month_str = match.group(2).lower()
    year = int(match.group(3))
    
    month = DUTCH_MONTHS.get(month_str)
    if not month:
        print(f"Warning: Unknown month '{month_str}' in date '{date_str}'")
        return None
    
    try:
        date = datetime(year, month, day)
        return date.strftime('%Y-%m-%d')
    except ValueError as e:
        print(f"Warning: Invalid date '{date_str}': {e}")
        return None

def convert_outcome(outcome_str):
    """Convert W/L to won/lost"""
    if not outcome_str or outcome_str.strip() == '':
        return ''
    
    outcome = outcome_str.strip().upper()
    if outcome == 'W':
        return 'won'
    elif outcome == 'L':
        return 'lost'
    elif outcome == 'D':
        return 'draw'
    else:
        return ''

def convert_csv_file(input_file, output_file):
    """Convert a single CSV file from Dutch format to app format"""
    
    # Read input file
    with open(input_file, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f, delimiter=';')
        rows = list(reader)
    
    # Prepare output data
    output_rows = []
    skipped = 0
    
    for row in rows:
        # Skip rows with missing required data
        if not row.get('Datum') or not row.get('Punten ') or not row.get('Beurten '):
            skipped += 1
            continue
        
        # Convert date
        date = parse_dutch_date(row.get('Datum', ''))
        if not date:
            skipped += 1
            continue
        
        # Clean and convert values
        points = row.get('Punten ', '').strip()
        innings = row.get('Beurten ', '').strip()
        highest_run = row.get('HR', '').strip()
        
        if not points or not innings or not highest_run:
            skipped += 1
            continue
        
        output_row = {
            'Date': date,
            'Discipline': row.get('Discipline', '').strip(),
            'Points': points,
            'Innings': innings,
            'Highest Run': highest_run,
            'Adversary': '',  # Empty - not in original data
            'Competition': row.get('Competitie', '').strip(),
            'Outcome': convert_outcome(row.get('Uitslag', ''))
        }
        
        output_rows.append(output_row)
    
    # Write output file
    if output_rows:
        with open(output_file, 'w', encoding='utf-8', newline='') as f:
            fieldnames = ['Date', 'Discipline', 'Points', 'Innings', 'Highest Run', 'Adversary', 'Competition', 'Outcome']
            writer = csv.DictWriter(f, fieldnames=fieldnames)
            writer.writeheader()
            writer.writerows(output_rows)
        
        print(f"✓ Converted {input_file} -> {output_file}")
        print(f"  Rows: {len(output_rows)} (skipped {skipped} incomplete rows)")
    else:
        print(f"✗ No valid data in {input_file}")

def main():
    """Convert all CSV files in the current directory"""
    
    script_dir = os.path.dirname(os.path.abspath(__file__))
    
    # Find all CSV files matching the pattern
    csv_files = [
        '2021-2022-Tabel 1.csv',
        '2022-2023-Tabel 1.csv',
        '2023-2024-Tabel 1.csv',
        '2024-2025-Tabel 1.csv',
        '2025-2026-Tabel 1.csv'
    ]
    
    print("Converting CSV files to CaromStats format...\n")
    
    for csv_file in csv_files:
        input_path = os.path.join(script_dir, csv_file)
        if os.path.exists(input_path):
            # Create output filename
            output_name = csv_file.replace('Tabel 1', 'converted')
            output_path = os.path.join(script_dir, output_name)
            
            convert_csv_file(input_path, output_path)
        else:
            print(f"✗ File not found: {csv_file}")
    
    print("\n✓ Conversion complete!")

if __name__ == '__main__':
    main()
