# iOS Archive dSYM Fix for objective_c.framework

## Problem
When uploading to App Store Connect, you may encounter this error:
```
The archive did not include a dSYM for the objective_c.framework with the UUIDs [D4F4224B-FD8B-3606-BF4E-17E2444B61AA].
```

The `objective_c.framework` is part of Flutter's FFI (Foreign Function Interface) and doesn't always generate dSYM files correctly during archiving.

## Solution Implemented

This project includes automated scripts to generate the missing dSYM:

1. **generate_dsym.sh** - Automatically generates dSYM for objective_c.framework during build
2. **verify_archive_dsym.sh** - Verifies the dSYM is included in your archive

## How to Archive and Upload

### Step 1: Create Archive in Xcode

1. Open `Runner.xcworkspace` (NOT Runner.xcodeproj)
2. Select **Any iOS Device (arm64)** as destination
3. Clean build folder: **Product → Clean Build Folder** (⇧⌘K)
4. Archive: **Product → Archive** (⌘B then wait, then ⇧⌘B)
5. Wait for the archive to complete

### Step 2: Verify dSYM is in Archive

After archiving, run the verification script:

```bash
cd ios
./verify_archive_dsym.sh ~/Library/Developer/Xcode/Archives/YYYY-MM-DD/Runner*.xcarchive
```

Replace the path with your actual archive path. You can find archives at:
```bash
open ~/Library/Developer/Xcode/Archives/
```

### Step 3: If dSYM is Missing

If the verification script shows the dSYM is missing, manually copy it:

```bash
# Find your latest archive
ARCHIVE=$(ls -t ~/Library/Developer/Xcode/Archives/*/Runner*.xcarchive | head -1)

# Copy the dSYM to the archive
cp -r build/ios/Release-iphoneos/objective_c.framework.dSYM "${ARCHIVE}/dSYMs/"

# Verify again
./verify_archive_dsym.sh "$ARCHIVE"
```

### Step 4: Upload to App Store Connect

1. In Xcode Organizer, select your archive
2. Click **Distribute App**
3. Follow the upload wizard
4. The upload should now succeed without dSYM errors

## Alternative: Upload via Command Line

You can also upload using `xcrun altool` or `xcrun notarytool` after fixing the archive:

```bash
# Using altool (older method)
xcrun altool --upload-app --type ios --file "path/to/your.ipa" \
  --apiKey YOUR_API_KEY --apiIssuer YOUR_ISSUER_ID

# Using notarytool (newer method, macOS 12+)
xcrun notarytool submit "path/to/your.ipa" \
  --apple-id "your@email.com" --team-id YOUR_TEAM_ID --password "APP_SPECIFIC_PASSWORD"
```

## Troubleshooting

### The script doesn't run during archive
Make sure the build phase "Generate dSYM for objective_c" is present in your Runner target and positioned after "Thin Binary".

### dSYM UUID doesn't match
Run a clean build:
```bash
flutter clean
flutter pub get
cd ios && pod install
cd .. && flutter build ios --release
```

### Still getting errors
1. Verify the framework exists:
   ```bash
   ls -la build/ios/Release-iphoneos/Runner.app/Frameworks/objective_c.framework/
   ```

2. Check UUIDs match:
   ```bash
   dwarfdump --uuid build/ios/Release-iphoneos/Runner.app/Frameworks/objective_c.framework/objective_c
   dwarfdump --uuid build/ios/Release-iphoneos/objective_c.framework.dSYM/Contents/Resources/DWARF/objective_c
   ```

3. If UUIDs match but upload still fails, try re-archiving with a clean build.

## Technical Details

- **objective_c.framework**: Part of Flutter's dart:ffi support for calling native code
- **dSYM**: Debug symbol file used by Apple for crash reporting symbolication
- **UUID**: Unique identifier linking the framework binary to its debug symbols

The build phase "Generate dSYM for objective_c" runs after the "Thin Binary" phase to ensure all frameworks are present before generating debug symbols.
