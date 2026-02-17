# OCR Result Entry Feature

## Overview
Feature to allow users to capture photos of scoreboards or paper score sheets and automatically extract result data using OCR (Optical Character Recognition).

## What's Possible

OCR can extract text from images of scoreboards or score sheets:

1. **Capture/select image** → Camera or photo library
2. **Extract text** → Recognize numbers (points, innings, highest run)
3. **Pre-fill form** → User reviews and confirms/edits before saving
4. **Validate** → Apply same validation rules as manual entry

## Technical Requirements

### 1. Image Capture
```yaml
# pubspec.yaml
dependencies:
  image_picker: ^1.0.7  # Camera + gallery access
```

### 2. OCR Processing

#### Option A: Google ML Kit (Recommended)
- ✅ Works **fully offline** (matches app architecture)
- ✅ Free, no API costs
- ✅ Good accuracy for printed text
- ⚠️ Limited for handwritten scores

```yaml
dependencies:
  google_ml_kit: ^0.16.3
  # Check pub.dev for latest version
```

#### Option B: Cloud-based (Firebase ML, AWS Textract)
- ❌ Requires internet connection
- ❌ Violates offline-first constraint
- ✅ Better handwritten recognition
- **Not recommended for this app**

### 3. Image Processing (Optional but helpful)
```yaml
dependencies:
  image: ^4.1.7  # Crop, rotate, enhance contrast
```

## Implementation Approach

### Basic Flow
```dart
// Add camera button to result entry form
IconButton(
  icon: Icon(Icons.camera_alt),
  onPressed: () async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (image != null) {
      final extractedData = await _processImage(image.path);
      _preFillForm(extractedData);
    }
  },
)
```

### OCR Service Example
```dart
import 'package:google_ml_kit/google_ml_kit.dart';

class OcrService {
  Future<ExtractedResultData> processScoreImage(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final textRecognizer = TextRecognizer();
    
    try {
      final RecognizedText recognizedText = 
        await textRecognizer.processImage(inputImage);
      
      return _parseScoreData(recognizedText);
    } finally {
      textRecognizer.close();
    }
  }
  
  ExtractedResultData _parseScoreData(RecognizedText recognizedText) {
    // Extract numbers with position data
    final numbers = _extractNumbersWithPositions(recognizedText);
    
    // Divide scoreboard into zones (left/center/right)
    final zones = _categorizeByZone(numbers, recognizedText.blocks);
    
    // Identify likely values based on zone and size
    final player1Points = _findLargestInZone(zones.left);
    final player2Points = _findLargestInZone(zones.right);
    final innings = _findValueInZone(zones.center);
    
    // Return both players' data - user selects which one
    return ExtractedResultData(
      player1: PlayerData(
        points: player1Points,
        highestRun: _findHighestRun(zones.left),
      ),
      player2: PlayerData(
        points: player2Points,
        highestRun: _findHighestRun(zones.right),
      ),
      innings: innings,
    );
  }
  
  List<NumberWithPosition> _extractNumbersWithPositions(
    RecognizedText text
  ) {
    // Extract all numbers with their x,y coordinates and size
    // This allows zone-based categorization
  }
  
  Zones _categorizeByZone(
    List<NumberWithPosition> numbers, 
    List<TextBlock> blocks
  ) {
    // Divide by horizontal position:
    // Left: x < width/3
    // Center: width/3 <= x <= 2*width/3
    // Right: x > 2*width/3
  }
}
```

## Challenges & Considerations

### 1. Accuracy Issues
- OCR isn't 100% accurate, especially with:
  - Handwritten scores
  - Poor lighting/angles
  - Unclear photos
- **Solution:** Always require user review/confirmation

### 2. Scoreboard Variety
- Different formats, layouts, languages
- **Common layout pattern:**
  - **Left side:** Player 1 - Points (large), Average, Highest run
  - **Center:** Innings (shared between both players)
  - **Right side:** Player 2 - Points (large), Highest run, Average
