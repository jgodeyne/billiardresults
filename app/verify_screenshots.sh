#!/bin/bash

# Verify screenshot dimensions for App Store Connect

echo "=== Checking Screenshots on Desktop ==="
echo ""

IPHONE_FOUND=0
IPAD_FOUND=0

for file in ~/Desktop/Simulator*.png; do
    if [ -f "$file" ]; then
        DIMENSIONS=$(sips -g pixelWidth -g pixelHeight "$file" | grep -E "pixelWidth|pixelHeight" | awk '{print $2}' | tr '\n' 'x' | sed 's/x$//')
        
        echo "$(basename "$file"): ${DIMENSIONS}"
        
        # Check if dimensions match required sizes
        if [[ "$DIMENSIONS" == "1284x2778" || "$DIMENSIONS" == "2778x1284" ]]; then
            echo "  ✓ Valid iPhone 6.5\" screenshot"
            IPHONE_FOUND=$((IPHONE_FOUND + 1))
        elif [[ "$DIMENSIONS" == "2048x2732" || "$DIMENSIONS" == "2732x2048" ]]; then
            echo "  ✓ Valid iPad 13\" screenshot"
            IPAD_FOUND=$((IPAD_FOUND + 1))
        else
            echo "  ✗ WRONG SIZE - Should be 1284x2778 (iPhone) or 2048x2732 (iPad)"
        fi
        echo ""
    fi
done

echo "=== Summary ==="
echo "Valid iPhone screenshots: $IPHONE_FOUND (need at least 3)"
echo "Valid iPad screenshots: $IPAD_FOUND (need at least 3)"
