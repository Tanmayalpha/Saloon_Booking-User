/*
 * File name: search_controller.dart
 * Last modified: 2022.02.18 at 19:24:11
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'dart:async';

import 'package:beauty_salons_customer/app/models/salon_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/category_model.dart';
import '../../../models/e_service_model.dart';
import '../../../repositories/category_repository.dart';
import '../../../repositories/e_service_repository.dart';

class SearchController1 extends GetxController {
  final heroTag = "".obs;
  final categories = <Category>[].obs;
  final genderList = ["Male", "Female"].obs;
  final selectedCategories = <String>[].obs;
  final selectedGender = "".obs;
  TextEditingController textEditingController;
  Timer debounce;
  final eServices = <EService>[].obs;
  final salon = <Salon>[].obs;
  EServiceRepository _eServiceRepository;
  CategoryRepository _categoryRepository;

  SearchController1() {
    _eServiceRepository = new EServiceRepository();
    _categoryRepository = new CategoryRepository();
    textEditingController = new TextEditingController();
  }

  @override
  void onInit() async {
    print("Show Type ${Get.arguments?.toString()}");
    heroTag.value = Get.arguments?.toString() ?? '';
    await refreshSearch();
    super.onInit();
  }

  @override
  void onReady() {
    print("Show Type ${Get.arguments?.toString()}");
    heroTag.value = Get.arguments?.toString() ?? '';
    super.onReady();
  }

  Future refreshSearch({bool showMessage}) async {
    await getCategories();
    await searchEServices();
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(
          message: "List of services refreshed successfully".tr));
    }
  }

  Future searchEServices({String keywords}) async {
    print("Show Type ${Get.arguments?.toString()}");
    heroTag.value = Get.arguments?.toString() ?? '';
    try {
      if (selectedCategories.isEmpty) {
        //categories.map((element) => element.id).toList()
        Map response = await _eServiceRepository.search(keywords, [], type: heroTag.value);
        eServices.assignAll(response['eServices']
            .map<EService>((obj) => EService.fromJson(obj))
            .toList());
        salon.assignAll(response['salons']
            .map<Salon>((obj) => Salon.fromJson(obj))
            .toList());
      } else {
        Map response = await _eServiceRepository.search(keywords, selectedCategories.toList(), type: heroTag.value);
        eServices.assignAll(response['eServices']
            .map<EService>((obj) => EService.fromJson(obj))
            .toList());
        salon.assignAll(response['salons']
            .map<Salon>((obj) => Salon.fromJson(obj))
            .toList());
      }
    } catch (e) {
      //Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getCategories() async {
    try {
      categories.assignAll(await _categoryRepository.getAllParents());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  bool isSelectedCategory(Category category) {
    return selectedCategories.contains(category.id);
  }

  void toggleCategory(bool value, Category category) {
    if (value) {
      selectedCategories.add(category.id);
    } else {
      selectedCategories.removeWhere((element) => element == category.id);
    }
    print(selectedCategories);
  }

  void toggleGender(String value) {
    selectedGender.value = value;
    print(selectedGender);
  }
}