- Some variations: may show only points/innings/highest run, or include additional stats
- **Solution:** Extract all numbers and use position/size heuristics to suggest field mapping

### 3. Data Mapping
- OCR can't definitively know which number is points vs innings
- **Typical scoreboard layout helps:**
  - **Left/Right zones:** Player scores (larger font) - one is user's result
  - **Center zone:** Innings (shared)
  - **Smaller numbers near scores:** Highest runs
  - **Decimal numbers:** Averages (can be ignored for entry)
- **Solution:** Smart suggestions based on:
  - Position (left/right/center)
  - Value ranges (typical patterns)
  - Font size (larger = points)
  - Let user select which side is their result

### 4. Required Fields
- Photo might not have discipline/competition info
- **Solution:** OCR only fills numeric fields, user must still enter:
  - Discipline (with auto-complete)
  - Competition (required, with auto-suggest)
  - Date (default to today)
  - Adversary (optional)
  - Match outcome (optional)

## Real-World Scoreboard Examples

### Universal Pattern Across All Formats

**Key Insight:** Whether digital or paper, professional or casual, billiard scoreboards consistently follow a **left-right player layout**:
- **Left side/column** = Player 1
- **Right side/column** = Player 2

This consistency allows a unified OCR approach across different scoreboard types. The main differences are in how the data is presented (digital vs handwritten) and where totals appear (prominent vs summary section).

---

### Format 1: Digital Scoreboard (Electronic Display)

**Characteristics:** Printed/digital fonts, high contrast, prominent display

```
┌─────────────────────────────────────────────────────────┐
│ Header: Discipline info, Competition, Time              │
├──────────────┬──────────────────┬────────────────────────┤
│ PLAYER 1     │                  │ PLAYER 2               │
│ (Left side)  │    (Center)      │ (Right side)           │
├──────────────┼──────────────────┼────────────────────────┤
│   24         │       24         │   38                   │
│   (large)    │                  │   (large)              │
│              │   brt: 30        │                        │
│              │   (innings)      │                        │
│   0,800      │                  │   0,767                │
│   (4)        │                  │   (4)                  │
│ [avg/HR]     │                  │ [avg/HR]               │
└──────────────┴──────────────────┴────────────────────────┘
```

**Example:** "RUDI vs JOKKE" scoreboard
- **Header text:** "Driebanden (2,10)" → Discipline info
- **Left (RUDI):** 24 points, 0,800 avg, (4) HR
- **Center:** brt: 30 → Innings
- **Right (JOKKE):** 38 points, 0,767 avg, (4) or 23 HR

**OCR Strategy:**
1. Extract all numbers with position data
2. Identify zones (left/center/right)
3. Largest numbers in left/right → Points
4. Center area → Innings
5. Small numbers/parentheses → Highest runs
6. User selects their side

**Expected Accuracy:** ✅ High (95%+ with good photos)

---

### Format 2: Paper Scoresheet (Handwritten)

**Characteristics:** Handwritten, table format, detailed inning-by-inning

**Common Layout Pattern:** Like digital scoreboards, paper sheets follow **left-right player layout**:
- Left column = Player 1
- Right column = Player 2

**Note:** Specific layouts vary between clubs/competitions, but the left-right player structure is consistent.

```
┌──────────────────────────────────────────────────────────┐
│ Header: WEDSTRIJD, DATUM, Arbiter, Schrijver            │
├───────────────────────────┬──────────────────────────────┤
│ LEFT PLAYER               │ RIGHT PLAYER                 │
│ Naam van de vereniging    │ Naam van de vereniging       │
│ Naam v.d. speler          │ Naam v.d. speler             │
│ GODEYNE J      Car: 35   │ STEENBAKKERS CH   Car: 35   │
├───────────────────────────┼──────────────────────────────┤
│ [Inning-by-inning table]  │ [Inning-by-inning table]     │
│ Rows 1-60 with scores...  │ Rows 1-60 with scores...     │
├───────────────────────────┼──────────────────────────────┤
│ BOTTOM SECTION (KEY):     │ BOTTOM SECTION (KEY):        │
│ Totaal: 35                │ Totaal: 26                   │
│ Aant. beurten: 41         │ Aant. beurten: 47            │
│ Hoogste serie: 5          │ Hoogste serie: 3             │
│ Gemiddelde: 0,854         │ Gemiddelde: 0,634            │
│ Matchpunten: 2            │ Matchpunten: 0               │
└───────────────────────────┴──────────────────────────────┘
```

