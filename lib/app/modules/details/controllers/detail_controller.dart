import 'package:beauty_salons_customer/app/models/salon_model.dart';
import 'package:beauty_salons_customer/app/providers/laravel_provider.dart';
import 'package:beauty_salons_customer/app/services/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/category_model.dart';
import '../../../models/e_service_model.dart';
import '../../../models/new_model/package_cat_model.dart';
import '../../../models/package_model.dart';
import '../../../repositories/e_service_repository.dart';

enum CategoryFilter { ALL, AVAILABILITY, RATING, FEATURED, POPULAR }

class DetailController extends GetxController {
  final category =  <NewCategory>[].obs;
  final name = "".obs;
  final id = "".obs;

  final sort = Rxn<String>();
  final packageId = Rxn<String>();
  final packageIndex = 0.obs;
  final serviceId = Rxn<String>();
  final serviceIndex = 0.obs;
  final selected = Rx<CategoryFilter>(CategoryFilter.ALL);
  final eSalon = <Salon>[].obs;
  final ePackage = <PackageModel>[].obs;
  final eCatPackage = <PackageCatModel>[].obs;
  final eCatService = <PackageCatModel>[].obs;
  final page = 0.obs;
  final isLoading = true.obs;
  final isDone = false.obs;
  String serviceId1 = "";
  EServiceRepository _eServiceRepository;
  ScrollController scrollController = ScrollController();
  DetailController() {
    _eServiceRepository = new EServiceRepository();
  }

