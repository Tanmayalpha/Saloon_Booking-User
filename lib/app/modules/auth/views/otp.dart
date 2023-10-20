import 'package:beauty_salons_customer/app/modules/global_widgets/block_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../../../common/helper.dart';
import '../../../../common/ui.dart';
import '../../../models/setting_model.dart';
import '../../../services/settings_service.dart';
import '../../home/controllers/home_controller.dart';
import '../../home/views/home2_view.dart';
import '../../home/views/home_view.dart';
import '../../root/controllers/root_controller.dart';

class Otp extends StatefulWidget {
  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  String code = "";
  final Setting _settings  = Get.find<SettingsService>().setting.value;
  TextEditingController _textController = TextEditingController();
  String _error;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "OTP".tr,
            style: Get.textTheme.headline6
                .merge(TextStyle(color: context.theme.primaryColor)),
          ),
          centerTitle: true,
          backgroundColor: Get.theme.colorScheme.secondary,
          automaticallyImplyLeading: false,
          elevation: 0,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Get.theme.primaryColor),
            // onPressed: () => {Get.find<RootController>().changePageOutRoot(0)},
          ),
        ),
        body: Form(
         // key: controller.loginFormKey,
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
                          ),
                          // Text("Fill the following credentials to login your account", style: Get.textTheme.caption.merge(TextStyle(color: Get.theme.primaryColor))),
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

              Container(
              margin: EdgeInsets.only(top: 80),
                padding: EdgeInsets.symmetric(horizontal: 15),
                child:
                PinFieldAutoFill(
                  codeLength: 4,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  autoFocus: true,
                  decoration: UnderlineDecoration(
                    lineHeight: 1,
                    lineStrokeCap: StrokeCap.square,
                    bgColorBuilder: PinListenColorBuilder(
                        Colors.green.shade100, Colors.grey.shade200),
                    colorBuilder:  FixedColorBuilder(Colors.transparent),
                  ),
                )
              ),
              SizedBox(
                height: 20,
              ),
              BlockButtonWidget(
                onPressed: () {
                  // controller.login();
                 Navigator.push(context, MaterialPageRoute(builder: (context)=>Otp()));
                },
                color: Get.theme.colorScheme.secondary,
                text: Text(
                  "Submit".tr,
                  style: Get.textTheme.headline6
                      .merge(TextStyle(color: Get.theme.primaryColor)),
                ),
              ).paddingSymmetric(vertical: 10, horizontal: 20),
              // Obx(() {
              //   if (controller.loading.isTrue)z
              //     return CircularLoadingWidget(height: 300);
              //   else {
              //     return Column(
              //       crossAxisAlignment: CrossAxisAlignment.stretch,
              //       children: [
              //         // TextFieldWidget(
              //         //   labelText: "Mobile number".tr,
              //         //   hintText: "9090909090".tr,
              //         //   initialValue: controller.currentUser?.value?.email,
              //         //   onSaved: (input) => controller.currentUser.value.email = input,
              //         //   validator: (input) => !input.contains('@') ? "Should be a valid number".tr : null,
              //         //   iconData: Icons.phone,
              //         //   keyboardType: TextInputType.number,
              //         // ),
              //         // PhoneFieldHint(
              //         //   controller: emailController,
              //         //
              //         // ),
              //         Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child: PhoneFieldHint(
              //               decoration: InputDecoration(
              //                   border: OutlineInputBorder(),
              //                   labelText: "Enter a Mobile No"),
              //               controller: mobileController),
              //         ),
              //
              //
              //
              //
              //
              //         // Obx(() {
              //         //   return TextFieldWidget(
              //         //     labelText: "Password".tr,
              //         //     hintText: "••••••••••••".tr,
              //         //     initialValue: controller.currentUser?.value?.password,
              //         //     onSaved: (input) => controller.currentUser.value.password = input,
              //         //     validator: (input) => input.length < 3 ? "Should be more than 3 characters".tr : null,
              //         //     obscureText: controller.hidePassword.value,
              //         //     iconData: Icons.lock_outline,
              //         //     keyboardType: TextInputType.visiblePassword,
              //         //     suffixIcon: IconButton(
              //         //       onPressed: () {
              //         //         controller.hidePassword.value = !controller.hidePassword.value;
              //         //       },
              //         //       color: Theme.of(context).focusColor,
              //         //       icon: Icon(controller.hidePassword.value ? Icons.visibility_outlined : Icons.visibility_off_outlined),
              //         //     ),
              //         //   );
              //         // }),
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.end,
              //           children: [
              //             TextButton(
              //               onPressed: () {
              //                 Get.toNamed(Routes.FORGOT_PASSWORD);
              //               },
              //               child: Text("Forgot Password?".tr),
              //             ),
              //           ],
              //         ).paddingSymmetric(horizontal: 20),
              //         BlockButtonWidget(
              //           onPressed: () {
              //             controller.login();
              //             Navigator.push(context, MaterialPageRoute(builder: (context)=>Otp()));
              //           },
              //           color: Get.theme.colorScheme.secondary,
              //           text: Text(
              //             "Login".tr,
              //             style: Get.textTheme.headline6
              //                 .merge(TextStyle(color: Get.theme.primaryColor)),
              //           ),
              //         ).paddingSymmetric(vertical: 10, horizontal: 20),
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             TextButton(
              //               onPressed: () {
              //
              //                 Get.toNamed(Routes.REGISTER);
              //               },
              //               child: Text("You don't have an account?".tr),
              //             ),
              //           ],
              //         ).paddingSymmetric(vertical: 20),
              //       ],
              //     );
              //   }
              // }),
            ],
          ),
        ),
      ),
    );


    //   Scaffold(
    //   body: Form(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         TextField(
    //           controller: _textController,
    //           autofillHints: [ AutofillHints.oneTimeCode ],
    //           keyboardType: TextInputType.visiblePassword,
    //           maxLength: 6,
    //           style: TextStyle(fontSize: 32),
    //         ),
    //
    //         ElevatedButton(
    //           child: Text("Verify"),
    //           onPressed: () => Navigator.of(context).pop(_textController.value.text),
    //         ),
    //       ],
    //     ),
    //   ),
    //
    // );
  }
}
