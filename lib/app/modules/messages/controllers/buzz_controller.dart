import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/new_model/buzz_model.dart';
import '../../../repositories/salon_repository.dart';

class BuzzController extends GetxController {
  ScrollController scrollController = ScrollController();

  SalonRepository _salonRepository;

  var buzz = <BuzData>[].obs;

  BuzzController() {
    _salonRepository = new SalonRepository();
  }


  @override
  Future<void> onInit() async {
    await refreshBuzz();
    super.onInit();
  }

  Future refreshBuzz({bool showMessage = false}) async {
    await getBuzz();
    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Page refreshed successfully".tr));
    }
  }
  Future getBuzz() async {
    try {
      buzz.assignAll(await _salonRepository.getBuzzRecommended());
    } catch (e) {
      if(e.toString().contains('DioErrorType.other')){
        Get.showSnackbar(Ui.ErrorSnackBar(message: 'No Internet Connection'));
      }else {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      }     }
  }

}