  @override
  Future<void> onInit() async {
   // name.value = Get.arguments as String;
    print(Get.arguments);
    if( Get.arguments!=null){
      if(Get.arguments is String){
    name.value = Get.arguments as String;
      }else{
        name.value = Get.arguments['name'] as String;
        serviceId1 = Get.arguments['id'] as String;
    }
  }
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !isDone.value) {
       // loadEServicesOfCategory(category.value.id, filter: selected.value);
      }
    });
    Get.find<LaravelApiClient>().forceRefresh();
    await refreshEServices();
    Get.find<LaravelApiClient>().unForceRefresh();
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
  }

  Future refreshEServices({bool showMessage}) async {
    eSalon.clear();
    await loadEServicesOfCategory(id.value, filter: selected.value);
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "List of services refreshed successfully".tr));
    }
  }

  bool isSelected(var filter) => id.value == filter.id;

  void toggleSelected(NewCategory filter) {
    this.eSalon.clear();
   // this.category.clear();
    this.page.value = 0;
    if (isSelected(filter)) {
      id.value = "";
    } else {
      id.value = filter.id;
    }
    loadEServicesOfCategory(id.value);
  }
  void toggleCatSelected(Category filter) {
    //this.id.value = filter.id;
    if(name.value=="Popular Packages"&&eCatPackage.length>0) {
      this.id.value = filter.id;
      for (int i = 0; i <
          eCatPackage[packageIndex.value].category.length; i++) {
        if (eCatPackage[packageIndex.value].category[i].id == filter.id) {
          eCatPackage[packageIndex.value].category[i].checked = true;
        } else {
          eCatPackage[packageIndex.value].category[i].checked = false;
        }
      }
      eCatPackage.refresh();
    }
    if(name.value=="Popular Services"&&eCatService.length>0) {
      this.id.value = filter.id;
      for (int i = 0; i <
          eCatService[serviceIndex.value].category.length; i++) {
        if (eCatService[serviceIndex.value].category[i].id == filter.id) {
          eCatService[serviceIndex.value].category[i].checked = true;
        } else {
          eCatService[serviceIndex.value].category[i].checked = false;
        }
      }
      eCatService.refresh();
    }
    this.eSalon.clear();
    this.category.clear();
    this.page.value = 0;
    loadEServicesOfCategory(id.value);
  }
  void addFav(bool favorite,String salonId) async{
    isLoading.value = true;
    if(!favorite){
      bool fav = await _eServiceRepository.addFav(salonId);
      if(fav) {
        int i = eSalon.indexWhere((element) =>
        element.id.toString() == salonId.toString());
        print("Selected Index ${i}");
        if (i != -1) {
          eSalon
              .elementAt(i)
              .isFavorites = true;

        }
        isLoading.value = false;
        eSalon.refresh();
        Get.showSnackbar(Ui.SuccessSnackBar(message:"Favorite Added" ));
      }
    }else{
      bool fav = await _eServiceRepository.deleteFav(salonId);
      if(fav) {
        int i = eSalon.indexWhere((element) =>
        element.id.toString() == salonId.toString());
        if (i != -1) {
          eSalon
              .elementAt(i)
              .isFavorites = false;
        }
        isLoading.value = false;
        eSalon.refresh();
        Get.showSnackbar(Ui.ErrorSnackBar(message:"Favorite Removed" ));
      }
    }



  }
  Future getCategory()async{

    if (eCatPackage!=null&&eCatPackage.length==0) {
      List<PackageCatModel>  _category = await _eServiceRepository.getCategory();
      _category.elementAt(0).category[0].checked=true;
      this.eCatPackage.addAll(_category);
    }
}
  Future loadEServicesOfCategory(String categoryId, {CategoryFilter filter}) async {
    /*final _address = Get.find<SettingsService>().address.value;
    if(_address.isUnknown()){
      showDialog(
          context: Get.context,
          barrierDismissible: true,
          builder: (ctx) {
            return AlertDialog(
              title: Text("Device Location Not Enabled"),
              content: Text(
                  "For a better user experience, please enable location permissions for this app"),
              *//*actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    child: Text("OK"))
              ],*//*
            );
          });
      return;
    }else{

    }*/
      isLoading.value = true;
      isDone.value = false;
      eSalon.clear();
      this.page.value++;
      if(name.value=="Near By"){
        List<Salon> _salon = [];
        List<NewCategory> _category = [];
        Map  response = await _eServiceRepository.getNearSalon(categoryId,packageId.value,sort.value);
        _category = response['category'];
        _salon = response['salon'];
        if (_category.isNotEmpty&&category.length==0) {
          category.add(NewCategory(id: "",title: "All"));
          this.category.addAll(_category);
        }
        if (_salon.isNotEmpty) {
          this.eSalon.addAll(_salon);
        } else {
          isDone.value = true;
        }
      }
      else if(name.value=="Top Brands"){
        List<Salon> _salon = [];
        /*if (eCatPackage!=null&&eCatPackage.length==0) {
          List<PackageCatModel>  _category = await _eServiceRepository.getCategory();
          _category.elementAt(0).category[0].checked=true;
          this.eCatPackage.addAll(_category);
          packageId.value = _category.elementAt(0).id;
          if(_category.elementAt(0).category.length>0){
            id.value = _category.elementAt(0).category[0].id;
          }
        }*/
       // print("package ${packageId.value}");
       // print("package ${eCatPackage.elementAt(1).id}");
        Map  response = await _eServiceRepository.getPopularSalon(id.value,packageId.value,sort.value,featured: "1");
        _salon = response['salon'];
        if (_salon.isNotEmpty) {
          this.eSalon.addAll(_salon);
        } else {
          isDone.value = true;
        }
      }
      else if(name.value=="Popular Packages"){
        List<Salon> _salon = [];
        if (eCatPackage!=null&&eCatPackage.length==0) {
          List<PackageCatModel>  _category = await _eServiceRepository.getCategory();
          _category.elementAt(0).category[0].checked=true;
          this.eCatPackage.addAll(_category);
            packageId.value = _category.elementAt(0).id;
            if(_category.elementAt(0).category.length>0){
              id.value = _category.elementAt(0).category[0].id;
            }
        }
        print("package ${packageId.value}");
        print("package ${eCatPackage.elementAt(1).id}");
        Map  response = await _eServiceRepository.getPopularSalon(id.value,packageId.value,sort.value);
        _salon = response['salon'];
        if (_salon.isNotEmpty) {
          this.eSalon.addAll(_salon);
        } else {
          isDone.value = true;
        }
      }
      else if(name.value=="Popular Services"){
        List<Salon> _salon = [];
        if (eCatService!=null&&eCatService.length==0) {
          List<PackageCatModel>  _category = await _eServiceRepository.getCatService();

          int index = _category.indexWhere((element) => element.id==serviceId1);
          if(serviceId1!=""&&index!=-1){
            serviceId.value = _category.elementAt(index).id;
            serviceIndex.value = index;
            if(_category.elementAt(index).category.length>0){
              _category.elementAt(index).category[0].checked=true;
              id.value = _category.elementAt(index).category[0].id;
            }
          }else{
            serviceId.value = _category.elementAt(0).id;
            if(_category.elementAt(0).category.length>0){
              id.value = _category.elementAt(0).category[0].id;
            }
            if(_category.elementAt(0).category.length>0){
              _category.elementAt(0).category[0].checked=true;
            }
          }
          this.eCatService.addAll(_category);
        }
        Map  response = await _eServiceRepository.getServiceSalon(id.value,packageId.value,sort.value);
        _salon = response['salon'];
        if (_salon.isNotEmpty) {
          this.eSalon.addAll(_salon);
        } else {
          isDone.value = true;
        }
      }
      else{
        List<Salon> _salon = [];
        List<NewCategory> _category = [];
        Map  response = await _eServiceRepository.getOfferSalon(categoryId,packageId.value,sort.value);
        _category = response['category'];
        _salon = response['salon'];
        if (_category!=null&&category.length==0) {
          category.add(NewCategory(id: "",title: "All"));
          this.category.addAll(_category);
        }
        if (_salon.isNotEmpty) {
          this.eSalon.addAll(_salon);
        } else {
          isDone.value = true;
        }
      }
      isLoading.value = false;
      await getCategory();
      /*switch (filter) {
        case CategoryFilter.ALL:
          _eServices = await _eServiceRepository.getAllWithPagination(categoryId, page: this.page.value);
          break;
        case CategoryFilter.FEATURED:
          _eServices = await _eServiceRepository.getFeatured(categoryId, page: this.page.value);
          break;
        case CategoryFilter.POPULAR:
          _eServices = await _eServiceRepository.getPopular(categoryId, page: this.page.value);
          break;
        case CategoryFilter.RATING:
          _eServices = await _eServiceRepository.getMostRated(categoryId, page: this.page.value);
          break;
        case CategoryFilter.AVAILABILITY:
          _eServices = await _eServiceRepository.getAvailable(categoryId, page: this.page.value);
          break;
        default:
          _eServices = await _eServiceRepository.getAllWithPagination(categoryId, page: this.page.value);
      }*/
      try {
    } catch (e) {
      this.isDone.value = true;
      isLoading.value = false;
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      isLoading.value = false;
    }
  }
}
