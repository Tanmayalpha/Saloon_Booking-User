/*
 * File name: razorpay_controller.dart
 * Last modified: 2022.02.09 at 17:17:00
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:beauty_salons_customer/app/models/wallet_model.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../common/helper.dart';
import '../../../models/booking_model.dart';
import '../../../repositories/payment_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/global_service.dart';
import '../../bookings/controllers/bookings_controller.dart';
import '../../global_widgets/tab_bar_widget.dart';

class RazorPayController extends GetxController {
  WebViewController webView;
  PaymentRepository _paymentRepository;
  final url = "".obs;
  final progress = 0.0.obs;
  final booking = new Booking().obs;
  bool from = false;
  String amount = "0";
  final wallet = new Wallet().obs;
  RazorPayController() {
    _paymentRepository = new PaymentRepository();
  }

  @override
  void onInit() {
    booking.value = Get.arguments['booking'] as Booking;
    wallet.value = Get.arguments['wallet'] as Wallet;
    from = Get.arguments['from'] ?? false;
    amount = Get.arguments['amount'] ?? "0";
    getUrl();
    super.onInit();
  }

  void getUrl() {
    if(from){
      url.value = _paymentRepository.getRazorPayWalletUrl(amount);
    }else{
      url.value = _paymentRepository.getRazorPayUrl(booking.value);
    }

    print("doneUrlStart${url.value}");
  }

  void showConfirmationIfSuccess() {
    final _doneUrl = "${Helper.toUrl(Get.find<GlobalService>().baseUrl)}payments/razorpay";
    print("doneUrlStart1${url.value}");
    print("doneUrlEnd$_doneUrl");
    if (url == _doneUrl) {
      if(from){
        Get.toNamed(Routes.WALLET,
            arguments: {'booking': booking.value, 'wallet': wallet.value, 'from':true});
      }else{
        Get.find<BookingsController>().currentStatus.value = Get.find<BookingsController>().getStatusByOrder(1).id;
        if (Get.isRegistered<TabBarController>(tag: 'bookings')) {
          Get.find<TabBarController>(tag: 'bookings').selectedId.value = Get.find<BookingsController>().getStatusByOrder(1).id;
        }
        Get.toNamed(Routes.CONFIRMATION, arguments: {
          'title': "Payment Successful".tr,
          'long_message': "Your Payment is Successful".tr,
        });
      }

    }
  }
}
