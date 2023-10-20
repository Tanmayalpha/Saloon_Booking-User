/*
 * File name: category_view.dart
 * Last modified: 2022.02.13 at 19:23:03
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:beauty_salons_customer/app/modules/details/controllers/detail_controller.dart';
import 'package:beauty_salons_customer/app/routes/app_routes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../providers/laravel_provider.dart';
import '../../global_widgets/address_widget.dart';
import '../../global_widgets/home_search_bar_widget.dart';

import '../widgets/services_list_widget.dart';

class DetailView extends GetView<DetailController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            Get.find<LaravelApiClient>().forceRefresh();
            controller.refreshEServices(showMessage: true);
            Get.find<LaravelApiClient>().unForceRefresh();
          },
          child: CustomScrollView(
            controller: controller.scrollController,
            shrinkWrap: false,
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Get.theme.colorScheme.secondary,
                expandedHeight: 180,
                elevation: 0.5,
                primary: true,
                // pinned: true,
                floating: true,
                iconTheme: IconThemeData(color: Get.theme.primaryColor),
                title: Text(
                  //controller.name.value=="Near By"?"Nearest":
                  controller.name.value,
                  style: Get.textTheme.headline1.merge(TextStyle(
                    color: Get.theme.primaryColor,
                  )),
                ),
                centerTitle: true,
                automaticallyImplyLeading: false,
                leading: new IconButton(
                  icon: new Icon(Icons.arrow_back_ios,
                      color: Get.theme.primaryColor),
                  onPressed: () => {Get.back()},
                ),
                actions: [
                //  controller.name.value=="Near By"?
                  InkWell(
                    onTap: () {
                      Get.toNamed(Routes.MAPS,
                          arguments: {"salons": controller.eSalon});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).iconTheme.color,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      margin: EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Get.theme.primaryColor,
                            size: 16,
                          ),
                          Text(
                            "Show Map",
                            style: Get.textTheme.headline1.merge(TextStyle(
                                color: Get.theme.primaryColor, fontSize: 12.0)),
                          ),
                        ],
                      ),
                    ),
                  ),
                    //  :SizedBox(),
                ],
                bottom: PreferredSize(
                  preferredSize: Size(Get.width, 80),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: HomeSearchBarWidget(
                            from: true, type: controller.name.value),
                      ),
                  if(controller.name.value!="Popular Packages")
                    Obx(() =>  controller.packageId.value!=null||controller.sort.value!=null?Padding(
                        padding: const EdgeInsets.only(bottom:16.0,right: 5),
                        child: MaterialButton(onPressed: (){
                          controller.sort.value = null;
                          controller.packageId.value = null;
                          controller.loadEServicesOfCategory(controller.id.value, filter: controller.selected.value);
                        },

                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          color: Get.theme.primaryColor,
                          child: Row(
                            children: [
                              Icon(
                                Icons.clear,
                                size: 16,
                              ),
                              SizedBox(width: 5,),
                              Text("Clear Filter".tr, style: Get.textTheme.bodyText2),
                            ],
                          ),
                        ),
                      ):SizedBox()),
                    ],
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    background: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        AddressWidget(
                          color: Get.theme.primaryColor,
                        ).paddingOnly(bottom: 75),
                      ],
                    )).marginOnly(bottom: 42),
              ),
              SliverToBoxAdapter(
                child: Wrap(
                  children: [
                    /*Container(
                    height: 60,
                    margin: EdgeInsets.only(top:10),
                    child: ListView(
                        primary: false,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: List.generate(controller.category.length, (index) {
                          var cat = controller.category.elementAt(index);
                          return Obx(() {
                            return Padding(
                              padding: const EdgeInsetsDirectional.only(start: 20),
                              child: RawChip(
                                elevation: 0,
                                label: Text(cat.title),
                                labelStyle: controller.isSelected(cat) ? Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.primaryColor)) : Get.textTheme.bodyText2,
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                                backgroundColor: Theme.of(context).focusColor.withOpacity(0.1),
                                selectedColor:Get.theme.textTheme.bodyMedium.color,
                                selected: controller.isSelected(cat),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                showCheckmark: true,
                                checkmarkColor: Get.theme.primaryColor,
                                onSelected: (bool value) {
                                  controller.toggleSelected(cat);
                                 // controller.loadEServicesOfCategory(controller.category.value.id, filter: controller.selected.value);
                                },
                              ),
                            );
                          });
                        })),
                  ),*/
                    controller.name.value == "Top Brands"
                        ? SizedBox()
                        : controller.name.value != "Popular Packages" &&
                                controller.name.value != "Popular Services"
                            ? SalonHorizontalListWidget()
                            : controller.name.value != "Popular Services"
                                ? PackageCatListWidget()
                                : ServiceCatListWidget(),
                    SalonListWidget(),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: controller.name.value=="Popular Services"?SizedBox():Obx(
          () => Container(
            height: 60,
            decoration: BoxDecoration(
              color: Theme.of(context).iconTheme.color,
            ),
            alignment: Alignment.center,
            padding: EdgeInsets.all(5.0),
            child: Row(
              children: [
                if(controller.name.value!="Popular Packages")
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    child: DropdownButton2(
                        hint: Text("Gender"),
                        value: controller.packageId.value,
                        dropdownStyleData: DropdownStyleData(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: Theme.of(context).iconTheme.color,
                            ),
                            elevation: 8,
                            offset: const Offset(-20, 0),
                            scrollbarTheme: ScrollbarThemeData(
                              radius: const Radius.circular(40),
                              thickness: MaterialStateProperty.all(6),
                              thumbVisibility: MaterialStateProperty.all(true),
                            )),
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
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
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
                ),
                if(controller.name.value!="Popular Packages")
                VerticalDivider(
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    child: DropdownButton(
                        hint: Text("Sort"),
                        value: controller.sort.value,
                        dropdownColor: Theme.of(context).iconTheme.color,
                        icon: Icon(
                          Icons.sort,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        underline: SizedBox(),
                        items: ["Price High to Low", "Price Low to high"]
                            .map((element) {
                          return DropdownMenuItem<String>(
                            value: element,
                            child: Text(
                              element,
                              style: TextStyle(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          controller.sort.value = value;
                          if(controller
                              .eCatPackage.length>0&&controller
                              .eCatPackage[controller.packageIndex.value]
                              .category.length>0){
                            controller.toggleCatSelected(controller
                                .eCatPackage[controller.packageIndex.value]
                                .category[0]);
                          }

                        }),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
