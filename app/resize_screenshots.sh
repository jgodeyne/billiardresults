#!/bin/bash

# Resize iPhone 15 Pro Max screenshots to App Store Connect requirements
# iPhone 15 Pro Max gives 1290x2796, but Apple wants 1284x2778

DESKTOP="$HOME/Desktop"
OUTPUT_DIR="$DESKTOP/AppStore_Screenshots"

mkdir -p "$OUTPUT_DIR"

echo "=== Resizing Screenshots for App Store Connect ==="
echo ""

PROCESSED=0
SKIPPED=0

for file in "$DESKTOP"/*.png; do
    if [ ! -f "$file" ]; then
        continue
    fi
    
    # Get dimensions
    WIDTH=$(sips -g pixelWidth "$file" | grep pixelWidth | awk '{print $2}')
    HEIGHT=$(sips -g pixelHeight "$file" | grep pixelHeight | awk '{print $2}')
    
    FILENAME=$(basename "$file")
    
    # Check if it's a 1290x2796 screenshot (iPhone 15 Pro Max)
    if [ "$WIDTH" = "1290" ] && [ "$HEIGHT" = "2796" ]; then
        echo "Processing: $FILENAME (1290x2796 → 1284x2778)"
        
        # Resize to 1284x2778 (required by Apple)
        sips -z 2778 1284 "$file" --out "$OUTPUT_DIR/$FILENAME" >/dev/null 2>&1
        
        if [ $? -eq 0 ]; then
            echo "  ✓ Resized to 1284x2778"
            PROCESSED=$((PROCESSED + 1))
        else
            echo "  ✗ Failed to resize"
        fi
    elif [ "$WIDTH" = "2796" ] && [ "$HEIGHT" = "1290" ]; then
        echo "Processing: $FILENAME (2796x1290 → 2778x1284) [landscape]"
        
        # Resize landscape version
        sips -z 1284 2778 "$file" --out "$OUTPUT_DIR/$FILENAME" >/dev/null 2>&1
        
        if [ $? -eq 0 ]; then
            echo "  ✓ Resized to 2778x1284"
            PROCESSED=$((PROCESSED + 1))
        else
            echo "  ✗ Failed to resize"
        fi
    elif [ "$WIDTH" = "1284" ] && [ "$HEIGHT" = "2778" ]; then
        echo "Copying: $FILENAME (already correct size 1284x2778)"
        cp "$file" "$OUTPUT_DIR/$FILENAME"
        PROCESSED=$((PROCESSED + 1))
    elif [ "$WIDTH" = "2064" ] && [ "$HEIGHT" = "2752" ]; then
        echo "Processing: $FILENAME (2064x2752 → 2048x2732) [iPad]"
        
        # Resize to 2048x2732 (required by Apple for iPad 13")
        sips -z 2732 2048 "$file" --out "$OUTPUT_DIR/$FILENAME" >/dev/null 2>&1
        
        if [ $? -eq 0 ]; then
            echo "  ✓ Resized to 2048x2732"
            PROCESSED=$((PROCESSED + 1))
        else
            echo "  ✗ Failed to resize"
        fi
    elif [ "$WIDTH" = "2752" ] && [ "$HEIGHT" = "2064" ]; then
        echo "Processing: $FILENAME (2752x2064 → 2732x2048) [iPad landscape]"
        
        # Resize landscape version
        sips -z 2048 2732 "$file" --out "$OUTPUT_DIR/$FILENAME" >/dev/null 2>&1
        
        if [ $? -eq 0 ]; then
            echo "  ✓ Resized to 2732x2048"
            PROCESSED=$((PROCESSED + 1))
        else
            echo "  ✗ Failed to resize"
        fi
    elif [ "$WIDTH" = "2048" ] && [ "$HEIGHT" = "2732" ]; then
        echo "Copying: $FILENAME (iPad 13\" - correct size)"
        cp "$file" "$OUTPUT_DIR/$FILENAME"
        PROCESSED=$((PROCESSED + 1))
    elif [ "$WIDTH" = "2732" ] && [ "$HEIGHT" = "2048" ]; then
        echo "Copying: $FILENAME (iPad 13\" landscape - correct size)"
        cp "$file" "$OUTPUT_DIR/$FILENAME"
        PROCESSED=$((PROCESSED + 1))
    else
        echo "Skipping: $FILENAME (${WIDTH}x${HEIGHT} - unknown size)"
        SKIPPED=$((SKIPPED + 1))
    fi
    echo ""
done

echo "=== Summary ==="
echo "Processed: $PROCESSED screenshots"
echo "Skipped: $SKIPPED files"
echo ""
echo "✓ App Store ready screenshots saved to:"
echo "  $OUTPUT_DIR"
echo ""
echo "Upload these screenshots to App Store Connect!"
