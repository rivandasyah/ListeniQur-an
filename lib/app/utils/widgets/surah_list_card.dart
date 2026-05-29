import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

/// Reusable card for one surah row in the Home list.
class SurahListCard extends StatelessWidget {
  const SurahListCard({
    super.key,
    required this.number,
    required this.name,
    required this.subtitle,
    required this.meta,
    required this.arabicName,
    required this.onTap,
    this.isLoading = false,
  });

  final int number;
  final String name;
  final String subtitle;
  final String meta;
  final String arabicName;
  final VoidCallback? onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      borderRadius: AppRadius.mediumBorder,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.mediumBorder,
        child: Container(
          padding: AppSpacing.cardPadding,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: AppRadius.mediumBorder,
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: AppSpacing.md,
                offset: Offset(0, AppSpacing.xs),
              ),
            ],
          ),
          child: Row(
            children: [
              SurahNumberBadge(number: number),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bold.s16.copyWith(
                        color: AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.regular.s12.copyWith(
                        color: AppColors.secondaryText,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      meta,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.medium.s12.copyWith(
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                arabicName,
                textAlign: TextAlign.end,
                style: AppTextStyles.regular.s22.copyWith(
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              if (isLoading)
                const SizedBox(
                  width: AppSpacing.lg,
                  height: AppSpacing.lg,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primaryBlue,
                  ),
                )
              else
                const Icon(Icons.chevron_right, color: AppColors.secondaryText),
            ],
          ),
        ),
      ),
    );
  }
}

/// Decorative surah number badge inspired by Islamic geometry.
class SurahNumberBadge extends StatelessWidget {
  const SurahNumberBadge({super.key, required this.number});

  final int number;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: kMinInteractiveDimension,
      height: kMinInteractiveDimension,
      child: CustomPaint(
        painter: _BadgePainter(),
        child: Center(
          child: Text(
            '$number',
            style: AppTextStyles.semibold.s14.copyWith(
              color: AppColors.primaryBlue,
            ),
          ),
        ),
      ),
    );
  }
}

class _BadgePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 4;
    final path = Path();

    for (var i = 0; i < 16; i++) {
      final angle = -math.pi / 2 + (math.pi * 2 * i / 16);
      final pointRadius = i.isEven ? radius : radius * 0.88;
      final point = Offset(
        center.dx + math.cos(angle) * pointRadius,
        center.dy + math.sin(angle) * pointRadius,
      );

      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
