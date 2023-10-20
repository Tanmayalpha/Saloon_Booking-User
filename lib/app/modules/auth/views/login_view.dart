import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../../../common/helper.dart';
import '../../../../common/ui.dart';
import '../../../models/setting_model.dart';
import '../../../routes/app_routes.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../../global_widgets/phone_field_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../../root/controllers/root_controller.dart';
import '../controllers/auth_controller.dart';
import 'login_otp_view.dart';
import 'login_otp_view.dart';
import 'login_otp_view.dart';
import 'otp.dart';
// import 'login_otp_view.dart';

class LoginView extends GetView<AuthController> {
  final Setting _settings = Get.find<SettingsService>().setting.value;


  // loginwithotp() async {
  //   var request = http.MultipartRequest('POST', Uri.parse('login-with-otp'));
  //   request.fields.addAll({
  //     'mobile': mobileController;
  //   });
  //
  //
  //   http.StreamedResponse response = await request.send();
  //
  //   if (response.statusCode == 200) {
  //     print(await response.stream.bytesToString());
  //   }
  //   else {
  //     print(response.reasonPhrase);
  //   }
  //
  // }

  @override
  Widget build(BuildContext context) {
    controller.loginFormKey = new GlobalKey<FormState>();
    return WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Login or Signup".tr,
            style: Get.textTheme.headline6
                .merge(TextStyle(color: context.theme.primaryColor)),
          ),
          centerTitle: true,
          backgroundColor: Get.theme.colorScheme.secondary,
          automaticallyImplyLeading: false,
          elevation: 0,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Get.theme.primaryColor),
            onPressed: () => {Get.find<RootController>().changePageOutRoot(0)},
          ),
        ),
        body: Form(
          key: controller.loginFormKey,
          child: ListView(
            primary: true,
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  Container(
                    height: 180,
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: Get.theme.colorScheme.secondary,
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                            color: Get.theme.focusColor.withOpacity(0.2),
                            blurRadius: 10,
                            offset: Offset(0, 5)),
                      ],
                    ),
                    margin: EdgeInsets.only(bottom: 50),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            _settings.appName,
                            style: Get.textTheme.headline6.merge(TextStyle(
                                color: Get.theme.primaryColor, fontSize: 24)),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Welcome to the best multi salons system!".tr,
                            style: Get.textTheme.caption.merge(
                                TextStyle(color: Get.theme.primaryColor)),
                            textAlign: TextAlign.center,
                          ),  // Text("Fill the following credentials to login your account", style: Get.textTheme.caption.merge(TextStyle(color: Get.theme.primaryColor))),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: Ui.getBoxDecoration(
                      radius: 14,
                      border:
                          Border.all(width: 5, color: Get.theme.primaryColor),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Image.asset(
                        'assets/icon/icon.png',
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ),
                ],
              ),
              Obx(() {
                if (controller.loading.isTrue)
                  return CircularLoadingWidget(height: 300);
                else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                     // PhoneFieldHint(),
                      DeviceFieldWidget(
                        errorText: "",
                        controller: controller.mobileCon,
                        // labelText: "Email".tr,
                        hintText: "Mobile Number".tr,
                      //  initialValue: controller.currentUser?.value?.mobile,
                        // initialValue: controller.currentUser?.value?.phoneNumber,
                       // onSaved: (input) => controller.currentUser.value.mobile = input,
                      //  validator: (input) => input.length < 10 ? "Enter a valid mobile number".tr : null,
                        iconData: Icons.phone,
                        keyboardType: TextInputType.number,
                        // maximumLength: 10,
                      ),
                      ///sas
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: PhoneFieldHint(
                      //       decoration: InputDecoration(
                      //           border: OutlineInputBorder(),
                      //           labelText: "Enter a Mobile No"),
                      //       controller: mobileController),
                      // ),
                      //
                      // Obx(() {
                      //   return TextFieldWidget(
                      //     labelText: "Password".tr,
                      //     hintText: "••••••••••••".tr,
                      //     initialValue: controller.currentUser?.value?.password,
                      //     onSaved: (input) => controller.currentUser.value.password = input,
                      //     validator: (input) => input.length < 3 ? "Should be more than 3 characters".tr : null,
                      //     obscureText: controller.hidePassword.value,
                      //     iconData: Icons.lock_outline,
                      //     keyboardType: TextInputType.visiblePassword,
                      //     suffixIcon: IconButton(
                      //       onPressed: () {
                      //         controller.hidePassword.value = !controller.hidePassword.value;
                      //       },
                      //       color: Theme.of(context).focusColor,
                      //       icon: Icon(controller.hidePassword.value ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                      //     ),
                      //   );
                      // }),
                   /// forgot password
                      /*Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Get.toNamed(Routes.FORGOT_PASSWORD);
                            },
                            child: Text("Forgot Password?".tr),
                          ),
                        ],
                      ).paddingSymmetric(horizontal: 20),*/
                      SizedBox(height: 20,),
                      BlockButtonWidget(
                        onPressed: () {
                          controller.login();
                          //print("First Mobile No..${mobileController.toString()}");
                         // controller.login(mobileController.text.toString());
                          /*Future.delayed(Duration(
                            seconds: 3
                          ),
                              (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginOtpView()));
                              });
                          // Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginOtpView()));*/
                           //Get.toNamed(Routes.LOGIN_OTP_VIEW);
                        },
                        color: Get.theme.colorScheme.secondary,
                        text: Text(
                          "Login".tr,
                          style: Get.textTheme.headline6
                              .merge(TextStyle(color: Get.theme.primaryColor)),
                        ),
                      ).paddingSymmetric(vertical: 10, horizontal: 20),
                     /* Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Get.toNamed(Routes.REGISTER);
                            },
                            child: Text("You don't have an account?".tr),
                          ),
                        ],
                      ).paddingSymmetric(vertical: 20),*/
                    ],
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