**Key Fields to Extract:**
- **Player names** (top): "GODEYNE J" vs "STEENBAKKERS CH"
- **Totaal** (Total points): 35 vs 26
- **Aant. beurten** (Number of innings): 41 vs 47
- **Hoogste serie** (Highest run): 5 vs 3
- **Matchpunten** (Match points): 2 vs 0 → indicates winner

**OCR Strategy:**
1. **Detect format type:** Digital scoreboard vs paper sheet (based on layout/content density)
2. **For paper sheets:**
   - Focus on BOTTOM 30-40% of image (summary section)
   - Ignore middle section (inning-by-inning details have too much noise)
3. **Keyword-based extraction** - Look for common terms:
   - "Totaal" / "Total" → Total points
   - "Aant. beurten" / "Beurten" / "Innings" → Number of innings
   - "Hoogste serie" / "Serie" / "Highest" → Highest run
   - "Matchpunten" / "Match" → Winner indication (optional)
4. **Apply left-right zone logic:**
   - Extract values for left player
   - Extract values for right player
5. **Extract player names from top section** (if legible)
6. **User selects which side is their result**
7. Pre-fill form with selected player's data

**Key Insight:** Paper sheets maintain the same left-right player structure as digital scoreboards, but layouts vary. Focus on the summary/totals section rather than trying to parse the entire sheet.

**Expected Accuracy:** ⚠️ Medium-Low (60-80%, handwriting dependent)

**Challenges:**
- Handwritten numbers harder to recognize (quality varies by person)
- Many irrelevant numbers in middle section (inning-by-inning scores = noise)
- Need to identify specific keywords (multi-language support needed)
- Paper sheet layouts vary by club/competition/region
- Bottom summary section may be in slightly different positions
- Varying handwriting quality and pen colors
- Paper texture, creases, shadows in photos

**Solution Approach:**
- **Universal pattern:** Always use left-right player structure
- Focus OCR on bottom 30-40% of image (ignore detailed middle section)
- Use keyword-based extraction with fuzzy matching
- Support multiple languages/terms: "Totaal/Total", "Beurten/Innings", "Serie/Highest"
- Require higher user confirmation for handwritten sheets
- Allow user to manually correct extracted values before form pre-fill

## Recommended MVP Implementation

### Phase 1: Basic OCR with Zone Detection

**Core Strategy:** Leverage the universal left-right player layout across all scoreboard formats.

1. **Add camera button** to result entry form
2. **Detect scoreboard type:**
   - Digital: Larger fonts, fewer elements, prominent center display
   - Paper: Dense table format, many rows, summary at bottom
3. **Apply format-specific extraction:**
   - **Digital:** Extract all numbers with position data, identify zones
   - **Paper:** Focus on bottom section, use keyword matching
4. **For both formats:**
   - Divide horizontally into left/right zones
   - Extract totals/points for each player
   - Extract innings (center on digital, keyword-based on paper)
   - Extract highest run for each side
5. **Show preview dialog** with both players' data in left-right layout
6. **User selects** which side is their result (left or right)
7. **Pre-fill form** with selected player's data
8. User confirms/edits and completes remaining required fields

### Phase 2: Smart Recognition (Future)
1. Text extraction for player names → auto-fill adversary
2. Discipline detection from header text
3. Pattern learning from user corrections
4. Support for different scoreboard orientations
5. Multi-language keyword support for paper sheets

