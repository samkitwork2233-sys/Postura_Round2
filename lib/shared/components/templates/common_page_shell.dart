import 'package:flutter/material.dart';
import 'package:postura/shared/constants/strings/index.dart';
import '../../constants/app_constants.dart';
import '../../constants/colors.dart';

class CommonPageShell extends StatelessWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? themeToggle;
  final Widget child;

  const CommonPageShell({
    required this.title,
    this.actions,
    this.themeToggle,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final topPadding = MediaQuery.paddingOf(context).top;

    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          gradient: RadialGradient(
            center: const Alignment(0.0, -0.7),
            radius: 1.3,
            colors: isDark
                ? [
                    const Color(0x3814B8A6), // teal highlight 22%
                    AppColors.backgroundDark,
                  ]
                : [
                    const Color(0xB3CCFBF1), // warm mint 70%
                    AppColors.backgroundLight,
                  ],
            stops: const [0.0, 1.0],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cohesive Header with Design Enhancement (Now extending to top)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.safeLight.withValues(alpha: 0.12),
                    AppColors.azure.withValues(alpha: 0.12),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border(
                  bottom: BorderSide(
                    color: theme.colorScheme.outline.withValues(alpha: 0.1),
                  ),
                ),
              ),
              padding: EdgeInsets.only(
                top: topPadding + AppConstants.spaceSM,
                bottom: AppConstants.spaceSM,
                left: AppConstants.spaceMD,
                right: AppConstants.spaceMD,
              ),
              child: Row(
                children: [
                  // Logo + App Name
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: theme.colorScheme.primary,
                        child: Icon(Icons.accessibility_new, size: 16, color: theme.colorScheme.onPrimary),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        CommonStrings.appName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  // Divider & Page Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Container(width: 1.5, height: 24, color: theme.colorScheme.outline.withValues(alpha: 0.2)),
                  ),
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (themeToggle != null) ...[
                    themeToggle!,
                    const SizedBox(width: 4),
                  ],
                  if (actions != null) ...actions!,
                ],
              ),
            ),
            // Display Area
            Expanded(
              child: SafeArea(
                top: false, // Header covers the top
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.spaceMD),
                  child: child,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
