import 'package:beauty_salons_customer/app/models/favorite_salon_model.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/favorite_model.dart';
import '../../../repositories/e_service_repository.dart';

class FavoritesSalonController extends GetxController {
  final favorites = <FavoriteSalonModel>[].obs;
  EServiceRepository _eServiceRepository;

  FavoritesSalonController() {
    _eServiceRepository = new EServiceRepository();
  }

  @override
  void onInit() async {
    await refreshFavorites();
    super.onInit();
  }

  Future refreshFavorites({bool showMessage}) async {
    await getFavorites();
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "List of Services refreshed successfully".tr));
    }
  }
  void deleteFav(bool favorite,String salonId) async{
    bool fav = await _eServiceRepository.deleteFav(salonId);
    if(fav) {
      int i = favorites.indexWhere((element) =>
      element.salonId.toString() == salonId.toString());
      if (i != -1) {
        favorites.removeAt(i);
      }
    }
    favorites.refresh();
  }
  Future getFavorites() async {
    try {
      favorites.assignAll(await _eServiceRepository.getFavoriteSalon());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
