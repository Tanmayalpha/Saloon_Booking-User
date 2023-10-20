/*
 * File name: salon_controller.dart
 * Last modified: 2022.02.12 at 21:57:18
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../common/ui.dart';
import '../../../models/e_service_model.dart';
import '../../../models/message_model.dart';
import '../../../models/salon_model.dart';
import '../../../models/user_model.dart';
import '../../../repositories/salon_repository.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/tab_bar_widget.dart';
import '../views/salon_awards_view.dart';
import '../views/salon_details_view.dart';
import '../views/salon_e_services_view.dart';
import '../views/salon_experiences_view.dart';
import '../views/salon_galleries_view.dart';
import '../views/salon_reviews_view.dart';

class SalonController extends GetxController {
  final salon = Salon().obs;
  final currentSlide = 0.obs;
  final fromService = false.obs;
  var currentIndex = 0.obs;
  bool fromOffer = false;
  bool fromBook = false;
  final loading = false.obs;
  final service = EService().obs;
  List<EService> services = [];
  List<Widget> pages = [
    SalonEServicesView(),
    SalonDetailsView(),
    SalonReviewsView(),
    SalonGalleriesView(),
    SalonAwardsView(),
    SalonExperiencesView(),
  ];

  String heroTag = "";
  SalonRepository _salonRepository;

  SalonController() {
    _salonRepository = new SalonRepository();
  }

  @override
  void onInit() {
    if (Get.isRegistered<TabBarController>(tag: 'salon')) {
      Get.find<TabBarController>(tag: 'salon').selectedId.value = '0';
    }
    var arguments = Get.arguments as Map<String, dynamic>;
    salon.value = arguments['salon'] as Salon;
   // print("object1${salon.value.eService.length}");
    services = arguments['eService']!=null?arguments['eService'].toList():[];
        heroTag = arguments['heroTag'] as String;
      fromOffer = arguments['offer']!=null&&arguments['offer']!="0"?true:false;
    fromBook = arguments['book']!=null?true:false;
    if(arguments['service']!=null){
      service.value = arguments['service'] as EService;
      fromService.value = true;
      currentIndex.value = 0;
      if (Get.isRegistered<TabBarController>(tag: 'salon')) {
        Get
            .find<TabBarController>(tag: 'salon')
            .selectedId
            .value = '0';
      }
    }else{
      currentIndex.value = 0;
    }
     refreshSalon();
    super.onInit();
  }

  @override
  void onReady() async {
    await refreshSalon();
    if(fromService.value){
      if (Get.isRegistered<TabBarController>(tag: 'salon')) {
        Get
            .find<TabBarController>(tag: 'salon')
            .selectedId
            .value = '1';
      }
    }

    super.onReady();
  }
  void addFav(bool favorite,String salonId) async{
    if(!favorite){
      bool fav = await _salonRepository.addFav(salonId);
      if(fav) {
        salon.update((val) {
          val.isFavorites = true;
        });
      }
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Favorite Added"));
    }else{
      bool fav = await _salonRepository.deleteFav(salonId);
      if(fav) {
        salon.update((val) {
          val.isFavorites = false;
        });
      }
      Get.showSnackbar(Ui.ErrorSnackBar(message: "Favorite Removed"));
    }


  }
  Widget get currentPage => pages[currentIndex.value];

  void changePage(int index) {
    currentIndex.value = index;
  }


  Future refreshSalon({bool showMessage = false}) async {
    await getSalon();
    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: salon.value.name + " " + "page refreshed successfully".tr));
    }
  }

  Future getSalon() async {
    try {
      loading.value = true;
      var distance = salon.value.distance;
      salon.value = await _salonRepository.get(salon.value.id);
      salon.value.distance = distance;
      loading.value = false;
      /*if(fromService.value){
        print("yes its");
        salon.value.eService.insert(0, service.value);

      }*/
    } catch (e) {
      loading.value = false;
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  void startChat() {
    List<User> _employees = salon.value.employees.map((e) {
      e.avatar = salon.value.images[0];
      return e;
    }).toList();
    Message _message = new Message(_employees, name: salon.value.name);
    Get.toNamed(Routes.CHAT, arguments: _message);
  }
}
