/*
 * File name: book_e_service_controller.dart
 * Last modified: 2022.02.23 at 11:42:19
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../common/ui.dart';
import '../../../models/address_model.dart';
import '../../../models/booking_model.dart';
import '../../../models/coupon_model.dart';
import '../../../models/e_service_model.dart';
import '../../../models/user_model.dart';
import '../../../repositories/booking_repository.dart';
import '../../../repositories/salon_repository.dart';
import '../../../repositories/setting_repository.dart';
import '../../../services/auth_service.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/tab_bar_widget.dart';

class RescheduleController extends GetxController {
  final atSalon = true.obs;
  final booking = Booking().obs;
  final addresses = <Address>[].obs;
  final morningTimes = [].obs;
  final afternoonTimes = [].obs;
  final eveningTimes = [].obs;
  final nightTimes = [].obs;
  bool fromOffer = false;
  int minute = 0;
  DateTime selectedDate = DateTime.now();
  BookingRepository _bookingRepository;
  SalonRepository _salonRepository;
  SettingRepository _settingRepository;
  DatePickerController datePickerController = DatePickerController();

  Address get currentAddress => Get.find<SettingsService>().address.value;

  RescheduleController() {
    _bookingRepository = BookingRepository();
    _salonRepository = SalonRepository();
    _settingRepository = SettingRepository();
  }

  @override
  void onInit() async {

    super.onInit();
  }
  void onCall(Booking _booking)async{

    this.booking.value = _booking;
    booking.update((val) {
      val.bookingAt = null;
    });
    print("check service ${booking.value.eServices.length}");
    minute = 0;
    for (int i = 0; i < _booking.eServices.length; i++) {
      EService service = _booking.eServices[i];
      print(service.duration);
      List<String> split = service.duration1.contains(":")
          ? service.duration1.split(":")
          : ["0"];
      print(split.length);
      if (split.length > 0) {
        minute += int.parse(split[0]) * 60;
        if (split.length > 1) {
          minute += int.parse(split[1]);
        }
      }
    }

    print("Minute ${minute}");
    // await getAddresses();
    await getTimes();
  }
  void toggleAtSalon(value) {
    atSalon.value = value;
  }
  Future<void> updateBooking(Booking _booking) async {
    try {
      //_booking.payment = null;
      booking.value = await _bookingRepository.reschedule(_booking);

      Get.back(result: true);

    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  TextStyle getTextTheme(bool selected) {
    if (selected) {
      return Get.textTheme.bodyText2
          .merge(TextStyle(color: Get.theme.primaryColor));
    }
    return Get.textTheme.bodyText2;
  }

  Color getColor(bool selected) {
    if (selected) {
      return Get.theme.colorScheme.secondary;
    }
    return null;
  }

  Future getAddresses() async {
    try {
      if (Get.find<AuthService>().isAuth) {
        addresses.assignAll(await _settingRepository.getAddresses());
        if (!currentAddress.isUnknown()) {
          addresses.remove(currentAddress);
          addresses.insert(0, currentAddress);
        }
        if (Get.isRegistered<TabBarController>(tag: 'addresses')) {
          Get.find<TabBarController>(tag: 'addresses').selectedId.value =
              addresses.elementAt(0).id;
        }
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getTimes({DateTime date}) async {
    print("dare$date");
    try {
      nightTimes.clear();
      morningTimes.clear();
      afternoonTimes.clear();
      eveningTimes.clear();
      List<dynamic> times = await _salonRepository.getAvailabilityHours(
          this.booking.value.salon.id,
          date ?? DateTime.now(),
          this.booking.value.employee?.id,
          minute.toString(),fromOffer?"1":"0");
      times.sort((e1, e2) {
        final _localDateTime1 = DateTime.parse(e1.elementAt(0)).toLocal();

        final hours1 = int.tryParse(DateFormat('HH').format(_localDateTime1));
        final _localDateTime2 = DateTime.parse(e2.elementAt(0)).toLocal();
        final hours2 = int.tryParse(DateFormat('HH').format(_localDateTime2));
        return hours1.compareTo(hours2);
      });
      for (int i = 0; i < times.length; i++) {
        final _localDateTime1 = DateTime.parse(times[i].elementAt(0)).toLocal();
        print(times[i]);
        final hours1 = int.tryParse(DateFormat('HH').format(_localDateTime1));
        if (hours1 > 6 && hours1 < 12) {
          morningTimes.add(times[i]);
        } else if (hours1 > 11 && hours1 < 17) {
          afternoonTimes.add(times[i]);
        } else if (hours1 > 16 && hours1 < 22) {
          eveningTimes.add(times[i]);
        } else {
          nightTimes.add(times[i]);
        }
      }
      /* nightTimes.assignAll(times.sublist(0, 14));
      morningTimes.assignAll(times.sublist(14, 24));
      afternoonTimes.assignAll(times.sublist(24, 36));
      eveningTimes.assignAll(times.sublist(36));*/
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  void validateCoupon() async {
    try {
      FocusManager.instance.primaryFocus?.unfocus();
      Coupon _coupon = await _bookingRepository.coupon(booking.value);
      booking.update((val) {
        val.coupon = _coupon;
      });
      if (_coupon.hasData) {
        Get.showSnackbar(Ui.SuccessSnackBar(
            message: "Coupon code is applied".tr,
            snackPosition: SnackPosition.TOP));
      } else {
        Get.showSnackbar(Ui.ErrorSnackBar(
            message: "Invalid Coupon Code".tr,
            snackPosition: SnackPosition.TOP));
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  void selectEmployee(User employee) async {
    booking.update((val) {
      if (val.employee == null) {
        val.employee = employee;
      } else {
        val.employee = null;
        val.employee = employee;
      }
    });

    await getTimes(date: selectedDate);
    /*if (booking.value.bookingAt != null) {

    }*/
  }

  bool isCheckedEmployee(User user) {
    return (booking.value.employee?.id ?? '0') == user.id;
  }

  TextStyle getTitleTheme(User user) {
    if (isCheckedEmployee(user)) {
      return Get.textTheme.bodyText2
          .merge(TextStyle(color: Get.theme.colorScheme.secondary));
    }
    return Get.textTheme.bodyText2;
  }

  TextStyle getSubTitleTheme(User user) {
    if (isCheckedEmployee(user)) {
      return Get.textTheme.caption
          .merge(TextStyle(color: Get.theme.colorScheme.secondary));
    }
    return Get.textTheme.caption;
  }
}
