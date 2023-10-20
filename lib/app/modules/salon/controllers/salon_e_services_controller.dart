/*
 * File name: salon_e_services_controller.dart
 * Last modified: 2022.02.11 at 18:41:33
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:beauty_salons_customer/app/modules/global_widgets/tab_bar_widget.dart';
import 'package:beauty_salons_customer/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/booking_model.dart';
import '../../../models/category_model.dart';
import '../../../models/e_service_model.dart';
import '../../../models/option_group_model.dart';
import '../../../models/option_model.dart';
import '../../../repositories/category_repository.dart';
import '../../../repositories/salon_repository.dart';
import 'salon_controller.dart';

enum CategoryFilter { ALL, AVAILABILITY, RATING, FEATURED, POPULAR }

class SalonEServicesController extends GetxController {
  final booking = new Booking(eServices: [], options: [], quantity: 1).obs;
  final selected = Rx<CategoryFilter>(CategoryFilter.ALL);
  final categories = <Category>[].obs;
  final selectedCategories = <String>[].obs;
  final eServices = <EService>[].obs;
  final eCatServices = <Category>[].obs;
  final page = 0.obs;
  final isLoading = true.obs;
  List<String> filterType = ["All","Male","Female"];
  final selectedFilter = "All".obs;
  final isDone = false.obs;
  SalonRepository _salonRepository;
  CategoryRepository _categoryRepository;
  ScrollController scrollController = ScrollController();
  EService service;
  List<EService> services = [];
  bool fromOffer = false;
  SalonEServicesController() {
    _salonRepository = new SalonRepository();
    _categoryRepository = new CategoryRepository();
  }

  @override
  Future<void> onInit() async {
    booking.value.salon = Get.find<SalonController>().salon.value;
    if(Get.find<SalonController>().fromService.value){
      print("yes its");
      service =Get.find<SalonController>().service.value;
    }
    if(Get.find<SalonController>().fromBook){
      print("yes its");
      services =Get.find<SalonController>().services.toList();
    }
    if(Get.find<SalonController>().fromOffer){
      fromOffer = true;
    }
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !isDone.value) {
        loadEServicesOfCategory();
      }
    });
    await refreshEServices();
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
  }

  Future refreshEServices({bool showMessage}) async {
    await getCategories();
    toggleSelected(selected.value);
    await loadEServicesOfCategory();
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "List of services refreshed successfully".tr));
    }
  }

  bool isSelected(CategoryFilter filter) => selected == filter;

  void toggleSelected(CategoryFilter filter) {
    this.eServices.clear();
    this.page.value = 0;
    if (isSelected(filter)) {
      selected.value = CategoryFilter.ALL;
    } else {
      selected.value = filter;
    }
  }

  bool isSelectedCategory(Category category) {
    return selectedCategories.contains(category.id);
  }

  void toggleCategory(bool value, Category category) {
    this.eServices.clear();
    this.page.value = 0;
    if (value) {
      selectedCategories.add(category.id);
    } else {
      selectedCategories.removeWhere((element) => element == category.id);
    }
  }

  Future getCategories() async {
    try {
      categories.assignAll(await _categoryRepository.getAllParents());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future loadEServicesOfCategory() async {
    try {
      isLoading.value = true;
      isDone.value = false;
      this.page.value++;
      List<EService> _eServices = [];
      List<Category> _eCatServices = [];
      switch (selected.value) {
        case CategoryFilter.ALL:
          _eCatServices = await _salonRepository.getCatSalonEServices(booking.value.salon.id, selectedCategories,fromOffer?"1":"0", page: this.page.value);
          break;
        case CategoryFilter.FEATURED:
          _eServices = await _salonRepository.getFeaturedEServices(booking.value.salon.id, selectedCategories, page: this.page.value);
          break;
        case CategoryFilter.POPULAR:
          _eServices = await _salonRepository.getPopularEServices(booking.value.salon.id, selectedCategories, page: this.page.value);
          break;
        case CategoryFilter.RATING:
          _eServices = await _salonRepository.getMostRatedEServices(booking.value.salon.id, selectedCategories, page: this.page.value);
          break;
        case CategoryFilter.AVAILABILITY:
          _eServices = await _salonRepository.getAvailableEServices(booking.value.salon.id, selectedCategories, page: this.page.value);
          break;
        default:
          _eServices = await _salonRepository.getEServices(booking.value.salon.id, selectedCategories, page: this.page.value);
      }
      if (_eCatServices.isNotEmpty) {
        this.eCatServices.addAll(_eCatServices);
        print("yes its1");
        print(services.length);
        if(services.isNotEmpty){
          for(int j = 0; j <eCatServices.length;j++){
          for(int i = 0; i <services.length;i++){
            int index = this.eCatServices[j].eServices.indexWhere((element) => element.id==services[i].id);
            if(index!=-1&&booking.value.eServices.indexWhere((element) => element.id==this.eCatServices[j].eServices.elementAt(index).id)==-1){
              selectEService(this.eCatServices[j].eServices.elementAt(index));
            }
          }
        }
          if(booking.value.eServices.isNotEmpty){
            booking.update((val) {
              val.salon = Get.find<SalonController>().salon.value;
            });
          //  Get.toNamed(Routes.BOOK_E_SERVICE, arguments: {'booking': booking.value,'is_offer':fromOffer?"1":"0"});

          }
           }
        /*if(service!=null){
          if(this.eServices.indexWhere((element) => element.id==service.id)==-1){
            this.eServices.insert(0, service);
            selectEService(service);
          }else{
            selectEService(this.eServices[this.eServices.indexWhere((element) => element.id==service.id)]);
          }

        }*/
      } else {
        isDone.value = true;
      }
      if (_eServices.isNotEmpty) {
        this.eServices.addAll(_eServices);
        if(service!=null){
          if(this.eServices.indexWhere((element) => element.id==service.id)==-1){
            this.eServices.insert(0, service);
            selectEService(service);
          }else{
            selectEService(this.eServices[this.eServices.indexWhere((element) => element.id==service.id)]);
          }
        }
        print("yes its1");
        print(services.length);
        if(services.isNotEmpty){
          for(int i = 0; i <services.length;i++){
            int index = this.eServices.indexWhere((element) => element.id==services[i].id);
            if(index!=-1){
              selectEService(this.eServices.elementAt(index));
            }
          }
        }
      } else {
        isDone.value = true;
      }
    } catch (e) {
      this.isDone.value = true;
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      isLoading.value = false;
    }
  }

  void selectEService(EService eService) {
    if (eService?.enableBooking != null && eService.enableBooking) {
      print(booking.value.eServices.indexWhere((element) => element.id==eService.id)!=-1);
      booking.update((val) {
        if (val.eServices.indexWhere((element) => element.id==eService.id)!=-1) {
          val.eServices.removeAt(val.eServices.indexWhere((element) => element.id==eService.id));
          print("OKay");
          val.options = [];
        } else {
          val.eServices.add(eService);
        }
      });
     // booking.value.eServices.
    } else {
      Get.showSnackbar(Ui.notificationSnackBar(title: "Alert", message: "Service not enabled for booking".tr));
    }
  }

  bool isCheckedEService(EService eService) {
    return booking.value.eServices.indexWhere((element) => element.id==eService.id)!=-1;
  }

  void selectOption(OptionGroup optionGroup, Option option, EService eService) {
    if (eService?.enableBooking != null && eService.enableBooking) {
      booking.update((val) {
        if (val.options.contains(option)) {
          val.options.remove(option);
        } else {
          if (!optionGroup.allowMultiple) {
            val.options.removeWhere((element) => element.optionGroupId == optionGroup.id);
          }
          val.options.add(option);
        }
        if (!val.eServices.contains(eService)) {
          val.eServices.add(eService);
        }
      });
    } else {
      Get.showSnackbar(Ui.notificationSnackBar(title: "Alert", message: "Service not enabled for booking".tr));
    }
  }

  bool isCheckedOption(Option option) {
    return booking.value.options.contains(option);
  }

  // List<EService> getCheckedEServices() {
  //   if (eServices.isNotEmpty) {
  //     var _eServices = eServices.where((eService) => eService.checked.value).toList();
  //     _eServices.forEach((eService) {
  //       eService.optionGroups = eService.optionGroups.map((element) {
  //         element.options.removeWhere((element) => !element.checked.value);
  //         return element;
  //       }).toList();
  //     });
  //     return _eServices;
  //   }
  //   return [];
  // }

  TextStyle getTitleTheme(Option option) {
    if (isCheckedOption(option)) {
      return Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.colorScheme.secondary));
    }
    return Get.textTheme.bodyText2;
  }

  TextStyle getSubTitleTheme(Option option) {
    if (isCheckedOption(option)) {
      return Get.textTheme.caption.merge(TextStyle(color: Get.theme.colorScheme.secondary));
    }
    return Get.textTheme.caption;
  }

  Color getColor(Option option) {
    if (isCheckedOption(option)) {
      return Get.theme.colorScheme.secondary.withOpacity(0.1);
    }
    return null;
  }
}
