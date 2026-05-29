import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_text_styles.dart';
import '../../../utils/widgets/home_header.dart';
import '../../../utils/widgets/juz_selector.dart';
import '../../../utils/widgets/surah_list_card.dart';
import '../controllers/home_controller.dart';

/// Main screen for browsing, searching, and opening Quran surahs.
class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryBackground,
      body: Column(
        children: [
          HomeHeader(
            searchController: controller.searchController,
            onSearchChanged: controller.updateSearch,
            onClearSearch: controller.clearSearch,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.md,
            ),
            child: Obx(
              () => JuzSelector(
                selectedJuz: controller.selectedJuz.value,
                onSelected: controller.selectJuz,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Obx(
              () => Row(
                children: [
                  Text(
                    'All Surah',
                    style: AppTextStyles.bold.s16.copyWith(
                      color: AppColors.primaryText,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${controller.filteredSurahs.length} Surah',
                    style: AppTextStyles.medium.s12.copyWith(
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryBlue,
                  ),
                );
              }

              if (controller.errorMessage.value.isNotEmpty) {
                return _HomeErrorState(
                  message: controller.errorMessage.value,
                  onRetry: controller.getSurahs,
                );
              }

              if (controller.filteredSurahs.isEmpty) {
                return const _NoSurahFoundState();
              }

              // Only the surah list scrolls; header, search, and Juz stay fixed.
              return NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification.metrics.axis != Axis.vertical) {
                    return false;
                  }

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    controller.updateVisibleJuzFromLayout();
                  });
                  return false;
                },
                child: ListView.separated(
                  key: controller.surahListKey,
                  controller: controller.surahScrollController,
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    0,
                    AppSpacing.md,
                    AppSpacing.lg,
                  ),
                  itemCount: controller.filteredSurahs.length,
                  separatorBuilder: (_, index) =>
                      const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) {
                    final surah = controller.filteredSurahs[index];

                    return KeyedSubtree(
                      key: controller.activeSurahItemKeys[index],
                      child: SurahListCard(
                        number: surah.number,
                        name: surah.title,
                        subtitle: surah.subtitle,
                        meta: surah.meta,
                        arabicName: surah.arabicName,
                        isLoading:
                            controller.openingSurahNumber.value == surah.number,
                        onTap: () => controller.openSurah(surah),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

/// Empty state for local search results.
class _NoSurahFoundState extends StatelessWidget {
  const _NoSurahFoundState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.pagePadding,
      child: Center(
        child: Text(
          'No Surah found',
          textAlign: TextAlign.center,
          style: AppTextStyles.medium.s14.copyWith(
            color: AppColors.secondaryText,
          ),
        ),
      ),
    );
  }
}

/// Error state for the initial surah list request.
class _HomeErrorState extends StatelessWidget {
  const _HomeErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppSpacing.pagePadding,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Unable to load surah',
              textAlign: TextAlign.center,
              style: AppTextStyles.bold.s16.copyWith(
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.medium.s14.copyWith(
                color: AppColors.secondaryText,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
