#!/bin/bash

# Script to create Android keystore for Play Store release

cd /Users/jean/DevProjects/billiardresults/app/android

echo "=== Creating Android Keystore for CaromStats ==="
echo ""

# Create keystore
keytool -genkey -v \
  -keystore upload-keystore.jks \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias upload \
  -storepass CaromStats2026 \
  -keypass CaromStats2026 \
  -dname "CN=Jean Godeyne, OU=CaromStats, O=Jean Godeyne, C=BE"

if [ $? -eq 0 ]; then
    echo ""
    echo "✓ Keystore created: upload-keystore.jks"
    echo ""
    echo "⚠️  IMPORTANT - Save these credentials securely:"
    echo "  Keystore password: CaromStats2026"
    echo "  Key password: CaromStats2026"
    echo "  Alias: upload"
    echo ""
else
    echo "✗ Failed to create keystore"
    exit 1
fi
