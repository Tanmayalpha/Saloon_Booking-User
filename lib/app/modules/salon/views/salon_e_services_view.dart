/*
 * File name: salon_e_services_view.dart
 * Last modified: 2022.02.07 at 14:16:22
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:beauty_salons_customer/app/modules/salon/controllers/salon_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/salon_e_services_controller.dart';
import '../widgets/services_list_widget.dart';

class SalonEServicesView extends GetView<SalonEServicesController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Get.find<SalonController>().salon.value.salonType=="3"?Obx(() => Container(
          height: 50,
          margin: EdgeInsets.symmetric(horizontal:10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: controller.filterType.map((e){
              return InkWell(
                onTap: (){
                  controller.selectedFilter.value = e;
                },
                child: Container(
                  margin: EdgeInsets.all(5.0),
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  decoration: BoxDecoration(
                    color: controller.selectedFilter.value == e ? Get.theme.colorScheme.primary
                        : Get.theme.primaryColor,
                      borderRadius:
                      BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                            color: Get.theme.focusColor
                                .withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 5)),
                      ],
                      border: Border.all(
                          color: Get.theme.focusColor
                              .withOpacity(0.05))
                  ),
                  child: Text(
                    e,
                    style: TextStyle(
                      color: controller.selectedFilter.value != e ? Get.theme.colorScheme.primary
                          : Get.theme.primaryColor,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        )):SizedBox(),
        ServicesListWidget(),
      ],
    );
  }
}
