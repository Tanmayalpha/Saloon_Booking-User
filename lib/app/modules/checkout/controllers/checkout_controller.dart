/*
 * File name: checkout_controller.dart
 * Last modified: 2022.02.14 at 12:11:45
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../common/ui.dart';
import '../../../models/booking_model.dart';
import '../../../models/payment_method_model.dart';
import '../../../models/payment_model.dart';
import '../../../models/wallet_model.dart';
import '../../../repositories/booking_repository.dart';
import '../../../repositories/payment_repository.dart';
import '../../../routes/app_routes.dart';
import '../../bookings/controllers/bookings_controller.dart';
import '../../global_widgets/tab_bar_widget.dart';

class CheckoutController extends GetxController {
  PaymentRepository _paymentRepository;
  BookingRepository _bookingRepository;
  Timer _timer;
  int start = 300;
  final paymentsList = <PaymentMethod>[].obs;
  final walletList = <Wallet>[];
  final isLoading = true.obs;
  final booking = new Booking().obs;
  final leftAmount = 0.0.obs;
  final minuteString = '00:00'.obs;

  Rx<PaymentMethod> selectedPaymentMethod = new PaymentMethod().obs;

  CheckoutController() {
    _paymentRepository = new PaymentRepository();
    _bookingRepository = new BookingRepository();
  }

  @override
  void onInit() async {
    booking.value = Get.arguments as Booking;
    startTimer();
    await loadPaymentMethodsList();
    await loadWalletList();
    addBlock(booking.value);
    selectedPaymentMethod.value = this.paymentsList.firstWhere((element) => element.isDefault);
    super.onInit();
  }
  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (start == 0) {
          Get.back();
          timer.cancel();
        } else {
          start--;
       //   int minutes = (start / 60).truncate();
          minuteString.value = durationToString(start);
        }
      },
    );
  }
  String durationToString(int minutes) {
    var d = Duration(seconds:minutes);
    List<String> parts = d.toString().split(':');
    return '${parts[1].padLeft(2, '0')}:${double.parse(parts[2]).toStringAsFixed(0).padLeft(2, '0')}';
  }
  Future loadPaymentMethodsList() async {
    try {
      paymentsList.assignAll(await _paymentRepository.getMethods());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if(_timer!=null){
      _timer.cancel();
    }
    super.dispose();
  }

  Future loadWalletList() async {
    try {
      var _walletIndex = paymentsList.indexWhere((element) => element.route.toLowerCase() == Routes.WALLET);
      if (_walletIndex > -1) {
        // wallet payment method enabled
        // remove existing wallet method
        var _walletPaymentMethod = paymentsList.removeAt(_walletIndex);
        walletList.assignAll(await _paymentRepository.getWallets());
        // and replace it with new payment method object
        _insertWalletsPaymentMethod(_walletIndex, _walletPaymentMethod);
        paymentsList.refresh();
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      isLoading.value = false;
    }
  }

  void selectPaymentMethod(PaymentMethod paymentMethod) {
    selectedPaymentMethod.value = paymentMethod;
  }

  Future<void> createBooking(Booking _booking) async {
    try {
      _booking.payment = null;
      booking.value = await _bookingRepository.add(_booking);
      Get.find<BookingsController>().currentStatus.value = Get.find<BookingsController>().getStatusByOrder(1).id;
      if (Get.isRegistered<TabBarController>(tag: 'bookings')) {
        Get.find<TabBarController>(tag: 'bookings').selectedId.value = Get.find<BookingsController>().getStatusByOrder(1).id;
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
  Future<void> addBlock(Booking _booking) async {
    try {
      Map data = await _paymentRepository.addBlock(_booking.employee.id, DateFormat("yyyy-MM-dd").format(_booking.bookingAt), DateFormat("HH:mm").format(_booking.bookingAt));

    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
  Future<void> payBooking(Booking _booking) async {
    try {
      int index  = paymentsList.indexWhere((element) => element.id == "2");
      PaymentMethod method;
      if(leftAmount.value>0){
        if(index!=-1){
          method = paymentsList[index];
          Wallet tempWallet = selectedPaymentMethod.value.wallet;
          selectedPaymentMethod.value.wallet = Wallet(
            id:tempWallet.id,
            name: tempWallet.name,
            balance: tempWallet.balance+leftAmount.value,
          );
        }else{
          method = paymentsList[0];
        }
         _booking.payment = new Payment(
             paymentMethod: selectedPaymentMethod.value);
        if (method.route != null) {
          Get.toNamed(method.route.toLowerCase(),
              arguments: {'booking': Booking(id: booking.value.id, payment: _booking.payment), 'wallet': selectedPaymentMethod.value.wallet, 'from':true,'amount':(double.parse(leftAmount.value.toStringAsFixed(2))*100).toStringAsFixed(0)});
        }
      }else{
       // selectedPaymentMethod.value = paymentsList[0];
        _booking.payment = new Payment(
            paymentMethod: selectedPaymentMethod.value);
        if (selectedPaymentMethod.value.route != null) {
          Get.toNamed(selectedPaymentMethod.value.route.toLowerCase(),
              arguments: {'booking': Booking(id: booking.value.id, payment: _booking.payment), 'wallet': selectedPaymentMethod.value.wallet, 'from':false});
        }
      }


    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  TextStyle getTitleTheme(PaymentMethod paymentMethod) {
    if (paymentMethod == selectedPaymentMethod.value) {
      return Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.primaryColor));
    } else if (paymentMethod.wallet != null && paymentMethod.wallet.balance ==0) {
   // < booking.value.getTotal()
      return Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.focusColor));
    }
    return Get.textTheme.bodyText2;
  }

  TextStyle getSubTitleTheme(PaymentMethod paymentMethod) {
    if (paymentMethod == selectedPaymentMethod.value) {
      return Get.textTheme.caption.merge(TextStyle(color: Get.theme.primaryColor));
    }
    return Get.textTheme.caption;
  }

  Color getColor(PaymentMethod paymentMethod) {
    if (paymentMethod == selectedPaymentMethod.value) {
      return Get.theme.colorScheme.secondary;
    }
    return null;
  }

  void _insertWalletsPaymentMethod(int _walletIndex, PaymentMethod _walletPaymentMethod) {
    walletList.forEach((_walletElement) {
      paymentsList.insert(
          _walletIndex,
          new PaymentMethod(
            isDefault: _walletPaymentMethod.isDefault,
            id: _walletPaymentMethod.id,
            name: _walletElement.getName(),
            description: _walletElement.balance.toString(),
            logo: _walletPaymentMethod.logo,
            route: _walletPaymentMethod.route,
            wallet: _walletElement,
          ));
    });
  }
}
