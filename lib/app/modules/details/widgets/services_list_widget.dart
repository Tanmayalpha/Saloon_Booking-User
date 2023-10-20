import 'package:beauty_salons_customer/app/modules/details/controllers/detail_controller.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../global_widgets/circular_loading_widget.dart';

import 'services_list_item_widget.dart';

class SalonHorizontalListWidget extends GetView<DetailController> {
  SalonHorizontalListWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.category.isEmpty) {
        return CircularLoadingWidget(height: 300);
      } else {
        return Container(
          height: 60,
          margin: EdgeInsets.only(top: 10),
          child: ListView.builder(
            padding: EdgeInsets.only(bottom: 10, top: 10),
            primary: false,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: controller.category.length,
            itemBuilder: ((_, index) {
              var cat = controller.category.elementAt(index);
              return Obx(() => Padding(
                padding: const EdgeInsetsDirectional.only(start: 20),
                child: RawChip(
                  elevation: 0,
                  label: Text(cat.title),
                  labelStyle: controller.isSelected(cat)
                      ? Get.textTheme.bodyText2
                      .merge(TextStyle(color: Get.theme.primaryColor))
                      : Get.textTheme.bodyText2,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                  backgroundColor:
                  Theme.of(context).focusColor.withOpacity(0.1),
                  selectedColor: Get.theme.textTheme.bodyMedium.color,
                  selected: controller.isSelected(cat),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  showCheckmark: true,
                  checkmarkColor: Get.theme.primaryColor,
                  onSelected: (bool value) {
                    controller.toggleSelected(cat);
                    // controller.loadEServicesOfCategory(controller.category.value.id, filter: controller.selected.value);
                  },
                ),
              ));

            }),
          ),
        );
      }
    });
  }
}