## User Flow

```
1. User taps camera icon in add result form
2. User takes photo or selects from gallery
3. App processes image (show loading indicator)
4. Show preview with recognized scoreboard:
   ┌─────────────────────────────┐
   │ Left: 24 pts, (4) HR       │
   │ Innings: 30                 │
   │ Right: 38 pts, (23) HR     │
   └─────────────────────────────┘
   "Which side is your result?"
   [Left] [Right] [Cancel]
5. User selects their side (e.g., Right)
6. Form pre-fills with extracted data:
   - Points: 38
   - Innings: 30
   - Highest Run: 23
7. User completes remaining required fields:
   - Discipline (auto-complete)
   - Competition (required, auto-suggest)
   - Date (defaults to today)
   - Adversary: "RUDI" (optional, can extract from scoreboard)
   - Match outcome: User determines (won/lost/draw)
8. Normal validation rules apply
9. Save result
```

## Permissions Needed

### Android
```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<uses-permission android:name="android.permission.CAMERA"/>
<uses-feature android:name="android.hardware.camera" android:required="false"/>
```

### iOS
```xml
<!-- ios/Runner/Info.plist -->
<key>NSCameraUsageDescription</key>
<string>Take photos of scoreboards to quickly enter results</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Select scoreboard photos to enter results</string>
```

## UI/UX Design Considerations

### Add Result Screen
- Add camera icon/button next to form title
- Show as secondary option (manual entry remains primary)
- Clear visual feedback during processing

### Preview Dialog
- Show original photo (thumbnail)
- Display extracted data in scoreboard-like layout:
  ```
  Left Player          Right Player
  24 points           38 points
  (4) highest         (23) highest
       30 innings
  ```
- "Which side is your result?" with Left/Right buttons
- Highlight selected side
- Show warning if values seem unusual
- "Use these values" / "Try again" / "Enter manually" buttons

### Error Handling
- No text detected → "Could not recognize text. Please try again with better lighting."
- No numbers found → "No numbers detected. Please enter manually."
- Camera permission denied → Link to settings

### User Guidance
- First-time tooltip: "Try it with a clear photo of your scoreboard"
- Set expectations: "Works best with printed digital scoreboards"
- Show example of good vs bad photos
- **Digital scoreboards:** "Center the scoreboard and ensure good lighting"
- **Paper sheets:** "Focus on the bottom section with totals, ensure all summary values are visible and in focus"
- Tip: "Avoid shadows and glare on the paper"
- "Review extracted values before saving"

## Potential Enhancements (Phase 2+)

### 1. Adversary Name Extraction
- Scoreboards show both player names (e.g., "RUDI", "JOKKE")
- Extract text from top of left/right zones
- When user selects right side, auto-fill adversary with left player name
- Optional: user can confirm or edit

### 2. Discipline Detection from Header
- Headers often show discipline: "Driebanden (2,10)"
- Extract and match against known discipline names
- Auto-suggest or pre-select discipline in form
- Reduces manual entry further

### 3. Competition/Location Detection
- Some scoreboards show competition name or location
- Extract from header area
- Auto-suggest for competition field

### 4. Time/Date Detection
- Some scoreboards display time/date
- Could auto-fill date field
- Verify with user if date differs from today

### 5. Intelligent Highest Run Detection
- Numbers in parentheses like "(4)" or "(23)"
- Look for "HR:", "Highest:", or position near scores
- Improves accuracy over generic number extraction

## Testing Considerations

### Test Cases

**Digital Scoreboards:**
1. Standard two-player digital display (left-center-right layout)
2. Scoreboard with player names visible in header
3. Scoreboard with discipline info in header
4. Clear printed digital scoreboard photo
5. Scoreboard with decimal averages (ignore correctly)
6. Highest run in parentheses vs plain number

