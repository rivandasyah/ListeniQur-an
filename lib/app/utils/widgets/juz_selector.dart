import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

/// Compact Juz selector with a scrub gesture for quick navigation.
class JuzSelector extends StatefulWidget {
  const JuzSelector({
    super.key,
    required this.selectedJuz,
    required this.onSelected,
  });

  final int selectedJuz;
  final ValueChanged<int> onSelected;

  @override
  State<JuzSelector> createState() => _JuzSelectorState();
}

class _JuzSelectorState extends State<JuzSelector> {
  static const int _totalJuz = 30;
  static const int _visibleChipCount = 6;
  static const double _previewWidth = 72;

  int? _previewJuz;
  double _previewDx = 0;

  bool get _isScrubbing => _previewJuz != null;

  @override
  Widget build(BuildContext context) {
    final visibleJuz = _visibleJuz(widget.selectedJuz);
    final scrubProgress =
        ((_previewJuz ?? widget.selectedJuz) - 1) / (_totalJuz - 1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Jump to Juz',
          style: AppTextStyles.semibold.s16.copyWith(
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        LayoutBuilder(
          builder: (context, constraints) {
            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onHorizontalDragStart: (details) => _updatePreview(
                details.localPosition.dx,
                constraints.maxWidth,
              ),
              onHorizontalDragUpdate: (details) => _updatePreview(
                details.localPosition.dx,
                constraints.maxWidth,
              ),
              onHorizontalDragEnd: (_) => _commitPreview(),
              onHorizontalDragCancel: _clearPreview,
              child: SizedBox(
                height:
                    kMinInteractiveDimension + AppSpacing.xl + AppSpacing.xs,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 80),
                      curve: Curves.easeOut,
                      left: _previewDx,
                      top: 0,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 120),
                        opacity: _isScrubbing ? 1 : 0,
                        child: _JuzPreviewBubble(
                          juz: _previewJuz ?? widget.selectedJuz,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: AppSpacing.lg,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          for (final juz in visibleJuz)
                            _JuzChip(
                              juz: juz,
                              isSelected: widget.selectedJuz == juz,
                              isPreviewed: _previewJuz == juz,
                              onTap: () => widget.onSelected(juz),
                            ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: _JuzScrubTrack(
                        progress: scrubProgress,
                        isScrubbing: _isScrubbing,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: AppSpacing.sm),
        Center(
          child: Text(
            _isScrubbing ? 'Release to jump' : 'Slide to preview a Juz',
            style: AppTextStyles.regular.s12.copyWith(
              color: AppColors.secondaryText,
            ),
          ),
        ),
      ],
    );
  }

  /// Keeps only a small range of Juz chips visible around the selected Juz.
  List<int> _visibleJuz(int selectedJuz) {
    final lastStart = _totalJuz - _visibleChipCount + 1;
    final start = (selectedJuz - 2).clamp(1, lastStart);

    return List.generate(_visibleChipCount, (index) => start + index);
  }

  /// Maps horizontal drag position to a Juz preview from 1 to 30.
  void _updatePreview(double localDx, double width) {
    final clampedDx = localDx.clamp(0, width);
    final progress = width == 0 ? 0.0 : clampedDx / width;
    final juz = (progress * (_totalJuz - 1)).round() + 1;
    final previewDx = (clampedDx - (_previewWidth / 2)).clamp(
      0.0,
      width - _previewWidth,
    );

    setState(() {
      _previewJuz = juz;
      _previewDx = previewDx;
    });
  }

  /// Commits the previewed Juz when the user releases the drag.
  void _commitPreview() {
    final previewJuz = _previewJuz;
    _clearPreview();

    if (previewJuz != null) {
      widget.onSelected(previewJuz);
    }
  }

  void _clearPreview() {
    if (_previewJuz == null) {
      return;
    }

    setState(() {
      _previewJuz = null;
    });
  }
}

class _JuzScrubTrack extends StatelessWidget {
  const _JuzScrubTrack({required this.progress, required this.isScrubbing});

  final double progress;
  final bool isScrubbing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final clampedProgress = progress.clamp(0.0, 1.0);
        final thumbSize = isScrubbing ? AppSpacing.md : AppSpacing.sm;
        final thumbLeft =
            (constraints.maxWidth * clampedProgress) - (thumbSize / 2);

        return SizedBox(
          height: AppSpacing.sm,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Positioned.fill(
                top: 3,
                bottom: 3,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: AppRadius.smallBorder,
                  ),
                ),
              ),
              Positioned(
                left: 0,
                width: constraints.maxWidth * clampedProgress,
                top: 3,
                bottom: 3,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue,
                    borderRadius: AppRadius.smallBorder,
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 80),
                curve: Curves.easeOut,
                left: thumbLeft.clamp(0.0, constraints.maxWidth - thumbSize),
                top: (AppSpacing.sm - thumbSize) / 2,
                width: thumbSize,
                height: thumbSize,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue,
                    shape: BoxShape.circle,
                    boxShadow: isScrubbing
                        ? const [
                            BoxShadow(
                              color: AppColors.shadow,
                              blurRadius: AppSpacing.sm,
                              offset: Offset(0, AppSpacing.xs),
                            ),
                          ]
                        : null,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Floating preview shown while scrubbing through Juz numbers.
class _JuzPreviewBubble extends StatelessWidget {
  const _JuzPreviewBubble({required this.juz});

  final int juz;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _JuzSelectorState._previewWidth,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryText,
        borderRadius: AppRadius.smallBorder,
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: AppSpacing.md,
            offset: Offset(0, AppSpacing.xs),
          ),
        ],
      ),
      child: Text(
        'Juz $juz',
        textAlign: TextAlign.center,
        style: AppTextStyles.semibold.s12.copyWith(color: AppColors.background),
      ),
    );
  }
}

class _JuzChip extends StatelessWidget {
  const _JuzChip({
    required this.juz,
    required this.isSelected,
    required this.isPreviewed,
    required this.onTap,
  });

  final int juz;
  final bool isSelected;
  final bool isPreviewed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isHighlighted = isSelected || isPreviewed;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(kMinInteractiveDimension),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: kMinInteractiveDimension,
        height: kMinInteractiveDimension,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isHighlighted ? AppColors.primaryBlue : AppColors.background,
          shape: BoxShape.circle,
          border: Border.all(
            color: isHighlighted ? AppColors.primaryBlue : AppColors.border,
          ),
          boxShadow: isSelected
              ? const [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: AppSpacing.sm,
                    offset: Offset(0, AppSpacing.xs),
                  ),
                ]
              : null,
        ),
        child: Text(
          '$juz',
          style: AppTextStyles.semibold.s14.copyWith(
            color: isHighlighted ? AppColors.background : AppColors.primaryBlue,
          ),
        ),
      ),
    );
  }
}
