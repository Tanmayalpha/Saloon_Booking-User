/*
 * File name: e_service_repository.dart
 * Last modified: 2022.02.04 at 16:43:20
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:beauty_salons_customer/app/models/favorite_salon_model.dart';
import 'package:beauty_salons_customer/app/models/new_model/package_cat_model.dart';
import 'package:get/get.dart';

import '../models/e_service_model.dart';
import '../models/favorite_model.dart';
import '../models/option_group_model.dart';
import '../models/package_model.dart';
import '../models/review_model.dart';
import '../models/salon_model.dart';
import '../providers/laravel_provider.dart';

class EServiceRepository {
  LaravelApiClient _laravelApiClient;

  EServiceRepository() {
    this._laravelApiClient = Get.find<LaravelApiClient>();
  }

  Future<List<EService>> getAllWithPagination(String categoryId, {int page}) {
    return _laravelApiClient.getAllEServicesWithPagination(categoryId, page);
  }
  Future<Map> getNearSalon(String categoryId,genderId,sort) {
    Get.log("Test");
    return _laravelApiClient.getNearestSalon(categoryId,genderId,sort);
  }
  Future<bool> addFav(String salonId) {
    Get.log("Test");
    return _laravelApiClient.addFav(salonId);
  }
  Future<bool> deleteFav(String salonId) {
    Get.log("Test");
    return _laravelApiClient.deleteFav(salonId);
  }
  Future<Map> getServiceSalon(String categoryId,genderId,sort) {
    Get.log("Test");
    return _laravelApiClient.getServiceSalon(categoryId,genderId,sort);
  }
  Future<Map> getOfferSalon(String categoryId,genderId,sort) {
    Get.log("Test");
    return _laravelApiClient.getOfferSalon(categoryId,genderId,sort);
  }
  Future<List<PackageCatModel>> getCategory() {
    Get.log("Test");
    return _laravelApiClient.getCategory();
  }
  Future<List<PackageCatModel>> getCatService() {
    Get.log("Test");
    return _laravelApiClient.getCatService();
  }
  Future<Map> getPopularSalon(String categoryId,genderId,sort,{String featured}) {
    Get.log("Test");
    return _laravelApiClient.getPopularSalon(categoryId,genderId,sort,featured: featured);
  }
  Future<Map> search(String keywords, List<String> categories, {int page = 1,String type}) {
    return _laravelApiClient.searchEServices(keywords, categories, page,type);
  }

  Future<List<Favorite>> getFavorites() {
    return _laravelApiClient.getFavoritesEServices();
  }
  Future<List<FavoriteSalonModel>> getFavoriteSalon() {
    return _laravelApiClient.getFavoriteSalon();
  }
  Future<Favorite> addFavorite(Favorite favorite) {
    return _laravelApiClient.addFavoriteEService(favorite);
  }

  Future<bool> removeFavorite(Favorite favorite) {
    return _laravelApiClient.removeFavoriteEService(favorite);
  }

  Future<List<EService>> getFeatured(String categoryId, {int page}) {
    return _laravelApiClient.getFeaturedEServices(categoryId, page);
  }

  Future<List<EService>> getPopular(String categoryId, {int page}) {
    return _laravelApiClient.getPopularEServices(categoryId, page);
  }

  Future<List<EService>> getMostRated(String categoryId, {int page}) {
    return _laravelApiClient.getMostRatedEServices(categoryId, page);
  }

  Future<List<EService>> getAvailable(String categoryId, {int page}) {
    return _laravelApiClient.getAvailableEServices(categoryId, page);
  }

  Future<EService> get(String id) {
    return _laravelApiClient.getEService(id);
  }

  Future<List<Review>> getReviews(String eServiceId) {
    return _laravelApiClient.getEServiceReviews(eServiceId);
  }

  Future<List<OptionGroup>> getOptionGroups(String eServiceId) {
    return _laravelApiClient.getEServiceOptionGroups(eServiceId);
  }
}
