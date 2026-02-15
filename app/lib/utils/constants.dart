/// App constants and suggested values
class AppConstants {
  // Suggested billiard disciplines for autocomplete
  static const List<String> suggestedDisciplines = [
    'Free game - Small table',
    'Free game - Match table',
    '1-cushion - Small table',
    '1-cushion - Match table',
    '3-cushion - Small table',
    '3-cushion - Match table',
    'Balkline 38/2 - Small table',
    'Balkline 57/2 - Small table',
    'Balkline 47/2 - Match table',
    'Balkline 47/1 - Match table',
    'Balkline 71/2 - Match table',
  ];

  // Validation thresholds for warnings
  static const int warningPointsThreshold = 500;
  static const int warningInningsThreshold = 200;
  static const int warningHighestRunThreshold = 300;
}
