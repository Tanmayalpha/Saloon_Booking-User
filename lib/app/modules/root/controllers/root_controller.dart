/*
 * Copyright (c) 2020 .
 */

import 'dart:async';

import 'package:beauty_salons_customer/app/services/settings_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/location_details.dart';
import '../../../models/custom_page_model.dart';
import '../../../repositories/custom_page_repository.dart';
import '../../../repositories/notification_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../account/views/account_view.dart';
import '../../bookings/controllers/bookings_controller.dart';
import '../../bookings/views/bookings_view.dart';
import '../../home/controllers/home_controller.dart';
import '../../home/views/home2_view.dart';
import '../../maps/controllers/maps_controller.dart';
import '../../maps/views/maps_view.dart';
import '../../messages/controllers/buzz_controller.dart';
import '../../messages/controllers/messages_controller.dart';
import '../../messages/views/messages_view.dart';

class RootController extends GetxController {
  final currentIndex = 0.obs;
  final notificationsCount = 0.obs;
  final customPages = <CustomPage>[].obs;
  NotificationRepository _notificationRepository;
  CustomPageRepository _customPageRepository;

  RootController() {
    _notificationRepository = new NotificationRepository();
    _customPageRepository = new CustomPageRepository();
  }

  @override
  void onInit() async {
    super.onInit();
    await getCustomPages();

    getLocation();
  }

  getLocation() {
    GetLocation getLocation = new GetLocation((value) {
      if (value is bool) {
        showDialog(
            context: Get.context,
            barrierDismissible: false,
            builder: (ctx) {
              return AlertDialog(
                title: Text("Device Location Not Enabled"),
                content: Text(
                    "For a better user experience, please enable location permissions for this app"),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text("OK"))
                ],
              );
            });
      } else {
        Get.find<SettingsService>().address.update((val) {
          val.description = value.first.locality;
          val.address = value.first.addressLine;
          val.latitude = value.first.coordinates.latitude;
          val.longitude = value.first.coordinates.longitude;
          val.userId = Get.find<AuthService>().user.value.id;
        });
        Get.find<HomeController>().refreshHome();
      }
    });
    getLocation.getLoc();
  }

  List<Widget> pages = [
    Home2View(),
    // MapsView(),
    BookingsView(),
    NewBuzzView(),
    AccountView(),
  ];

  Widget get currentPage => pages[currentIndex.value];
  /**
   * change page in route
   * */
  Future<void> changePageInRoot(int _index) async {
    if (!Get.find<AuthService>().isAuth && _index > 0) {
      await Get.toNamed(Routes.LOGIN);
    } else {
      currentIndex.value = _index;
      await refreshPage(_index);
      /* if(_index!=3){

      }else{

      }*/
    }
  }

  Future<void> changePageOutRoot(int _index) async {
    if (!Get.find<AuthService>().isAuth && _index > 0) {
      await Get.toNamed(Routes.LOGIN);
    }
    currentIndex.value = _index;
    await refreshPage(_index);
    await Get.offNamedUntil(Routes.ROOT, (Route route) {
      if (route.settings.name == Routes.ROOT) {
        return true;
      }
      return false;
    }, arguments: _index);
  }

  Future<void> changePage(int _index) async {
    if (Get.currentRoute == Routes.ROOT) {
      await changePageInRoot(_index);
    } else {
      await changePageOutRoot(_index);
    }
  }

  Future<void> refreshPage(int _index) async {
    switch (_index) {
      case 0:
        {
          await Get.find<HomeController>().refreshHome();
          break;
        }
      case 1:
        {
          await Get.find<BookingsController>().refreshBookings();
          break;
        }
      case 2:
        {
          await Get.find<BuzzController>().refreshBuzz();
          break;
        }
      case 3:
        {
          await Get.find<BuzzController>().refreshBuzz();
          break;
        }
    }
  }

  void getNotificationsCount() async {
    var val = await _notificationRepository.getCount();
    print("countcheck" + val.toString());
    notificationsCount.value = val;
  }

  Future<void> getCustomPages() async {
    customPages.assignAll(await _customPageRepository.all());
  }
}
