import 'package:get/get.dart';

import '../controllers/favorites_controller.dart';

class FavoritesSalonBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FavoritesSalonController>(
      () => FavoritesSalonController(),
    );
  }
}
