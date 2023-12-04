import 'package:beauty_salons_customer/app/modules/home/controllers/home_controller.dart';
import 'package:beauty_salons_customer/app/services/auth_service.dart';
import 'package:beauty_salons_customer/common/location_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../../services/settings_service.dart';

class AddressWidget extends StatelessWidget {
  Color color = Get.textTheme.bodyText1.color;

  AddressWidget({this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      child: Row(
        children: [
          Icon(Icons.place_outlined),
          SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: () {
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
                    if(Get.isRegistered<HomeController>()){
                      Get.find<HomeController>().refreshHome();
                    }
                    Get.toNamed(Routes.SETTINGS_ADDRESS_PICKER);
                  }
                });
                getLocation.getLoc();

               // Get.toNamed(Routes.SETTINGS_ADDRESSES);
              },
              child: Obx(() {
                if (Get.find<SettingsService>().address.value?.isUnknown() ?? true) {
                  return Text("Please choose your address".tr, style: Get.textTheme.bodyText1.merge(TextStyle(color: color,fontWeight: FontWeight.w500)));
                }
                return Text(Get.find<SettingsService>().address.value.address ??"", style: Get.textTheme.bodyText1.merge(TextStyle(color: color,fontWeight: FontWeight.w500)));
              }),
            ),
          ),
          SizedBox(width: 10),
          IconButton(
            icon: Icon(Icons.gps_fixed),
            onPressed: () async {
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
                  if(Get.isRegistered<HomeController>()){
                    Get.find<HomeController>().refreshHome();
                  }
                  Get.toNamed(Routes.SETTINGS_ADDRESS_PICKER);
                }
              });
              getLocation.getLoc();

            },
          )
        ],
      ),
    );
  }
}