class PackageCatListWidget extends GetView<DetailController> {
  PackageCatListWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.eCatPackage.isEmpty) {
        return SizedBox();
        //return CircularLoadingWidget(height: 300);
      } else {
        return Container(
          height: 60,
          margin: EdgeInsets.only(top: 10, left: 5),
          child: Row(
            children: [
              Container(
                width: 120,
                height: 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).iconTheme.color,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                alignment: Alignment.center,
                child: DropdownButton2(
                    isDense: true,
                    buttonStyleData: ButtonStyleData(
                      height: 40,
                      padding: EdgeInsets.all(1),
                    ),
                    dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Theme.of(context).iconTheme.color,
                        ),
                        elevation: 8,
                        padding: EdgeInsets.all(1),
                        scrollbarTheme: ScrollbarThemeData(
                          radius: const Radius.circular(40),
                          thickness: MaterialStateProperty.all(6),
                          thumbVisibility: MaterialStateProperty.all(true),
                        )),
                    value: controller.packageId.value,
                    iconStyleData: IconStyleData(
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                    ),
                    underline: SizedBox(),
                    items: controller.eCatPackage.map((element) {
                      return DropdownMenuItem<String>(
                        value: element.id.toString(),
                        child: Text(
                          element.name,
                          style: TextStyle(
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      controller.packageId.value = value;
                      controller.packageIndex.value = controller.eCatPackage
                          .indexWhere((element) => element.id == value);
                      //  controller.id.value = controller.eCatPackage[controller.packageIndex.value].category[0].id;
                      controller.toggleCatSelected(controller
                          .eCatPackage[controller.packageIndex.value]
                          .category[0]);
                    }),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.only(bottom: 10, top: 10),
                  primary: false,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: controller
                      .eCatPackage[controller.packageIndex.value]
                      .category
                      .length,
                  itemBuilder: ((_, index) {
                    var cat = controller
                        .eCatPackage[controller.packageIndex.value].category
                        .elementAt(index);
                    return InkWell(
                      onTap: () {
                        controller.id.value = cat.id;
                      },
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(start: 20),
                        child: RawChip(
                          elevation: 0,
                          label: Text(cat.name),
                          labelStyle: cat.checked
                              ? Get.textTheme.bodyText2.merge(
                                  TextStyle(color: Get.theme.primaryColor))
                              : Get.textTheme.bodyText2,
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 15),
                          backgroundColor:
                              Theme.of(context).focusColor.withOpacity(0.1),
                          selectedColor: Get.theme.textTheme.bodyMedium.color,
                          selected: cat.checked,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          showCheckmark: true,
                          checkmarkColor: Get.theme.primaryColor,
                          onSelected: (bool value) {
                            controller.toggleCatSelected(cat);
                            // controller.loadEServicesOfCategory(controller.category.value.id, filter: controller.selected.value);
                          },
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        );
      }
    });
  }
}

class ServiceCatListWidget extends GetView<DetailController> {
  ServiceCatListWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.eCatService.isEmpty) {
        return SizedBox();
        //return CircularLoadingWidget(height: 300);
      } else {
        return Container(
          height: 60,
          margin: EdgeInsets.only(top: 10, left: 5),
          child: Row(
            children: [
              Container(
                width: 125,
                height: 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).iconTheme.color,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                alignment: Alignment.center,
                child: DropdownButton2(
                    value: controller.serviceId.value,
                    iconStyleData: IconStyleData(
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                    ),
                    buttonStyleData: ButtonStyleData(
                      height: 40,
                      padding: EdgeInsets.all(1),
                    ),
                    dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Theme.of(context).iconTheme.color,
                        ),
                        elevation: 8,
                        scrollbarTheme: ScrollbarThemeData(
                          radius: const Radius.circular(40),
                          thickness: MaterialStateProperty.all(6),
                          thumbVisibility: MaterialStateProperty.all(true),
                        )),
                    underline: SizedBox(),
                    items: controller.eCatService.map((element) {
                      return DropdownMenuItem<String>(
                        value: element.id.toString(),
                        child: Text(
                          element.name,
                          maxLines: 2,
                          softWrap: true,
                          style: TextStyle(
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      controller.serviceId.value = value;
                      controller.serviceIndex.value = controller.eCatService
                          .indexWhere((element) => element.id == value);
                      //  controller.id.value = controller.eCatPackage[controller.packageIndex.value].category[0].id;
                      controller.toggleCatSelected(controller
                          .eCatService[controller.serviceIndex.value]
                          .category[0]);
                    }),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.only(bottom: 10, top: 10),
                  primary: false,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: controller
                      .eCatService[controller.serviceIndex.value]
                      .category
                      .length,
                  itemBuilder: ((_, index) {
                    var cat = controller
                        .eCatService[controller.serviceIndex.value].category
                        .elementAt(index);
                    return InkWell(
                      onTap: () {
                        controller.id.value = cat.id;
                      },
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(start: 20),
                        child: RawChip(
                          elevation: 0,
                          label: Text(cat.name),
                          labelStyle: cat.checked
                              ? Get.textTheme.bodyText2.merge(
                                  TextStyle(color: Get.theme.primaryColor))
                              : Get.textTheme.bodyText2,
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 15),
                          backgroundColor:
                              Theme.of(context).focusColor.withOpacity(0.1),
                          selectedColor: Get.theme.textTheme.bodyMedium.color,
                          selected: cat.checked,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          showCheckmark: true,
                          checkmarkColor: Get.theme.primaryColor,
                          onSelected: (bool value) {
                            controller.toggleCatSelected(cat);
                            // controller.loadEServicesOfCategory(controller.category.value.id, filter: controller.selected.value);
                          },
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        );
      }
    });
  }
}

class SalonListWidget extends GetView<DetailController> {
  SalonListWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if(controller.isLoading.value){
        return CircularLoadingWidget(height: 300);
      }
     else if (controller.eSalon.isEmpty) {

        return Container(
            height: 200,
            child: Center(child: Text("No Data Available")));
      } else {
        return ListView.builder(
          padding: EdgeInsets.only(bottom: 10, top: 10),
          primary: false,
          shrinkWrap: true,
          itemCount: controller.eSalon.length + 1,
          itemBuilder: ((_, index) {
            if (index == controller.eSalon.length) {
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
              var eSalon1 = controller.eSalon.elementAt(index);
              return SalonListItemWidget(
                service: eSalon1,
                value: controller.name.value,
              );
            }
          }),
        );
      }
    });
  }
}
