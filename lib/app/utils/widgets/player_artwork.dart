import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

/// Large player artwork with a simple geometric Quran ornament.
class PlayerArtwork extends StatelessWidget {
  const PlayerArtwork({super.key, required this.arabicName});

  final String arabicName;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: const BoxDecoration(
          color: AppColors.primaryBlue,
          borderRadius: AppRadius.largeBorder,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: AppSpacing.lg,
              offset: Offset(0, AppSpacing.sm),
            ),
          ],
        ),
        child: CustomPaint(
          painter: _OrnamentPainter(),
          child: Center(
            child: Container(
              width: AppSpacing.xl * 5,
              height: AppSpacing.xl * 5,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withValues(alpha: 0.72),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.background.withValues(alpha: 0.42),
                ),
              ),
              child: Text(
                arabicName,
                textAlign: TextAlign.center,
                style: AppTextStyles.bold.s32.copyWith(
                  color: AppColors.background,
                  height: 1.2,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Draws the layered geometric ornament behind the Arabic surah name.
class _OrnamentPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = math.min(size.width, size.height) * 0.38;
    final fillPaint = Paint()
      ..color = AppColors.background.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = AppColors.background.withValues(alpha: 0.34)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (var layer = 0; layer < 3; layer++) {
      final radius = maxRadius - (layer * AppSpacing.md);
      final path = Path();
      final points = 24;

      for (var i = 0; i < points; i++) {
        final angle = -math.pi / 2 + (math.pi * 2 * i / points);
        final pointRadius = i.isEven ? radius : radius * 0.78;
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
      canvas.drawPath(path, fillPaint);
      canvas.drawPath(path, strokePaint);
    }

    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.background.withValues(alpha: 0.18),
          AppColors.background.withValues(alpha: 0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: maxRadius * 1.35));

    canvas.drawCircle(center, maxRadius * 1.35, glowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
