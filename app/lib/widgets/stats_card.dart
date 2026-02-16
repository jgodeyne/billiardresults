import 'package:flutter/material.dart';
import '../models/discipline_stats.dart';
import '../models/competition_stats.dart';
import '../models/classification_level.dart';
import '../l10n/app_localizations.dart';

/// Generic card that can display either discipline or competition stats
class StatsCard extends StatelessWidget {
  final String title;
  final double currentAverage;
  final int highestRun;
  final int totalPoints;
  final int totalInnings;
  final int matchCount;
  final int wonCount;
  final int lostCount;
  final int drawCount;
  final int unknownCount;
  final String trend;
  final ClassificationLevel? classification;
  final VoidCallback onTap;

  const StatsCard({
    super.key,
    required this.title,
    required this.currentAverage,
    required this.highestRun,
    required this.totalPoints,
    required this.totalInnings,
    required this.matchCount,
    required this.wonCount,
    required this.lostCount,
    required this.drawCount,
    required this.unknownCount,
    required this.trend,
    this.classification,
    required this.onTap,
  });

  /// Create from DisciplineStats
  factory StatsCard.fromDiscipline({
    required DisciplineStats stats,
    ClassificationLevel? classification,
    required VoidCallback onTap,
  }) {
    return StatsCard(
      title: stats.discipline,
      currentAverage: stats.currentAverage,
      highestRun: stats.highestRun,
      totalPoints: stats.totalPoints,
      totalInnings: stats.totalInnings,
      matchCount: stats.matchCount,
      wonCount: stats.wonCount,
      lostCount: stats.lostCount,
      drawCount: stats.drawCount,
      unknownCount: stats.unknownCount,
      trend: stats.getTrend(),
      classification: classification,
      onTap: onTap,
    );
  }

  /// Create from CompetitionStats
  factory StatsCard.fromCompetition({
    required CompetitionStats stats,
    required VoidCallback onTap,
  }) {
    return StatsCard(
      title: stats.competition,
      currentAverage: stats.currentAverage,
      highestRun: stats.highestRun,
      totalPoints: stats.totalPoints,
      totalInnings: stats.totalInnings,
      matchCount: stats.matchCount,
      wonCount: stats.wonCount,
      lostCount: stats.lostCount,
      drawCount: stats.drawCount,
      unknownCount: stats.unknownCount,
      trend: stats.getTrend(),
      classification: null, // Competitions don't have classification levels
      onTap: onTap,
    );
  }

  Color? _getClassificationColor() {
    if (classification == null) return null;

    if (currentAverage > classification!.maxAverage) {
      return Colors.green.shade100;
    } else if (currentAverage < classification!.minAverage) {
      return Colors.red.shade100;
    }
    return null;
  }

  Icon _getTrendIcon() {
    switch (trend) {
      case 'up':
        return Icon(Icons.trending_up, color: Colors.green.shade700, size: 20);
      case 'down':
        return Icon(Icons.trending_down, color: Colors.red.shade700, size: 20);
      default:
        return Icon(Icons.trending_flat, color: Colors.grey.shade600, size: 20);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final classificationColor = _getClassificationColor();

    return Card(
      elevation: 2,
      color: classificationColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header: total points and innings in corners
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Total points (top left)
                  Text(
                    '$totalPoints',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                    ),
                  ),
                  // Total innings (top right)
                  Text(
                    '$totalInnings',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),

              // Title (discipline or competition name)
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Center: Average (large) with trend indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      currentAverage.toStringAsFixed(2),
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  _getTrendIcon(),
                ],
              ),
              const SizedBox(height: 2),
              Center(
                child: Text(
                  l10n.average,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Highest run
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.trending_up, size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      '${l10n.highestRun}: $highestRun',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade700,
                        fontSize: 11,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Bottom: W/L/D/? counts - use Wrap to prevent overflow
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 4,
                runSpacing: 4,
                children: [
                  _OutcomeChip(
                    label: l10n.won,
                    count: wonCount,
                    color: Colors.green.shade600,
                  ),
                  _OutcomeChip(
                    label: l10n.lost,
                    count: lostCount,
                    color: Colors.red.shade600,
                  ),
                  _OutcomeChip(
                    label: l10n.draw,
                    count: drawCount,
                    color: Colors.orange.shade600,
                  ),
                  if (unknownCount > 0)
                    _OutcomeChip(
                      label: l10n.unknown,
                      count: unknownCount,
                      color: Colors.grey.shade600,
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Center(
                child: Text(
                  '$matchCount ${l10n.matches}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OutcomeChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _OutcomeChip({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        '$label: $count',
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
