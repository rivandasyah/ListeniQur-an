import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';

/// Main playback controls for ayah-based audio playback.
class PlayerControls extends StatelessWidget {
  const PlayerControls({
    super.key,
    required this.isPlaying,
    required this.onSkipBackward,
    required this.onTogglePlayback,
    required this.onSkipForward,
  });

  final bool isPlaying;
  final VoidCallback onSkipBackward;
  final VoidCallback onTogglePlayback;
  final VoidCallback onSkipForward;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SkipButton(icon: Icons.replay_5_rounded, onTap: onSkipBackward),
        const SizedBox(width: AppSpacing.xl),
        _PlayButton(isPlaying: isPlaying, onTap: onTogglePlayback),
        const SizedBox(width: AppSpacing.xl),
        _SkipButton(icon: Icons.forward_5_rounded, onTap: onSkipForward),
      ],
    );
  }
}

/// Large primary play/pause button.
class _PlayButton extends StatelessWidget {
  const _PlayButton({required this.isPlaying, required this.onTap});

  final bool isPlaying;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primaryBlue,
      borderRadius: BorderRadius.circular(AppRadius.large),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.large),
        child: SizedBox(
          width: AppSpacing.xl * 2.25,
          height: AppSpacing.xl * 2.25,
          child: Icon(
            isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
            color: AppColors.background,
            size: AppSpacing.xl,
          ),
        ),
      ),
    );
  }
}

/// Secondary 5-second skip button.
class _SkipButton extends StatelessWidget {
  const _SkipButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      borderRadius: AppRadius.largeBorder,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.largeBorder,
        child: Container(
          width: AppSpacing.xl * 1.75,
          height: AppSpacing.xl * 1.75,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColors.background,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: AppSpacing.md,
                offset: Offset(0, AppSpacing.xs),
              ),
            ],
          ),
          child: Icon(icon, color: AppColors.primaryBlue, size: AppSpacing.xl),
        ),
      ),
    );
  }
}
