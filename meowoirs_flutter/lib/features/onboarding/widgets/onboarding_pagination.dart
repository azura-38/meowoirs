import 'package:flutter/material.dart';
import '../../../core/theme/meowoirs_theme.dart';

/// 4-Dot Editorial Pagination Indicator matching OnboardingPagination in OnboardingComponents.kt.
class OnboardingPagination extends StatelessWidget {
  const OnboardingPagination({
    super.key,
    required this.currentStep,
    this.totalSteps = 4,
  });

  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        final step = index + 1;
        final isSelected = step == currentStep;
        final isPassed = step < currentStep;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          height: 8,
          width: isSelected ? 24 : 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: isSelected
                ? colors.orange
                : isPassed
                    ? colors.orange.withValues(alpha: 0.45)
                    : colors.cardBorder,
          ),
        );
      }),
    );
  }
}
