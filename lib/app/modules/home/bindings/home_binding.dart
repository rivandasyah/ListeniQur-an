import 'package:get/get.dart';

import '../controllers/home_controller.dart';

/// Registers dependencies needed by the Home module.
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
