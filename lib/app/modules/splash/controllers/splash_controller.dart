import 'dart:async';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  Timer? _navigationTimer;

  @override
  void onReady() {
    super.onReady();

    // Show the prepared splash artwork before entering the app.
    _navigationTimer = Timer(const Duration(seconds: 5), () {
      Get.offAllNamed(Routes.HOME);
    });
  }

  @override
  void onClose() {
    _navigationTimer?.cancel();
    super.onClose();
  }
}