**Paper Scoresheets:**
7. Standard paper sheet with totals at bottom
8. Paper sheet from different club/venue (layout variations)
9. Handwritten sheet with clear legible numbers
10. Handwritten sheet with poor handwriting
11. Paper sheet with creases or shadows
12. Sheet with different language/terminology

**General/Both:**
13. Poor lighting conditions
14. Angled/distorted photo
15. When both players have similar scores
16. Winner vs loser (different total points)
17. No recognizable text
18. Camera permission denied
19. Gallery permission denied
20. Large image files (performance testing)

### Edge Cases
- Numbers exceed validation warnings (points > 500, innings > 200, HR > 300)
- Missing highest run from one or both sides
- Extra numbers (match info, time, carambole values)
- Text mixed with numbers in header
- Identical scores on both sides
- Single player practice (no opponent data)
- Paper sheets with incomplete bottom section
- Multiple matches on same sheet (older formats)
- Non-standard paper formats (custom/regional variations)
- Digital scoreboard with unusual color schemes affecting contrast
- Handwriting with unique number styles (European 7 with crossbar, etc.)

## Recommendation

**Start with Google ML Kit** because:
- ✅ Maintains offline-first architecture
- ✅ No ongoing costs
- ✅ Good enough for printed scoreboard photos
- ✅ Well-documented Flutter integration
- ⚠️ Set user expectations: "Works best with clear, printed scores"

The feature should be a **convenience tool**, not a replacement for manual entry. Always require user review of extracted data.

## Implementation Priority

**Consider as Phase 2 or 3 feature** because:
- Core functionality (manual entry) must be solid first
- Requires additional testing and refinement
- UX complexity (preview/confirmation flow)
- May have lower ROI compared to other features

**High value for users who:**
- Enter many results per session
- Compete frequently
- Have access to printed scoreboards

## Alternative Approaches

### 1. Template-based Recognition
- User defines scoreboard template (crop regions)
- Higher accuracy for same format
- Less flexible

### 2. Voice Input
- Speak numbers instead of photo
- Simpler implementation
- Less convenient (requires sequential entry)

### 3. QR Code on Scoreboards
- Requires organizers to change scoreboards
- Not feasible for most users

## Next Steps

1. Validate interest with users (user research)
2. Prototype with google_ml_kit using sample scoreboard photos
3. Test accuracy with real-world scoreboards
4. Design preview/confirmation UI
5. Implement and iterate based on feedback

---

**Document created:** February 17, 2026  
**Status:** Proposed feature - not yet implemented  
**Dependencies:** google_ml_kit, image_picker packages

## Expected Accuracy & Limitations

### Digital Scoreboards - High Confidence
- ✅ Large point numbers (24, 38) - typically **95%+ accuracy** with clear photos
- ✅ Innings in center area - high accuracy when clearly separated
- ✅ Numbers in standard digital font
- ✅ High contrast (white text on dark background, or vice versa)
- ✅ Player names in printed fonts

### Paper Scoresheets - Medium Confidence
- ⚠️ Total points - **70-85% accuracy** (depends on handwriting)
- ⚠️ Innings (Aant. beurten) - keyword matching helps
- ⚠️ Highest run - varies by handwriting and format
- ⚠️ Player names - legibility dependent
- ⚠️ Sheet layout variations require adaptive keyword matching

### Low Confidence / Challenging - Both Formats
- ❌ Heavily angled or distorted photos
- ❌ Poor lighting or glare
- ❌ Small/blurry text
- ❌ Unusual fonts or styling
- ❌ Very poor handwriting
- ❌ Incomplete or damaged paper sheets

### Key Design Principle
**Always require user review and confirmation.** OCR is a convenience feature to reduce typing, not a fully automated solution. The goal is to save time on 80% of cases while gracefully handling edge cases with manual override.

**Format-Specific Guidance:**
- **Digital scoreboards:** Primary use case - highest success rate
- **Paper sheets:** Secondary use case - user should verify all extracted values

