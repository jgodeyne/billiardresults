#!/bin/bash

# Script to verify that objective_c.framework dSYM is in the archive
# Run this after archiving to check if the dSYM is properly included

if [ -z "$1" ]; then
    echo "Usage: $0 <path-to-xcarchive>"
    echo ""
    echo "To find your archives:"
    echo "  ~/Library/Developer/Xcode/Archives/"
    echo ""
    echo "Example:"
    echo "  $0 ~/Library/Developer/Xcode/Archives/2026-02-18/Runner\ 2026-02-18\,\ 16.00.xcarchive"
    exit 1
fi

ARCHIVE_PATH="$1"
DSYMS_PATH="${ARCHIVE_PATH}/dSYMs"
OBJECTIVE_C_DSYM="${DSYMS_PATH}/objective_c.framework.dSYM"

echo "=== Verifying objective_c.framework dSYM in Archive ==="
echo "Archive: ${ARCHIVE_PATH}"
echo ""

if [ ! -d "$ARCHIVE_PATH" ]; then
    echo "✗ Archive not found at: ${ARCHIVE_PATH}"
    exit 1
fi

echo "✓ Archive found"
echo ""

echo "Checking dSYMs folder..."
if [ ! -d "$DSYMS_PATH" ]; then
    echo "✗ dSYMs folder not found in archive"
    exit 1
fi

echo "✓ dSYMs folder exists"
echo ""

echo "All dSYM bundles in archive:"
ls -1 "$DSYMS_PATH" | grep ".dSYM"
echo ""

echo "Checking objective_c.framework.dSYM..."
if [ ! -d "$OBJECTIVE_C_DSYM" ]; then
    echo "✗ objective_c.framework.dSYM NOT FOUND in archive!"
    echo ""
    echo "This dSYM needs to be manually copied. Run:"
    echo "  cp -r \"${DSYMS_PATH}/../objective_c.framework.dSYM\" \"${DSYMS_PATH}/\""
    exit 1
fi

echo "✓ objective_c.framework.dSYM found in archive"
echo ""

DWARF_FILE="${OBJECTIVE_C_DSYM}/Contents/Resources/DWARF/objective_c"
if [ ! -f "$DWARF_FILE" ]; then
    echo "✗ DWARF file missing inside dSYM bundle"
    exit 1
fi

echo "✓ DWARF file exists"
echo ""

echo "UUID of objective_c.framework.dSYM:"
dwarfdump --uuid "$DWARF_FILE"
echo ""

echo "=== ✓ All checks passed! Archive is ready for upload. ==="
