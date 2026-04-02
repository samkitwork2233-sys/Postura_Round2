import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

class PostureIndicatorWidget extends StatelessWidget {
  final double value; // 0.0 to 1.0 (deviation)
  final double threshold;
  final bool isSafe;

  const PostureIndicatorWidget({
    required this.value,
    required this.threshold,
    required this.isSafe,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final indicatorColor = isSafe ? theme.colorScheme.primary : Colors.amber; // Using theme primary for safe (mint)

    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer Glow
        AnimatedContainer(
          duration: AppConstants.durationNormal,
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: indicatorColor.withValues(alpha: 0.2),
                blurRadius: 40,
                spreadRadius: 10,
              ),
            ],
          ),
        ),
        // Progress Ring
        SizedBox(
          width: 180,
          height: 180,
          child: CircularProgressIndicator(
            value: value.clamp(0.0, 1.0),
            strokeWidth: 12,
            backgroundColor: theme.colorScheme.outline.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
            strokeCap: StrokeCap.round,
          ),
        ),
        // Center Content
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSafe ? Icons.check_circle_outline : Icons.warning_amber_rounded,
              color: indicatorColor,
              size: 48,
            ),
            const SizedBox(height: 8),
            Text(
              "${(value * 100).toInt()}%",
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
