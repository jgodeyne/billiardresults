#!/bin/bash

# Script to generate dSYM for objective_c.framework if missing
# This addresses the issue where Flutter's objective_c.framework doesn't include dSYM

set -e

echo "=== Generating dSYM for objective_c.framework ==="

# Define paths
FRAMEWORK_NAME="objective_c.framework"
APP_PATH="${BUILT_PRODUCTS_DIR}/${WRAPPER_NAME}"
FRAMEWORK_PATH="${APP_PATH}/Frameworks/${FRAMEWORK_NAME}"
FRAMEWORK_EXECUTABLE="${FRAMEWORK_PATH}/objective_c"

# Determine dSYM destination based on build context
if [ -n "${DWARF_DSYM_FOLDER_PATH}" ] && [ "${DWARF_DSYM_FOLDER_PATH}" != "" ]; then
    DSYM_FOLDER="${DWARF_DSYM_FOLDER_PATH}"
else
    # Fallback for regular builds
    DSYM_FOLDER="${BUILT_PRODUCTS_DIR}"
fi

DSYM_PATH="${DSYM_FOLDER}/${FRAMEWORK_NAME}.dSYM"

echo "Configuration: ${CONFIGURATION}"
echo "App path: ${APP_PATH}"
echo "Framework path: ${FRAMEWORK_PATH}"
echo "dSYM folder: ${DSYM_FOLDER}"
echo "dSYM path: ${DSYM_PATH}"

# Check if framework exists
if [ ! -d "$FRAMEWORK_PATH" ]; then
    echo "Warning: ${FRAMEWORK_NAME} not found at ${FRAMEWORK_PATH}"
    echo "This framework might not be required for this build configuration."
    exit 0
fi

# Check if executable exists
if [ ! -f "$FRAMEWORK_EXECUTABLE" ]; then
    echo "Warning: ${FRAMEWORK_NAME} executable not found"
    exit 0
fi

echo "✓ Found ${FRAMEWORK_NAME} executable"

# Check if dSYM already exists with correct UUID
if [ -d "$DSYM_PATH" ]; then
    DWARF_FILE="${DSYM_PATH}/Contents/Resources/DWARF/objective_c"
    if [ -f "$DWARF_FILE" ]; then
        EXISTING_UUID=$(dwarfdump --uuid "$DWARF_FILE" 2>/dev/null | awk '{print $2}' | head -1)
        FRAMEWORK_UUID=$(dwarfdump --uuid "$FRAMEWORK_EXECUTABLE" 2>/dev/null | awk '{print $2}' | head -1)
        
        if [ "$EXISTING_UUID" = "$FRAMEWORK_UUID" ] && [ -n "$EXISTING_UUID" ]; then
            echo "✓ dSYM already exists with matching UUID: ${EXISTING_UUID}"
            exit 0
        else
            echo "Removing outdated dSYM (UUID mismatch)..."
            rm -rf "$DSYM_PATH"
        fi
    else
        echo "Removing incomplete dSYM (missing DWARF file)..."
        rm -rf "$DSYM_PATH"
    fi
fi

# Generate dSYM using dsymutil
echo "Generating dSYM with dsymutil..."
if dsymutil "$FRAMEWORK_EXECUTABLE" -o "$DSYM_PATH" 2>&1; then
    echo "✓ Successfully generated dSYM for ${FRAMEWORK_NAME}"
    
    # Verify the dSYM was created
    if [ -d "$DSYM_PATH" ]; then
        DWARF_PATH="${DSYM_PATH}/Contents/Resources/DWARF/objective_c"
        if [ -f "$DWARF_PATH" ]; then
            echo "✓ dSYM DWARF file exists at: ${DWARF_PATH}"
            
            # Show UUID of generated dSYM
            echo "UUID of generated dSYM:"
            dwarfdump --uuid "$DWARF_PATH" 2>&1 || echo "Could not read UUID"
            
            # Show UUID of framework executable
            echo "UUID of framework executable:"
            dwarfdump --uuid "$FRAMEWORK_EXECUTABLE" 2>&1 || echo "Could not read UUID"
        else
            echo "⚠ DWARF file not found in dSYM bundle"
        fi
    else
        echo "⚠ dSYM bundle was not created"
    fi
else
    echo "⚠ dsymutil failed, attempting alternative method..."
    
    # Try alternative method: copy framework as dSYM and extract symbols
    echo "Creating dSYM structure manually..."
    mkdir -p "${DSYM_PATH}/Contents/Resources/DWARF"
    
    # Copy the framework executable to the DWARF location
    cp "$FRAMEWORK_EXECUTABLE" "${DSYM_PATH}/Contents/Resources/DWARF/objective_c"
    
    # Create Info.plist for dSYM
    cat > "${DSYM_PATH}/Contents/Info.plist" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleSignature</key>
    <string>????</string>
    <key>CFBundleIdentifier</key>
    <string>com.apple.xcode.dsym.objective_c</string>
    <key>CFBundleVersion</key>
    <string>1.0</string>
</dict>
</plist>
EOF
    
    echo "✓ Alternative dSYM generation completed"
fi

echo "=== dSYM generation script completed successfully ==="
exit 0
