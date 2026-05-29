import 'package:get/get.dart';

import '../controllers/player_controller.dart';

/// Registers dependencies needed by the Player module.
class PlayerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlayerController>(() => PlayerController());
  }
}
