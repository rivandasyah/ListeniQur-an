import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_text_styles.dart';
import '../../../utils/widgets/player_artwork.dart';
import '../../../utils/widgets/player_controls.dart';
import '../../../utils/widgets/player_progress.dart';
import '../controllers/player_controller.dart';

/// Player screen focused on the currently playing ayah.
class PlayerView extends GetView<PlayerController> {
  const PlayerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.md,
            AppSpacing.lg,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: Get.back,
                    icon: const Icon(Icons.arrow_back_rounded),
                    color: AppColors.primaryText,
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: AppSpacing.sm),
                      PlayerArtwork(arabicName: controller.surah.arabicName),
                      const SizedBox(height: AppSpacing.xl),
                      Text(
                        controller.surah.title,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bold.s24.copyWith(
                          color: AppColors.primaryText,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        controller.ayahText,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.medium.s14.copyWith(
                          color: AppColors.secondaryText,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withValues(alpha: 0.10),
                          borderRadius: AppRadius.smallBorder,
                        ),
                        child: Text(
                          controller.juzText,
                          style: AppTextStyles.semibold.s12.copyWith(
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      Obx(() {
                        if (controller.errorMessage.value.isNotEmpty) {
                          return _PlayerErrorState(
                            message: controller.errorMessage.value,
                            onRetry: controller.prepareAudio,
                          );
                        }

                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.md),
                          child: Text(
                            controller.ayahPositionText,
                            style: AppTextStyles.semibold.s14.copyWith(
                              color: AppColors.primaryText,
                            ),
                          ),
                        );
                      }),
                      Obx(
                        () => PlayerProgress(
                          progress: controller.progress,
                          currentTime: controller.formatDuration(
                            controller.position.value,
                          ),
                          totalTime: controller.formatDuration(
                            controller.duration.value,
                          ),
                          onChanged: controller.seekToProgress,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      Obx(
                        () => PlayerControls(
                          isPlaying: controller.isPlaying.value,
                          onSkipBackward: controller.skipBackward,
                          onTogglePlayback: controller.togglePlayback,
                          onSkipForward: controller.skipForward,
                        ),
                      ),
                    ],
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

/// Error state when the prepared audio playlist cannot be played.
class _PlayerErrorState extends StatelessWidget {
  const _PlayerErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        children: [
          Text(
            'Unable to load audio',
            textAlign: TextAlign.center,
            style: AppTextStyles.bold.s16.copyWith(
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            message,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.medium.s12.copyWith(
              color: AppColors.secondaryText,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
