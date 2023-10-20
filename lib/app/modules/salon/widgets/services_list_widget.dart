/*
 * File name: services_list_widget.dart
 * Last modified: 2022.02.06 at 16:15:28
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../global_widgets/circular_loading_widget.dart';
import '../controllers/salon_e_services_controller.dart';
import 'services_list_item_widget.dart';

class ServicesListWidget extends GetView<SalonEServicesController> {
  ServicesListWidget({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.eCatServices.isEmpty) {
        return CircularLoadingWidget(height: 300);
      } else {
        int firstIndex = -1;
        return ListView.builder(
          padding: EdgeInsets.only(bottom: 10, top: 10),
          primary: false,
          shrinkWrap: true,
          itemCount: controller.eCatServices.length + 1,
          itemBuilder: ((_, index) {
            if (index == controller.eCatServices.length) {
              return Obx(() {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Center(
                    child: new Opacity(
                      opacity: controller.isLoading.value ? 1 : 0,
                      child: new CircularProgressIndicator(),
                    ),
                  ),
                );
              });
            } else {
              var _service = controller.eCatServices.elementAt(index);

              if (_service.eServices.length > 0){
                if(firstIndex==-1)
                  firstIndex = index;
                print(firstIndex);
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.grey.withOpacity(0.1))),
                  margin: const EdgeInsets.all(8.0),
                  child: ExpansionTile(
                    title: Text(
                      _service.name,
                      style: Get.theme.textTheme.headline3
                          .copyWith(fontSize: 12.0),
                    ),
                    initiallyExpanded: index==firstIndex?true:false,
                    children: [
                      for (int i = 0; i < _service.eServices.length; i++)
                        Obx(() => controller.selectedFilter=="All"||(controller.selectedFilter=="Male"&&_service.eServices[i].genderText=="M")||(controller.selectedFilter=="Female"&&_service.eServices[i].genderText=="F")?
                        ServicesListItemWidget(
                          onTap: () {
                            int index = controller.eCatServices.indexWhere(
                                    (element) => element.id == _service.id);
                            int indexE = controller.eCatServices.value
                                .elementAt(index)
                                .eServices
                                .indexWhere((element) =>
                            element.id == _service.eServices[i].id);
                            if (index != -1 && indexE != -1) {
                              controller.eCatServices
                                  .elementAt(index)
                                  .eServices
                                  .elementAt(indexE)
                                  .showDesc =
                              !controller.eCatServices
                                  .elementAt(index)
                                  .eServices
                                  .elementAt(indexE)
                                  .showDesc;
                              controller.eCatServices.refresh();
                            }
                          },
                          service: _service.eServices[i],
                        ):SizedBox())



                    ],
                  ),
                );
              }
              else
                return SizedBox();
              // return ServicesListItemWidget(service: _service);
            }
          }),
        );
      }
    });
  }
}
