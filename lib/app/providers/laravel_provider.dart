/*
 * File name: laravel_provider.dart
 * Last modified: 2022.02.26 at 14:50:11
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'dart:convert';
import 'dart:ffi';
// import 'dart:html';
import 'dart:io';
// import 'dart:js';

import 'package:beauty_salons_customer/app/models/favorite_salon_model.dart';
import 'package:beauty_salons_customer/app/models/new_model/package_cat_model.dart';
import 'package:beauty_salons_customer/app/models/new_model/query_model.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../common/uuid.dart';
import '../models/address_model.dart';
import '../models/award_model.dart';
import '../models/booking_model.dart';
import '../models/booking_status_model.dart';
import '../models/category_model.dart';
import '../models/coupon_model.dart';
import '../models/custom_page_model.dart';
import '../models/e_service_model.dart';
import '../models/experience_model.dart';
import '../models/faq_category_model.dart';
import '../models/faq_model.dart';
import '../models/favorite_model.dart';
import '../models/gallery_model.dart';
import '../models/new_model/buzz_model.dart';
import '../models/new_model/login_with_otp.dart';
import '../models/notification_model.dart';
import '../models/option_group_model.dart';
import '../models/payment_method_model.dart';
import '../models/payment_model.dart';
import '../models/review_model.dart';
import '../models/salon_model.dart';
import '../models/setting_model.dart';
import '../models/slide_model.dart';
import '../models/user_model.dart';
import '../models/wallet_model.dart';
import '../models/wallet_transaction_model.dart';
import '../models/notification_model.dart' as Notify;
// import '../modules/auth/views/otp.dart';
import '../modules/auth/views/login_otp_view.dart';
import '../routes/app_routes.dart';
import '../services/settings_service.dart';
import 'api_provider.dart';

class LaravelApiClient extends GetxService with ApiClient {
  dio.Dio _httpClient;
  dio.Options _optionsNetwork;
  dio.Options _optionsCache;

  LaravelApiClient() {
    this.baseUrl = this.globalService.baseUrl;
    _httpClient = new dio.Dio();
  }

  Future<LaravelApiClient> init() async {
    if (foundation.kIsWeb || foundation.kDebugMode) {
      _optionsNetwork = dio.Options();
      _optionsCache = dio.Options();
    } else {
      _optionsNetwork =
          buildCacheOptions(Duration(days: 3), forceRefresh: true);
      _optionsCache =
          buildCacheOptions(Duration(minutes: 10), forceRefresh: false);
      _httpClient.interceptors.add(
          DioCacheManager(CacheConfig(baseUrl: getApiBaseUrl(""))).interceptor);
    }
    return this;
  }

  void forceRefresh({Duration duration = const Duration(minutes: 10)}) {
    if (!foundation.kDebugMode) {
      _optionsCache = dio.Options();

    }
  }

  void unForceRefresh({Duration duration = const Duration(minutes: 10)}) {
    if (!foundation.kDebugMode) {
      _optionsCache = buildCacheOptions(duration, forceRefresh: false);
    }
  }

  Future<List<Slide>> getHomeSlider() async {
    Uri _uri = getApiBaseUri("slides");
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Slide>((obj) => Slide.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);

    }
  }

  Future<User> getUser(User user) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ getUser() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("user").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(
      _uri,
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return User.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  /// old login function
  // Future<User> login(User user) async {
  //   Uri _uri = getApiBaseUri("login");
  //   Get.log(_uri.toString());
  //   var response = await _httpClient.postUri(
  //     _uri,
  //     data: json.encode(user.toJson()),
  //     options: _optionsNetwork,
  //   );
  //   if (response.data['success'] == true) {
  //     response.data['data']['auth'] = true;
  //     return User.fromJson(response.data['data']);
  //   } else {
  //     throw new Exception(response.data['message']);
  //   }
  // }

  Future<String> sendOtp(String mobile) async {
    print("check api.....${mobile.toString()}");
    var _queryParameters = {
      'mobile': "+91" +mobile,
    };
    //
        print("Parameters ${_queryParameters.toString()}");
    Uri _uri = getApiBaseUri("login-with-otp")
        .replace(queryParameters: _queryParameters);
    //.replace(queryParameters: _queryParameters)
    // Get.log(_uri.toString());
    // Uri _uri = getApiBaseUri("login-with-otp");
    Get.log(_uri.toString());
    var response = await _httpClient.postUri(
      _uri,
      data: jsonEncode(_queryParameters.toString()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      print("Now Working");
      print(response.data);
      var otp = response.data['data']['otp'];
      response.data['data']['auth'] = true;
      // Otp = LoginWithOtp.fromJson(jsonDecode(response.data['Otp']));
      print("Otp Here.....${otp.toString()}");
      //  response.data['data']['data']['otp']=otp.toString();
      // Get.toNamed(Routes.LOGIN_OTP_VIEW);
      // Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginOtpView()));
      return otp.toString();
      //return User.fromJson(response.data['data']['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<User> verifyOtp(Map param) async {
    Uri _uri = getApiBaseUri("verify-login");
    Get.log(_uri.toString());
    print(param);
    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(param),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      response.data['data']['auth'] = true;
      return User.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<User> register(User user) async {
    Uri _uri = getApiBaseUri("register");
    Get.log(_uri.toString());
    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(user.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      response.data['data']['auth'] = true;
      return User.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> sendResetLinkEmail(User user) async {
    Uri _uri = getApiBaseUri("send_reset_link_email");
    Get.log(_uri.toString());
    // to remove other attributes from the user object
    user = new User(email: user.email);
    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(user.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return true;
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<User> updateUser(User user) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ updateUser() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("users/${user.id}")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    Get.log(user.toJson().toString());
    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(user.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      response.data['data']['auth'] = true;
      return User.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Address>> getAddresses() async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ getAddresses() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'search': "user_id:${authService.user.value.id}",
      'searchFields': 'user_id:=',
      'orderBy': 'id',
      'sortedBy': 'desc',
    };
    Uri _uri =
        getApiBaseUri("addresses").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Address>((obj) => Address.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }
  Future<List<QueryModel>> getContactQuery() async {

    // TODO get Only Recommended
    Map<String, dynamic> _queryParameters = {

    };
    if (authService.apiToken != "") {
      _queryParameters['api_token'] = authService.apiToken;
    }

    Uri _uri =
    getApiBaseUri("salon_owner/get-contact-info").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<QueryModel>((obj) => QueryModel.fromJson(obj))
          .toList();
    } else {
      return  [];
      //  throw new Exception(response.data['message']);
    }
  }
  Future<List<Salon>> getRecommendedSalons() async {
    final _address = Get.find<SettingsService>().address.value;
    // TODO get Only Recommended
    var _queryParameters = {
      'only':
          'id;name;address;has_media;media;total_reviews;rate;salonLevel;distance;closed;closed_message',
      'with': 'salonLevel',
      'limit': '6',
    };
    if (authService.apiToken != "") {
      _queryParameters['api_token'] = authService.apiToken;
    }
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }else{
      return [];
    }
    Uri _uri =
        getApiBaseUri("salons").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Salon>((obj) => Salon.fromJson(obj))
          .toList();
    } else {
      //  throw new Exception(response.data['message']);
    }
  }
  Future<String> updateQuery(Map param) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    print(jsonEncode(param));
    Uri _uri = getApiBaseUri("salon_owner/send-contact-info")
        .replace(queryParameters: _queryParameters);
    var response = await _httpClient.postUri(_uri,
        data: jsonEncode(param), options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['message'];
    } else {
      throw new Exception(response.data['message']);
    }
  }
  Future<Map> getContact() async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("salon_owner/contact-details")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'][0];
    } else {
      throw new Exception(response.data['message']);
    }
  }
  /// New Buzz Api Function
  Future<List<BuzData>> getRecommendedBuzz() async {
    print("Buzz Api is Working");
    // final _address = Get.find<SettingsService>().address.value;
    // TODO get Only Recommended
    // var _queryParameters = {
    // 'only': 'id;name;has_media;media;total_reviews;rate;salonLevel;distance;closed',
    // 'with': 'salonLevel',
    // 'limit': '6',
    // };
    // if (!_address.isUnknown()) {
    //   _queryParameters['myLat'] = _address.latitude.toString();
    //   _queryParameters['myLon'] = _address.longitude.toString();
    // }
    Uri _uri = getApiBaseUri("buzz");
    Get.log(_uri.toString());
    print("Buzzzz");
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      // response.data['data'] = true;
      // return BuzzModel.fromJson(response.data['data']);
      // var buzz =  parsed.map<BuzzModel>((json) => BuzzModel.fromJson(json)).toList;
      // Map<String, BuzzModel> data = new Map<String, BuzzModel>.from(json.decode(response.data));
      return response.data['data']
          .map<BuzData>((obj) => BuzData.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Salon>> getNearSalons(LatLng latLng, LatLng areaLatLng) async {
    var _queryParameters = {
      'only':
          'id;name;has_media;media;total_reviews;rate;salonLevel;address;distance;closed;closed_message',
      'with': 'salonLevel;address',
      'limit': '6',
    };
    _queryParameters['myLat'] = latLng.latitude.toString();
    _queryParameters['myLon'] = latLng.longitude.toString();
    _queryParameters['areaLat'] = areaLatLng.latitude.toString();
    _queryParameters['areaLon'] = areaLatLng.longitude.toString();

    Uri _uri =
        getApiBaseUri("salons").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Salon>((obj) => Salon.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> getAllEServicesWithPagination(
      String categoryId, int page) async {
    final _address = Get.find<SettingsService>().address.value;
    var _queryParameters = {
      'with': 'categories;options;options.media;salon.address',
      'search': 'categories.id:$categoryId',
      'searchFields': 'categories.id:=',
      'searchJoin': 'and',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri =
        getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']['eServices']
          .map<EService>((obj) => EService.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Map> getNearestSalon(String categoryId, genderId, sort) async {
    final _address = Get.find<SettingsService>().address.value;
    Map<String, dynamic> _queryParameters = {
      // 'api_token': authService.apiToken,
    };
    if (authService.apiToken != "") {
      _queryParameters['api_token'] = authService.apiToken;
    }
    Map param = {};
    if (!_address.isUnknown()) {
      // _queryParameters['lat'] = _address.latitude.toString();
      // _queryParameters['lng'] = _address.longitude.toString();
      param['lat'] = _address.latitude.toString();
      param['lng'] = _address.longitude.toString();
    }

    if (categoryId != "") {
      param['salon_category_id'] = categoryId.toString();
    }
    if (genderId != null && genderId != "") {
      param['gender_id'] = genderId.toString();
    }
    if (sort != null && sort != "") {
      param['sort'] = sort.toString().replaceAll("Price ", "");
    }
    Uri _uri = getApiBaseUri("nearest-salons")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    Get.log(param.toString());
    var response = await _httpClient.postUri(_uri,
        data: json.encode(param), options: _optionsNetwork);
    print(
        "Api Response" + response.data['data']['salon_categories'].toString());
    if (response.data['success'] == true) {
      List<Salon> _salon = response.data['data']['salons']
          .map<Salon>((obj) => Salon.fromJson(obj))
          .toList();

      List<NewCategory> _category = response.data['data']['salon_categories']
          .map<NewCategory>((obj) => NewCategory.fromJson(obj))
          .toList();
      print(_category.length);
      return {
        "salon": _salon.toList(),
        "category": _category.toList(),
      };
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> addFav(String salonId) async {
    final _address = Get.find<SettingsService>().address.value;
    Map<String, dynamic> _queryParameters = {
      'api_token': authService.apiToken,
    };
    Map param = {
      "user_id": authService.user.value.id,
    };
    if (!_address.isUnknown()) {
      param['lat'] = _address.latitude.toString();
      param['lng'] = _address.longitude.toString();
    }
    if (salonId != "") {
      param['salon_id'] = salonId.toString();
    }
    print(param);
    Uri _uri =
        getApiBaseUri("favorites").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.postUri(
      _uri,
      data: param,
      options: _optionsNetwork,
    );
    print("Api Response" + response.data.toString());
    if (response.data['success'] == true) {
      return true;
    } else {
      //  throw new Exception(response.data['message']);
    }
  }

  Future<bool> deleteFav(String salonId) async {
    final _address = Get.find<SettingsService>().address.value;
    Map<String, dynamic> _queryParameters = {
      'api_token': authService.apiToken,
    };
    Map param = {
      "user_id": authService.user.value.id,
    };
    if (!_address.isUnknown()) {
      param['lat'] = _address.latitude.toString();
      param['lng'] = _address.longitude.toString();
    }
    if (salonId != "") {
      param['salon_id'] = salonId.toString();
    }
    Uri _uri = getApiBaseUri("favorites/${authService.user.value.id}")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.deleteUri(_uri,
        data: json.encode(param), options: _optionsNetwork);
    print("Api Response" + response.data.toString());
    if (response.data['success'] == true) {
      return true;
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<PackageCatModel>> getCategory() async {
    final _address = Get.find<SettingsService>().address.value;
    Map<String, dynamic> _queryParameters = {
      // 'api_token': authService.apiToken,
    };
    if (authService.apiToken != "") {
      _queryParameters['api_token'] = authService.apiToken;
    }
    Map param = {};
    if (!_address.isUnknown()) {
      param['lat'] = _address.latitude.toString();
      param['lng'] = _address.longitude.toString();
    }
    Uri _uri = getApiBaseUri("popular-package-category")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.postUri(_uri,
        data: json.encode(param), options: _optionsNetwork);
    print("Api Response" + response.data['data'].toString());
    if (response.data['success'] == true) {
      List<PackageCatModel> _package = response.data['data']
          .map<PackageCatModel>((obj) => PackageCatModel.fromJson(obj))
          .toList();
      print(_package.length);
      return _package.toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<PackageCatModel>> getCatService() async {
    final _address = Get.find<SettingsService>().address.value;
    Map<String, dynamic> _queryParameters = {
      // 'api_token': authService.apiToken,
    };
    if (authService.apiToken != "") {
      _queryParameters['api_token'] = authService.apiToken;
    }
    Map param = {};
    if (!_address.isUnknown()) {
      param['lat'] = _address.latitude.toString();
      param['lng'] = _address.longitude.toString();
    }
    Uri _uri = getApiBaseUri("popular-service-category")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    Get.log(param.toString());
    var response = await _httpClient.postUri(_uri,
        data: json.encode(param), options: _optionsNetwork);
    print("Api Response" + response.data['data'].toString());
    if (response.data['success'] == true) {
      List<PackageCatModel> _package = response.data['data']
          .map<PackageCatModel>((obj) => PackageCatModel.fromJson(obj))
          .toList();
      print(_package.length);
      return _package.toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Map> getServiceSalon(String categoryId, genderId, sort) async {
    final _address = Get.find<SettingsService>().address.value;
    Map<String, dynamic> _queryParameters = {
      // 'api_token': authService.apiToken,
    };
    if (authService.apiToken != "") {
      _queryParameters['api_token'] = authService.apiToken;
    }
    Map param = {};
    if (!_address.isUnknown()) {
      param['lat'] = _address.latitude.toString();
      param['lng'] = _address.longitude.toString();
    }

    if (categoryId != "") {
      param['service_category_id'] = categoryId.toString();
    }
    if (genderId != null && genderId != "") {
      param['gender_id'] = genderId.toString();
    }
    if (sort != null && sort != "") {
      param['sort'] = sort.toString().replaceAll("Price ", "");
    }
    Uri _uri = getApiBaseUri("salon-services")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    Get.log(param.toString());
    var response = await _httpClient.postUri(_uri,
        data: json.encode(param), options: _optionsNetwork);
    print("Api Response" + response.data['data']['salons'].toString());
    if (response.data['success'] == true) {
      List<Salon> _salon = response.data['data']['salons']
          .map<Salon>((obj) => Salon.fromJson(obj))
          .toList();
      List<NewCategory> _category = response.data['data']['service_categories']
          .map<NewCategory>((obj) => NewCategory.fromJson(obj))
          .toList();
      print(_category.length);
      return {
        "salon": _salon.toList(),
        "category": _category.toList(),
      };
    } else {
      // throw new Exception(response.data['message']);
    }
  }

  Future<Map> getOfferSalon(String categoryId, genderId, sort) async {
    final _address = Get.find<SettingsService>().address.value;
    Map<String, dynamic> _queryParameters = {
      // 'api_token': authService.apiToken,
    };
    if (authService.apiToken != "") {
      _queryParameters['api_token'] = authService.apiToken;
    }
    Map param = {};
    if (!_address.isUnknown()) {
      param['lat'] = _address.latitude.toString();
      param['lng'] = _address.longitude.toString();
    }

    if (categoryId != "") {
      param['filters'] = categoryId.toString();
    }
    if (genderId != null && genderId != "") {
      param['gender_id'] = genderId.toString();
    }
    if (sort != null && sort != "") {
      param['sort'] = sort.toString().replaceAll("Price ", "");
    }
    Uri _uri = getApiBaseUri("offer-services")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.postUri(_uri,
        data: json.encode(param), options: _optionsNetwork);
    print(param);
    print("Api Response" + response.data['data']['filters'].toString());
    if (response.data['success'] == true) {
      List<Salon> _salon = response.data['data']['salons']
          .map<Salon>((obj) => Salon.fromJson(obj))
          .toList();

      List<NewCategory> _category = response.data['data']['filters']
          .map<NewCategory>((obj) => NewCategory.fromJson(obj))
          .toList();
      print(_category.length);
      return {
        "salon": _salon.toList(),
        "category": _category.toList(),
      };
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Map> getPopularSalon(String categoryId, genderId, sort,
      {String featured}) async {
    final _address = Get.find<SettingsService>().address.value;

    Map<String, dynamic> _queryParameters = {
      // 'api_token': authService.apiToken,
    };
    if (authService.apiToken != "") {
      _queryParameters['api_token'] = authService.apiToken;
    }
    Map param = {};
    if (!_address.isUnknown()) {
      param['lat'] = _address.latitude.toString();
      param['lng'] = _address.longitude.toString();
    }
    if (featured != null) {
      param['featured'] = "1";
    }
    if (categoryId != "") {
      param['category_id'] = categoryId.toString();
    }
    if (genderId != null && genderId != "") {
      param['gender_id'] = genderId.toString();
    }
    if (sort != null && sort != "") {
      param['sort'] = sort.toString().replaceAll("Price ", "");
    }
    Uri _uri = getApiBaseUri("popular-packages")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    Get.log(param.toString());
    var response = await _httpClient.postUri(_uri,
        data: json.encode(param), options: _optionsNetwork);
    print("Api Response" + response.data['data'].toString());
    if (response.data['success'] == true) {
      List<Salon> _salon = response.data['data']
          .map<Salon>((obj) => Salon.fromJson(obj))
          .toList();

      //  List<NewCategory> _category = response.data['data']['salon_categories'].map<NewCategory>((obj) => NewCategory.fromJson(obj)).toList();
      // print(_category.length);
      return {
        "salon": _salon.toList(),
        // "category":_category.toList(),
      };
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Map> searchEServices(
      String keywords, List<String> categories, int page, String type) async {
    final _address = Get.find<SettingsService>().address.value;
    // TODO Pagination
    var _queryParameters = {
      'with': 'salon;salon.address;categories',
      'search': 'salon.name:${keywords};categories.id:${categories.join(',')};name:',
      'searchFields': 'salon.name:like;categories.id:in;name:like',
      'searchJoin': 'and',
      'type': type,
    };
   // $keywords
    print(_queryParameters);
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri =
        getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'];
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Favorite>> getFavoritesEServices() async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ getFavoritesEServices() ]");
    }
    var _queryParameters = {
      'with': 'eService;options;eService.salon',
      'search': 'user_id:${authService.user.value.id}',
      'searchFields': 'user_id:=',
      'orderBy': 'created_at',
      'sortBy': 'desc',
      'api_token': authService.apiToken,
    };
    Uri _uri =
        getApiBaseUri("favorites").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Favorite>((obj) => Favorite.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<FavoriteSalonModel>> getFavoriteSalon() async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ getFavoritesEServices() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri =
        getApiBaseUri("favorites").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<FavoriteSalonModel>((obj) => FavoriteSalonModel.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Favorite> addFavoriteEService(Favorite favorite) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You must have an account to be able to add services to favorite".tr +
              "[ addFavoriteEService() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri =
        getApiBaseUri("favorites").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(favorite.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      response.data['data']['auth'] = true;
      return Favorite.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> removeFavoriteEService(Favorite favorite) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You must have an account to be able to add services to favorite".tr +
              "[ removeFavoriteEService() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri =
        getApiBaseUri("favorites/1").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.deleteUri(
      _uri,
      data: json.encode(favorite.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return response.data['data'];
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<EService> getEService(String id) async {
    var _queryParameters = {
      'with': 'salon;salon.taxes;salon.users;salon.address;categories',
    };
    if (authService.isAuth) {
      _queryParameters['api_token'] = authService.apiToken;
    }
    Uri _uri = getApiBaseUri("e_services/$id")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return EService.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Salon> getSalon(String salonId) async {
    var _queryParameters = {
      'with': 'salonLevel;availabilityHours;users;taxes;address',
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("salons/$salonId")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Salon.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List> getAvailabilityHours(
      String salonId, DateTime date, String employeeId, minute,String isOffer) async {
    var _queryParameters = {
      'date': DateFormat('y-MM-dd').format(date),
      'employee_id': employeeId ?? '0',
      "minutes": minute,
      'is_offer':isOffer
    };
    Uri _uri = getApiBaseUri("availability_hours/$salonId")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'];
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Review>> getSalonReviews(String salonId) async {
    var _queryParameters = {
      'with': 'salonReviews;salonReviews.booking;salonReviews.booking.user',
      'only': 'salonReviews',
    };
    Uri _uri = getApiBaseUri("salons/$salonId")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']['salon_reviews']
          .map<Review>((obj) => Review.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Gallery>> getSalonGalleries(String salonId) async {
    var _queryParameters = {
      'with': 'media',
      'search': 'salon_id:$salonId',
      'searchFields': 'salon_id:=',
      'orderBy': 'updated_at',
      'sortedBy': 'desc',
    };
    Uri _uri =
        getApiBaseUri("galleries").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Gallery>((obj) => Gallery.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Award>> getSalonAwards(String salonId) async {
    var _queryParameters = {
      'search': 'salon_id:$salonId',
      'searchFields': 'salon_id:=',
      'orderBy': 'updated_at',
      'sortedBy': 'desc',
    };
    Uri _uri =
        getApiBaseUri("awards").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Award>((obj) => Award.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Experience>> getSalonExperiences(String salonId) async {
    var _queryParameters = {
      'search': 'salon_id:$salonId',
      'searchFields': 'salon_id:=',
      'orderBy': 'updated_at',
      'sortedBy': 'desc',
    };
    Uri _uri =
        getApiBaseUri("experiences").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Experience>((obj) => Experience.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> getSalonFeaturedEServices(
      String salonId, List<String> categories, int page) async {
    var _queryParameters = {
      'with':
          'categories;optionGroups;optionGroups.options;optionGroups.options.media',
      'search':
          'categories.id:${categories.join(',')};salon_id:$salonId;featured:1',
      'searchFields': 'categories.id:in;salon_id:=;featured:=',
      'searchJoin': 'and',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    Uri _uri =
        getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']['eServices']
          .map<EService>((obj) => EService.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> getSalonPopularEServices(
      String salonId, List<String> categories, int page) async {
    // TODO popular eServices
    var _queryParameters = {
      'with':
          'categories;optionGroups;optionGroups.options;optionGroups.options.media',
      'search': 'categories.id:${categories.join(',')};salon_id:$salonId',
      'searchFields': 'categories.id:in;salon_id:=',
      'searchJoin': 'and',
      'rating': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    Uri _uri =
        getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']['eServices']
          .map<EService>((obj) => EService.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> getSalonAvailableEServices(
      String salonId, List<String> categories, int page) async {
    var _queryParameters = {
      'with':
          'categories;optionGroups;optionGroups.options;optionGroups.options.media',
      'search': 'categories.id:${categories.join(',')};salon_id:$salonId',
      'searchFields': 'categories.id:in;salon_id:=',
      'searchJoin': 'and',
      'available_salon': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    Uri _uri =
        getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']['eServices']
          .map<EService>((obj) => EService.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> getSalonMostRatedEServices(
      String salonId, List<String> categories, int page) async {
    var _queryParameters = {
      //'only': 'id;name;price;discount_price;price_unit;duration;has_media;total_reviews;rate',
      'with':
          'categories;optionGroups;optionGroups.options;optionGroups.options.media',
      'search': 'categories.id:${categories.join(',')};salon_id:$salonId',
      'searchFields': 'categories.id:in;salon_id:=',
      'searchJoin': 'and',
      'rating': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    Uri _uri =
        getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']['eServices']
          .map<EService>((obj) => EService.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<User>> getSalonEmployees(String salonId) async {
    var _queryParameters = {
      'with': 'users',
      'only':
          'users;users.id;users.name;users.email;users.phone_number;users.device_token'
    };
    Uri _uri = getApiBaseUri("salons/$salonId")
        .replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']['users']
          .map<User>((obj) => User.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Category>> getCatSalonEServices(
      String salonId, List<String> categories, int page,String isOffer) async {
    var _queryParameters = {
      //'with': 'categories;optionGroups;optionGroups.options;optionGroups.options.media',
    //  'search': 'categories.id:${categories.join(',')};salon_id:$salonId',
    //  'searchFields': 'categories.id:in;salon_id:=',
    //  'searchJoin': 'and',
    //  'limit': '4',
      'is_offer': isOffer,
      //'offset': ((page - 1) * 4).toString()
    };
    if (authService.apiToken != "") {
      _queryParameters['api_token'] = authService.apiToken;
    }
    Uri _uri = getApiBaseUri("salon-services/${salonId}").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Category>((obj) => Category.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> getSalonEServices(
      String salonId, List<String> categories, int page) async {
    var _queryParameters = {
      'with':
          'categories;optionGroups;optionGroups.options;optionGroups.options.media',
      'search': 'categories.id:${categories.join(',')};salon_id:$salonId',
      'searchFields': 'categories.id:in;salon_id:=',
      'searchJoin': 'and',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };

    Uri _uri =
        getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']['eServices']
          .map<EService>((obj) => EService.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Review>> getEServiceReviews(String eServiceId) async {
    var _queryParameters = {
      'with': 'user',
      'only': 'created_at;review;rate;user',
      'search': "e_service_id:$eServiceId",
      'orderBy': 'created_at',
      'sortBy': 'desc',
      'limit': '10'
    };
    Uri _uri = getApiBaseUri("e_service_reviews")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Review>((obj) => Review.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<OptionGroup>> getEServiceOptionGroups(String eServiceId) async {
    var _queryParameters = {
      'with': 'options;options.media',
      'only':
          'id;name;allow_multiple;options.id;options.name;options.description;options.price;options.option_group_id;options.e_service_id;options.media',
      'search': "options.e_service_id:$eServiceId",
      'searchFields': 'options.e_service_id:=',
      'orderBy': 'name',
      'sortBy': 'desc'
    };
    Uri _uri = getApiBaseUri("option_groups")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<OptionGroup>((obj) => OptionGroup.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> getFeaturedEServices(
      String categoryId, int page) async {
    final _address = Get.find<SettingsService>().address.value;
    var _queryParameters = {
      //'only': 'id;name;price;discount_price;price_unit;duration;has_media;total_reviews;rate',
      'with': 'salon;salon.address;categories',
      'search': 'categories.id:$categoryId;featured:1',
      'searchFields': 'categories.id:=;featured:=',
      'searchJoin': 'and',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri =
        getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']['eServices']
          .map<EService>((obj) => EService.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> getPopularEServices(
      String categoryId, int page) async {
    final _address = Get.find<SettingsService>().address.value;
    var _queryParameters = {
      //'only': 'id;name;price;discount_price;price_unit;duration;has_media;total_reviews;rate',
      'with': 'salon;salon.address;categories',
      'search': 'categories.id:$categoryId',
      'searchFields': 'categories.id:=',
      'rating': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri =
        getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']['eServices']
          .map<EService>((obj) => EService.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> getMostRatedEServices(
      String categoryId, int page) async {
    final _address = Get.find<SettingsService>().address.value;
    var _queryParameters = {
      //'only': 'id;name;price;discount_price;price_unit;duration;has_media;total_reviews;rate',
      'with': 'salon;salon.address;categories',
      'search': 'categories.id:$categoryId',
      'searchFields': 'categories.id:=',
      'rating': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri =
        getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']['eServices']
          .map<EService>((obj) => EService.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> getAvailableEServices(
      String categoryId, int page) async {
    final _address = Get.find<SettingsService>().address.value;
    var _queryParameters = {
      'with': 'salon;salon.address;categories',
      'search': 'categories.id:$categoryId',
      'searchFields': 'categories.id:=',
      'available_salon': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri =
        getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']['eServices']
          .map<EService>((obj) => EService.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Category>> getAllCategories() async {
    const _queryParameters = {
      'orderBy': 'order',
      'sortBy': 'asc',
    };
    Uri _uri =
        getApiBaseUri("categories").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Category>((obj) => Category.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Category>> getAllParentCategories() async {
    const _queryParameters = {
      'parent': 'true',
      'orderBy': 'order',
      'sortBy': 'asc',
    };
    Uri _uri =
        getApiBaseUri("categories").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Category>((obj) => Category.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Category>> getSubCategories(String categoryId) async {
    final _queryParameters = {
      'search': "parent_id:$categoryId",
      'searchFields': "parent_id:=",
      'orderBy': 'order',
      'sortBy': 'asc',
    };
    Uri _uri =
        getApiBaseUri("categories").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Category>((obj) => Category.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Category>> getAllWithSubCategories() async {
    const _queryParameters = {
      'with': 'subCategories',
      'parent': 'true',
      'orderBy': 'order',
      'sortBy': 'asc',
    };
    Uri _uri =
        getApiBaseUri("categories").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Category>((obj) => Category.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Category>> getFeaturedCategories() async {
    final _address = Get.find<SettingsService>().address.value;
    var _queryParameters = {
      'with': 'featuredEServices',
      'parent': 'true',
      'search': 'featured:1',
      'searchFields': 'featured:=',
      'orderBy': 'order',
      'sortedBy': 'asc',
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri =
        getApiBaseUri("categories").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Category>((obj) => Category.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }
  Future<List<Booking>> getBookings(String statusId, int page) async {
    var _queryParameters = {
      'with': 'bookingStatus;payment;payment.paymentStatus;employee',
      'api_token': authService.apiToken,
      //  'search': 'booking_status_id:${statusId}',
      'orderBy': 'created_at',
      'sortedBy': 'desc',
      'limit': '50',
      'offset': ((page - 1) * 50).toString()
    };
    Uri _uri =
        getApiBaseUri("bookings").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    print(response);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Booking>((obj) => Booking.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<BookingStatus>> getBookingStatuses() async {
    var _queryParameters = {
      'only': 'id;status;order',
      'orderBy': 'order',
      'sortedBy': 'asc',
    };
    Uri _uri = getApiBaseUri("booking_statuses")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    print(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<BookingStatus>((obj) => BookingStatus.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Booking> getBooking(String bookingId) async {
    var _queryParameters = {
      'with':
          'bookingStatus;user;employee;payment;payment.paymentMethod;payment.paymentStatus',
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("bookings/${bookingId}")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Booking.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Coupon> validateCoupon(Booking booking) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
      'code': booking.coupon?.code ?? '',
      'e_services_id': booking.eServices.map((e) => e.id)?.join(",") ?? '',
      'salon_id': booking.salon?.id ?? '',
      'categories_id': booking.eServices
              .expand((element) => element.categories + element.subCategories)
              .map((e) => e.id)
              ?.join(",") ??
          '',
    };
    Uri _uri =
        getApiBaseUri("coupons").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Coupon.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }
  Future<Booking> updateBooking(Booking booking) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ updateBooking() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("bookings/${booking.id}")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    Get.log(booking.toJson().toString());
    var response = await _httpClient.putUri(_uri,
        data: booking.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Booking.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }
  Future<Booking> rescheduleBooking(Booking booking) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ updateBooking() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("reschedule-booking");
      //  .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    Get.log({
      "booking_at": booking.bookingAt,
      "booking_id": booking.id,
    }.toString());

    var response = await _httpClient.postUri(_uri,
        data: {
            "booking_at": booking.bookingAt.toString(),
          "booking_id": booking.id.toString(),
        }, options: _optionsNetwork);

    Get.log(response.data.toString());
    if (response.data['success'] == true) {
      return Booking.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Booking> addBooking(Booking booking) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ addBooking() ]");
    }
    this.startProgress('addBooking');
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri =
        getApiBaseUri("bookings").replace(queryParameters: _queryParameters);

    Get.log(_uri.toString());
    var response = await _httpClient.postUri(_uri,
        data: booking.toJson(), options: _optionsNetwork);
    print("Api ${_uri}");
    print("Api ${booking.toJson()}");
    print("Api ${response}");
    if (response.data['success'] == true) {
      return Booking.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Review> addReview(Review review) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ addReview() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("salon_reviews")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    Get.log(review.toJson().toString());
    var response = await _httpClient.postUri(_uri,
        data: review.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Review.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }
  Future<Map> addBlock(id,date,time) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ getPaymentMethods() ]");
    }
    startProgress('getPaymentMethods');
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("block-date-time")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.postUri(_uri, data: {
      "date":date,
      "time":time,
      "employee_id":id,
    },options: _optionsCache);
    print({
      "date":date,
      "time":time,
      "employee_id":id,
    });
    print(response);
    endProgress();
    if (response.data['success'] == true) {
      return response.data;
    } else {
      throw new Exception(response.data['message']);
    }
  }
  Future<List<PaymentMethod>> getPaymentMethods() async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ getPaymentMethods() ]");
    }
    startProgress('getPaymentMethods');
    var _queryParameters = {
      'with': 'media',
      'search': 'enabled:1',
      'searchFields': 'enabled:=',
      'orderBy': 'order',
      'sortBy': 'asc',
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("payment_methods")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    endProgress();
    if (response.data['success'] == true) {
      return response.data['data']
          .map<PaymentMethod>((obj) => PaymentMethod.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Wallet>> getWallets() async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ getWallets() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri =
        getApiBaseUri("wallets").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Wallet>((obj) => Wallet.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Wallet> createWallet(Wallet _wallet) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ createWallet() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri =
        getApiBaseUri("wallets").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    Get.log(_wallet.toJson().toString());
    var response = await _httpClient.postUri(_uri,
        data: _wallet.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Wallet.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Wallet> updateWallet(Wallet _wallet) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ updateWallet() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("wallets/${_wallet.id}")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.putUri(_uri,
        data: _wallet.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Wallet.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> deleteWallet(Wallet _wallet) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ deleteWallet() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("wallets/${_wallet.id}")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.deleteUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'];
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<WalletTransaction>> getWalletTransactions(Wallet wallet) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ getWalletTransactions() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'with': 'user',
      'search': 'wallet_id:${wallet.id}',
      'searchFields': 'wallet_id:=',
    };
    Uri _uri = getApiBaseUri("wallet_transactions")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<WalletTransaction>((obj) => WalletTransaction.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Payment> createPayment(Booking _booking) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ createPayment() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("payments/cash")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.postUri(_uri,
        data: _booking.toJson(), options: _optionsNetwork);
    print("Api ${_uri}");
    print("Api ${_booking.toJson()}");
    print("Api ${response}");
    if (response.data['success'] == true) {
      return Payment.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Payment> createWalletPayment(Booking _booking, Wallet _wallet) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ createPayment() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("payments/wallets/${_wallet.id}")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.postUri(_uri,
        data: _booking.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Payment.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  String getPayPalUrl(Booking _booking) {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ getPayPalUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'booking_id': _booking.id,
    };
    Uri _uri = getBaseUri("payments/paypal/express-checkout")
        .replace(queryParameters: _queryParameters);
    return _uri.toString();
  }
  String getRazorWalletPayUrl(String amount) {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ getRazorPayUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'user_id': authService.user.value.id,
      'wallet_amount':amount
    };
    Uri _uri = getBaseUri("payments/razorpay/wallet")
        .replace(queryParameters: _queryParameters);
    print("ApiCAll${_uri}");
    return _uri.toString();
  }
  String getRazorPayUrl(Booking _booking) {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ getRazorPayUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'booking_id': _booking.id,
    };
    Uri _uri = getBaseUri("payments/razorpay/checkout")
        .replace(queryParameters: _queryParameters);
    print("ApiCAll${_uri}");

    return _uri.toString();
  }

  String getStripeUrl(Booking _booking) {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ getStripeUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'booking_id': _booking.id,
    };
    Uri _uri = getBaseUri("payments/stripe/checkout")
        .replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  String getPayStackUrl(Booking _booking) {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ getPayStackUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'booking_id': _booking.id,
    };
    Uri _uri = getBaseUri("payments/paystack/checkout")
        .replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  String getPayMongoUrl(Booking _booking) {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ getPayMongoUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'booking_id': _booking.id,
    };
    Uri _uri = getBaseUri("payments/paymongo/checkout")
        .replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  String getFlutterWaveUrl(Booking _booking) {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ getFlutterWaveUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'booking_id': _booking.id,
    };
    Uri _uri = getBaseUri("payments/flutterwave/checkout")
        .replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  String getStripeFPXUrl(Booking _booking) {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ getStripeFPXUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'booking_id': _booking.id,
    };
    Uri _uri = getBaseUri("payments/stripe-fpx/checkout")
        .replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  Future<List<Notify.Notification>> getNotifications() async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ getNotifications() ]");
    }
    var _queryParameters = {
      'search': 'notifiable_id:${authService.user.value.id}',
      'searchFields': 'notifiable_id:=',
      'searchJoin': 'and',
      'orderBy': 'created_at',
      'sortedBy': 'desc',
      'limit': '50',
      'only': 'id;type;data;read_at;created_at',
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("notifications")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Notify.Notification>((obj) => Notify.Notification.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Notify.Notification> markAsReadNotification(
      Notify.Notification notification) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ markAsReadNotification() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("notifications/${notification.id}")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.putUri(_uri,
        data: notification.markReadMap(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Notify.Notification.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> sendNotification(
      List<User> users, User from, String type, String text, String id) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ sendNotification() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    var data = {
      'users': users.map((e) => e.id).toList(),
      'from': from.id,
      'type': type,
      'text': text,
      'id': id,
    };
    Uri _uri = getApiBaseUri("notifications")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    Get.log(data.toString());
    var response =
        await _httpClient.postUri(_uri, data: data, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return true;
    } else {
      throw new Exception(response.data['message']);
    }
  }

  // Future<Notification> removeNotification(Notification notification) async {
  //   if (!authService.isAuth) {
  //     throw new Exception("You don't have the permission to access to this area!".tr + "[ removeNotification() ]");
  //   }
  //   var _queryParameters = {
  //     'api_token': authService.apiToken,
  //   };
  //   Uri _uri = getApiBaseUri("notifications/${notification.id}").replace(queryParameters: _queryParameters);
  //   Get.log(_uri.toString());
  //   var response = await _httpClient.deleteUri(_uri, options: _optionsNetwork);
  //   if (response.data['success'] == true) {
  //     return Notification.fromJson(response.data['data']);
  //   } else {
  //     throw new Exception(response.data['message']);
  //   }
  // }

  Future<int> getNotificationsCount() async {
    if (!authService.isAuth) {
      return 0;
    }
    var _queryParameters = {
      'search': 'notifiable_id:${authService.user.value.id}',
      'searchFields': 'notifiable_id:=',
      'searchJoin': 'and',
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("notifications/count")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    print(response);
    if (response.data['success'] == true) {
      return response.data['data'];
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<FaqCategory>> getFaqCategories() async {
    var _queryParameters = {
      'orderBy': 'created_at',
      'sortedBy': 'asc',
    };
    Uri _uri = getApiBaseUri("faq_categories")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<FaqCategory>((obj) => FaqCategory.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Faq>> getFaqs(String categoryId) async {
    var _queryParameters = {
      'search': 'faq_category_id:${categoryId}',
      'searchFields': 'faq_category_id:=',
      'searchJoin': 'and',
      'orderBy': 'updated_at',
      'sortedBy': 'desc',
    };
    Uri _uri = getApiBaseUri("faqs").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Faq>((obj) => Faq.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Setting> getSettings() async {
    Uri _uri = getApiBaseUri("settings");
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Setting.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Map<String, String>> getTranslations(String locale) async {
    startProgress('getTranslations');
    var _queryParameters = {
      'locale': locale,
    };
    Uri _uri = getApiBaseUri("translations")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    endProgress();
    if (response.data['success'] == true) {
      return Map<String, String>.from(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<String>> getSupportedLocales() async {
    Uri _uri = getApiBaseUri("supported_locales");
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return List.from(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<CustomPage>> getCustomPages() async {
    var _queryParameters = {
      'only': 'id;title',
      'search': 'published:1',
      'orderBy': 'created_at',
      'sortedBy': 'asc',
    };
    Uri _uri = getApiBaseUri("custom_pages")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<CustomPage>((obj) => CustomPage.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<CustomPage> getCustomPageById(String id) async {
    Uri _uri = getApiBaseUri("custom_pages/$id");
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return CustomPage.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<String> uploadImage(File file, String field) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ uploadImage() ]");
    }
    String fileName = file.path.split('/').last;
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("uploads/store")
        .replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    dio.FormData formData = dio.FormData.fromMap({
      "file": await dio.MultipartFile.fromFile(file.path, filename: fileName),
      "uuid": Uuid().generateV4(),
      "field": field,
    });
    var response = await _httpClient.postUri(_uri, data: formData);
    print(response.data);
    if (response.data['data'] != false) {
      return response.data['data'];
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> deleteUploaded(String uuid) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ deleteUploaded() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("uploads/clear")
        .replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.postUri(_uri, data: {'uuid': uuid});
    print(response.data);
    if (response.data['data'] != false) {
      return true;
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> deleteAllUploaded(List<String> uuids) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ deleteUploaded() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("uploads/clear")
        .replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.postUri(_uri, data: {'uuid': uuids});
    print(response.data);
    if (response.data['data'] != false) {
      return true;
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> deleteQuery(String id) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ deleteUploaded() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("delete-query")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.postUri(_uri, data: {'id': id});
    print(response.data);
    if (response.data['success'] != false) {
      return true;
    } else {
      throw new Exception(response.data['message']);
    }
  }
}
