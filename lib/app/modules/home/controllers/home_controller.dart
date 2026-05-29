import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../models/surah_model.dart';
import '../../../network/api_services.dart';
import '../../../routes/app_pages.dart';

/// Handles Home state: surah list, local search, Juz navigation, and opening
/// the player after the selected surah audio data is ready.
class HomeController extends GetxController {
  HomeController({ApiServices? apiServices})
    : _apiServices = apiServices ?? ApiServices();

  static const double estimatedSurahItemExtent = 128;

  final ApiServices _apiServices;
  final selectedJuz = 1.obs;
  final isLoading = false.obs;
  final openingSurahNumber = RxnInt();
  final errorMessage = ''.obs;
  final searchController = TextEditingController();
  final searchQuery = ''.obs;
  final surahListKey = GlobalKey();
  final surahScrollController = ScrollController();
  final surahs = <SurahModel>[].obs;
  final surahItemKeys = <GlobalKey>[];
  final filteredSurahItemKeys = <GlobalKey>[];

  /// Locally filtered surah list from the already loaded `/surah` response.
  List<SurahModel> get filteredSurahs {
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) {
      return surahs;
    }

    return surahs.where((surah) {
      return surah.number.toString().contains(query) ||
          surah.title.toLowerCase().contains(query) ||
          surah.subtitle.toLowerCase().contains(query) ||
          surah.arabicName.toLowerCase().contains(query);
    }).toList();
  }

  /// Keys for the list currently rendered, either full or filtered.
  List<GlobalKey> get activeSurahItemKeys {
    return searchQuery.value.trim().isEmpty
        ? surahItemKeys
        : filteredSurahItemKeys;
  }

  @override
  void onInit() {
    super.onInit();
    getSurahs();
  }

  /// Loads all surahs used by the Home list and local search.
  Future<void> getSurahs() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _apiServices.getSurahs();
      surahs.assignAll(result);
      _syncListKeys();
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// Updates the local search query in real time.
  void updateSearch(String value) {
    searchQuery.value = value;
    _syncListKeys();
  }

  /// Clears search and restores the full surah list.
  void clearSearch() {
    searchController.clear();
    updateSearch('');
  }

  /// Fetches audio details first, then opens Player without a loading screen.
  Future<void> openSurah(SurahModel surah) async {
    if (openingSurahNumber.value != null) {
      return;
    }

    try {
      openingSurahNumber.value = surah.number;
      final detail = await _apiServices.getSurah(number: surah.number);
      await Get.toNamed(Routes.PLAYER, arguments: detail);
    } catch (e) {
      Get.snackbar(
        'Unable to open surah',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      openingSurahNumber.value = null;
    }
  }

  /// Scrolls to the closest visible surah for the selected Juz.
  void selectJuz(int juz) {
    selectedJuz.value = juz;

    final visibleSurahs = filteredSurahs;
    final visibleKeys = activeSurahItemKeys;
    final targetIndex = visibleSurahs.indexWhere(
      (surah) => surah.containsJuz(juz),
    );
    if (targetIndex == -1 || !surahScrollController.hasClients) {
      return;
    }

    final targetContext = visibleKeys[targetIndex].currentContext;
    if (targetContext != null) {
      Scrollable.ensureVisible(
        targetContext,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        alignment: 0,
      );
      return;
    }

    final targetOffset = targetIndex * estimatedSurahItemExtent;
    final maxOffset = surahScrollController.position.maxScrollExtent;

    surahScrollController.animateTo(
      targetOffset.clamp(0, maxOffset),
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  /// Stores the active Juz while the user scrolls manually.
  void updateVisibleJuz(int juz) {
    if (selectedJuz.value != juz) {
      selectedJuz.value = juz;
    }
  }

  /// Detects the first visible surah using layout position, not fixed offsets.
  void updateVisibleJuzFromLayout() {
    final listContext = surahListKey.currentContext;
    final visibleSurahs = filteredSurahs;
    final visibleKeys = activeSurahItemKeys;
    if (listContext == null || visibleSurahs.isEmpty) {
      return;
    }

    final listBox = listContext.findRenderObject() as RenderBox?;
    if (listBox == null || !listBox.attached) {
      return;
    }

    final listTop = listBox.localToGlobal(Offset.zero).dy;
    final listBottom = listTop + listBox.size.height;

    for (var index = 0; index < visibleKeys.length; index++) {
      final itemContext = visibleKeys[index].currentContext;
      if (itemContext == null) {
        continue;
      }

      final itemBox = itemContext.findRenderObject() as RenderBox?;
      if (itemBox == null || !itemBox.attached) {
        continue;
      }

      final itemTop = itemBox.localToGlobal(Offset.zero).dy;
      final itemBottom = itemTop + itemBox.size.height;
      final isFirstReadableItem = itemBottom > listTop && itemTop < listBottom;

      if (isFirstReadableItem) {
        updateVisibleJuz(visibleSurahs[index].startJuz);
        return;
      }
    }
  }

  /// Keeps item keys aligned with the rendered list for accurate scrolling.
  void _syncListKeys() {
    final allCount = surahs.length;
    while (surahItemKeys.length < allCount) {
      surahItemKeys.add(GlobalKey());
    }
    if (surahItemKeys.length > allCount) {
      surahItemKeys.removeRange(allCount, surahItemKeys.length);
    }

    final filteredCount = filteredSurahs.length;
    while (filteredSurahItemKeys.length < filteredCount) {
      filteredSurahItemKeys.add(GlobalKey());
    }
    if (filteredSurahItemKeys.length > filteredCount) {
      filteredSurahItemKeys.removeRange(
        filteredCount,
        filteredSurahItemKeys.length,
      );
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    surahScrollController.dispose();
    super.onClose();
  }
}
