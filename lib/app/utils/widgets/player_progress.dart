import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Current ayah progress, not the full surah duration.
class PlayerProgress extends StatelessWidget {
  const PlayerProgress({
    super.key,
    required this.progress,
    required this.currentTime,
    required this.totalTime,
    required this.onChanged,
  });

  final double progress;
  final String currentTime;
  final String totalTime;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              currentTime,
              style: AppTextStyles.medium.s12.copyWith(
                color: AppColors.secondaryText,
              ),
            ),
            const Spacer(),
            Text(
              totalTime,
              style: AppTextStyles.medium.s12.copyWith(
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 3,
            activeTrackColor: AppColors.primaryBlue,
            inactiveTrackColor: AppColors.border,
            thumbColor: AppColors.primaryBlue,
            overlayColor: AppColors.pressedOverlay,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
          ),
          child: Slider(value: progress.clamp(0, 1), onChanged: onChanged),
        ),
      ],
    );
  }
}
