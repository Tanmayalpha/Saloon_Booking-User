import 'dart:async';

import 'package:beauty_salons_customer/app/providers/laravel_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../../../common/ui.dart';
import '../../../models/user_model.dart';
import '../../../repositories/user_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../../services/firebase_messaging_service.dart';
import '../../root/controllers/root_controller.dart';

class AuthController extends GetxController {
  final Rx<User> currentUser = Get.find<AuthService>().user;
  final deviceNumber = <SimCard>[].obs;
  GlobalKey<FormState> loginFormKey;
  GlobalKey<FormState> registerFormKey;
  GlobalKey<FormState> forgotPasswordFormKey;
  TextEditingController mobileCon = new TextEditingController();
  final hidePassword = true.obs;
  final loading = false.obs;
  final smsSent = ''.obs;
  final mobileNumber = ''.obs;
  UserRepository _userRepository;
  final otp = ''.obs;
  AuthController() {
    _userRepository = UserRepository();
  }
  @override
  void onInit() async {
    super.onInit();
   /* MobileNumber.listenPhonePermission((isPermissionGranted) {
      if (isPermissionGranted) {
        initMobileNumberState();
      } else {}
    });*/

    mobileCon..addListener(() {
      if(mobileCon.text.contains("+91")){
        mobileCon.text=mobileCon.text.replaceAll("+91", "");
      }
        currentUser.value.mobile = mobileCon.text.replaceAll("+91", "");
    });
 //   initMobileNumberState();
  }
  Future<void> initMobileNumberState() async {
    if (!await MobileNumber.hasPhonePermission) {
      await MobileNumber.requestPhonePermission;
      return;
    }
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      mobileNumber.value = (await MobileNumber.mobileNumber);
      deviceNumber.value = (await MobileNumber.getSimCards);
      print(mobileNumber.value);
      print(deviceNumber.value);
    } on PlatformException catch (e) {
      debugPrint("Failed to get mobile number because of '${e.message}'");
    }
  }
/// old login api
  void login() async {
    Get.focusScope.unfocus();
    if (loginFormKey.currentState.validate()) {
      if(currentUser.value.mobile.length!=10){
        Get.showSnackbar(Ui.ErrorSnackBar(message: "Enter Valid Mobile Number"));
        return;
      }
      loginFormKey.currentState.save();
      loading.value = true;

      try {
       String deviceToken = await Get.find<FireBaseMessagingService>().setDeviceToken();
         otp.value = await _userRepository.loginOtp(currentUser.value.mobile.replaceAll("+91", ""),deviceToken);
         if(currentUser.value.email!=null){
           await _userRepository.signInWithEmailAndPassword(currentUser.value.email, currentUser.value.apiToken);
         }
        loading.value = false;

        await Get.toNamed(Routes.PHONE_VERIFICATION);
       // await Get.find<RootController>().changePage(0);
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {
        loading.value = false;
      }
    }
  }

  /*void login(String mobile) async {
    print("Check Mobile${mobile.toString()}");
    LaravelApiClient _laravelApiClient;

    print("working done");
    Get.focusScope.unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      loading.value = true;
      try {
        print("Check Mobile No.....${mobile.toString()}");
        _laravelApiClient = Get.find<LaravelApiClient>();
        // _laravelApiClient.sendOtp(mobile.toString());
        _laravelApiClient.sendOtp(currentUser.value.mobile);
        // loginOtp(mobile.toString());
        // print("working here ${login(mobile.toString())}");
        // await Get.find<FireBaseMessagingService>().setDeviceToken();
        // currentUser.value = await _userRepository.login(mobile);
        // await _userRepository.signInWithEmailAndPassword(currentUser.value.mobile, currentUser.value.apiToken);
        await Get.find<RootController>().changePage(0);
      } catch (e) {
        // print("working done@@@@@@@");
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {
        // print("working done######");
        loading.value = false;
        Get.showSnackbar(Ui.SuccessSnackBar(message: RxStatus.success().toString()));
      }
    }
  }*/

  void register() async {
    Get.focusScope.unfocus();
    if (registerFormKey.currentState.validate()) {
      registerFormKey.currentState.save();
      loading.value = true;
      try {
        await _userRepository.sendCodeToPhone();
        loading.value = false;
        await Get.toNamed(Routes.PHONE_VERIFICATION);
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {
        loading.value = false;
      }
    }
  }
  /// verify otp api
  // Future<void> verifyPhone() async {
  //   try {
  //     loading.value = true;
  //     await _userRepository.verifyPhone(smsSent.value);
  //     await Get.find<FireBaseMessagingService>().setDeviceToken();
  //     currentUser.value = await _userRepository.register(currentUser.value);
  //     await _userRepository.signUpWithEmailAndPassword(currentUser.value.email, currentUser.value.apiToken);
  //     await Get.find<RootController>().changePage(0);
  //   } catch (e) {
  //     Get.back();
  //     Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
  //   } finally {
  //     loading.value = false;
  //   }
  // }

  Future<void> verifyPhone() async {
    try {
      loading.value = true;
      await _userRepository.verifyPhone(smsSent.value);
      await Get.find<FireBaseMessagingService>().setDeviceToken();
      currentUser.value = await _userRepository.register(currentUser.value);
      await _userRepository.signUpWithEmailAndPassword(currentUser.value.email, currentUser.value.apiToken);
      Get.back();Get.back();
    //  await Get.find<RootController>().changePage(0);
    } catch (e) {
      Get.back();
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      loading.value = false;
    }
  }
  Future<void> verifyLoginPhone() async {
    try {
      loading.value = true;
     // await _userRepository.verifyPhone(smsSent.value);
      await Get.find<FireBaseMessagingService>().setDeviceToken();
      currentUser.value = await _userRepository.verifyOtp({
        "mobile":"+91"+currentUser.value.mobile,
        "otp":smsSent.value,
      });
      //
      print(currentUser.value.email);
      print(currentUser.value.apiToken);
     // await _userRepository.signInWithEmailAndPassword(currentUser.value.email, currentUser.value.apiToken);
      Get.back();Get.back();
      //await Get.find<RootController>().changePage(0);
    } catch (e) {
      Get.back();
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      loading.value = false;
    }
  }
  Future<void> resendOTPCode() async {
    await _userRepository.sendCodeToPhone();
  }

  void sendResetLink() async {
    Get.focusScope.unfocus();
    if (forgotPasswordFormKey.currentState.validate()) {
      forgotPasswordFormKey.currentState.save();
      loading.value = true;
      try {
        await _userRepository.sendResetLinkEmail(currentUser.value);
        loading.value = false;
        Get.showSnackbar(Ui.SuccessSnackBar(message: "The Password reset link has been sent to your email: ".tr + currentUser.value.email));
        Timer(Duration(seconds: 5), () {
          Get.offAndToNamed(Routes.LOGIN);
        });
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {
        loading.value = false;
      }
    }
  }
}
