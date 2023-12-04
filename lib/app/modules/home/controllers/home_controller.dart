/*
 * File name: home_controller.dart
 * Last modified: 2022.02.06 at 16:15:29
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/address_model.dart';
import '../../../models/category_model.dart';
import '../../../models/salon_model.dart';
import '../../../models/slide_model.dart';
import '../../../repositories/category_repository.dart';
import '../../../repositories/salon_repository.dart';
import '../../../repositories/slider_repository.dart';
import '../../../services/settings_service.dart';
import '../../root/controllers/root_controller.dart';

enum HomeFilter { NEARBY, BRANDS, PACKAGES, SERVICES, OFFERS }

class HomeController extends GetxController {
  List<String> filterList = [
    "Near By",
    "Top Brands",
    "Popular Packages",
    "Popular Services",
    "Offers"
  ];
  SliderRepository _sliderRepo;
  CategoryRepository _categoryRepository;
  final selected = Rxn<HomeFilter>();
  //HomeFilter.NEARBY
  SalonRepository _salonRepository;

  final addresses = <Address>[].obs;
  final slider = <Slide>[].obs;
  final currentSlide = 0.obs;

  final salons = <Salon>[].obs;
  // List<Salon> salon = [];
  final categories = <Category>[].obs;
  final featured = <Category>[].obs;

  HomeController() {
    _sliderRepo = new SliderRepository();
    _categoryRepository = new CategoryRepository();
    _salonRepository = new SalonRepository();
  }

  @override
  Future<void> onInit() async {
    await refreshHome();
    super.onInit();
  }

  Future refreshHome({bool showMessage = false}) async {
    await getSlider();
    await getCategories();
    await getFeatured();
    await getRecommendedSalons();
    Get.find<RootController>().getNotificationsCount();
   // Get.find<SettingsService>().init();
    if (showMessage) {
      Get.showSnackbar(
          Ui.SuccessSnackBar(message: "Home page refreshed successfully".tr));
    }
  }

  bool isSelected(HomeFilter filter) => selected == filter;
  Address get currentAddress {
    return Get.find<SettingsService>().address.value;
  }

  void toggleSelected(HomeFilter filter) {
    if (isSelected(filter)) {
      selected.value = HomeFilter.NEARBY;
    } else {
      selected.value = filter;
    }
  }

  Future getSlider() async {
    try {
      slider.assignAll(await _sliderRepo.getHomeSlider());
    } catch (e) {
      if(e.toString().contains('DioErrorType.other')){
        Get.showSnackbar(Ui.ErrorSnackBar(message: 'No Internet Connection'));
      }else {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      }

    }
  }

  Future getCategories() async {
    try {
      categories.assignAll(await _categoryRepository.getAllParents());
    } catch (e) {
      if(e.toString().contains('DioErrorType.other')){
        Get.showSnackbar(Ui.ErrorSnackBar(message: 'No Internet Connection'));
      }else {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      }    }
  }

  Future getFeatured() async {
    try {
      featured.assignAll(await _categoryRepository.getFeatured());
    } catch (e) {
      if(e.toString().contains('DioErrorType.other')){
        Get.showSnackbar(Ui.ErrorSnackBar(message: 'No Internet Connection'));
      }else {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      }
    }
  }

  Future getRecommendedSalons() async {
    try {
      salons.clear();
      salons.assignAll(await _salonRepository.getRecommended());
    } catch (e) {
      if(e.toString().contains('DioErrorType.other')){
        Get.showSnackbar(Ui.ErrorSnackBar(message: 'No Internet Connection'));
      }else {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      }    }
  }
}
