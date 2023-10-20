/*
 * File name: home2_view.dart
 * Last modified: 2022.02.17 at 09:53:26
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/slide_model.dart';
import '../../../providers/laravel_provider.dart';
import '../../../routes/app_routes.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/address_widget.dart';
import '../../global_widgets/home_search_bar_widget.dart';
import '../../global_widgets/notifications_button_widget.dart';
import '../controllers/home_controller.dart';
import '../widgets/categories_carousel_widget.dart';
import '../widgets/featured_categories_widget.dart';
import '../widgets/recommended_carousel_widget.dart';
import '../widgets/slide_item_widget.dart';

class Home2View extends GetView<HomeController> {
  // final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Colors.black87),
          onPressed: () => {Scaffold.of(context).openDrawer()},
          // onPressed: () => {scaffoldKey.currentUser.openDrawer()},
        ),
        title:  Text(
          Get.find<SettingsService>().setting.value.appName,
          style: Get.textTheme.headline6,
        ),
        actions: [
          IconButton(onPressed: (){
            Get.toNamed(Routes.FAVORITES_SALON);
          }, icon: Icon(
            Icons.favorite_border,
            color: Get.theme.hintColor,
          )),
          NotificationsButtonWidget(),

        ],
      ),
      // key: scaffoldKey,
      body: RefreshIndicator(
          onRefresh: () async {
            Get.find<LaravelApiClient>().forceRefresh();
            await controller.refreshHome(showMessage: true);
            Get.find<LaravelApiClient>().unForceRefresh();
          },
          child: CustomScrollView(
            primary: true,
            shrinkWrap: false,
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                expandedHeight: 300,
                elevation: 0.5,
                floating: true,
                pinned: true,
                iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
                centerTitle: true,
                automaticallyImplyLeading: false,
                bottom: HomeSearchBarWidget(),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Obx(() {
                    return Stack(
                      alignment: controller.slider.isEmpty
                          ? AlignmentDirectional.center
                          : Ui.getAlignmentDirectional(controller.slider.elementAt(controller.currentSlide.value).textPosition),
                      children: <Widget>[
                        CarouselSlider(
                          options: CarouselOptions(
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 7),
                            height: 360,
                            viewportFraction: 1.0,
                            onPageChanged: (index, reason) {
                              controller.currentSlide.value = index;
                            },
                          ),
                          items: controller.slider.map((Slide slide) {
                            return SlideItemWidget(slide: slide);
                          }).toList(),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 70, horizontal: 20),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: controller.slider.map((Slide slide) {
                              return Container(
                                width: 20.0,
                                height: 5.0,
                                margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    color: controller.currentSlide.value == controller.slider.indexOf(slide) ? slide.indicatorColor : slide.indicatorColor.withOpacity(0.4)),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    );
                  }),
                ).marginOnly(bottom: 42),
              ),
              SliverToBoxAdapter(
                child: Wrap(
                  children: [
                    AddressWidget(),
                    Container(
                      height: 60,
                      child: ListView(
                          primary: false,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: List.generate(HomeFilter.values.length, (index) {
                            var _filter = HomeFilter.values.elementAt(index);
                            return Obx(() {
                              return Padding(
                                padding: const EdgeInsetsDirectional.only(start: 20,end: 20),
                                child: RawChip(
                                  elevation: 0,
                                  label: Text(controller.filterList[index]),
                                  labelStyle: controller.isSelected(_filter) ? Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.primaryColor)) : Get.textTheme.bodyText2,
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                                  backgroundColor: Theme.of(context).focusColor.withOpacity(0.1),
                                  selectedColor: Get.theme.colorScheme.secondary,
                                  selected: controller.isSelected(_filter),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  showCheckmark: true,
                                  checkmarkColor: Get.theme.primaryColor,
                                  onSelected: (bool value) {
                                    controller.toggleSelected(_filter);
                                    Get.toNamed(Routes.DETAIL, arguments: controller.filterList[index]);
                                   // controller.loadEServicesOfCategory(controller.category.value.id, filter: controller.selected.value);
                                  },
                                ),
                              );
                            });
                          })),
                    ),
                    /*Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Text("Near By"),
                            Text("Popular Packages"),
                            Text("Popular Services"),
                            // Text("Top Brands"),
                            // Text("Top Picks For You"),
                            // Text("Offer"),
                        ],
                        ),
                      ),
                    ),*/
                    Obx(() => controller.salons.isNotEmpty?Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: Row(
                        children: [
                          Expanded(child: Text("Top picks for you".tr, style: Get.textTheme.headline5)),
                          MaterialButton(
                            onPressed: () {
                              Get.toNamed(Routes.MAPS,arguments: {"salons":controller.salons});
                            },
                            shape: StadiumBorder(),
                            color: Get.theme.colorScheme.secondary.withOpacity(0.1),
                            child: Text("View All".tr, style: Get.textTheme.subtitle1),
                            elevation: 0,
                          ),
                        ],
                      ),
                    ):SizedBox()),
                    Obx(() => controller.salons.isNotEmpty?RecommendedCarouselWidget():SizedBox()),
                    Container(
                      color: Get.theme.primaryColor,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      child: Row(
                        children: [
                          Expanded(child: Text("Popular Services".tr, style: Get.textTheme.headline5)),
                          MaterialButton(
                            onPressed: () {
                              Get.toNamed(Routes.CATEGORIES);
                            },
                            shape: StadiumBorder(),
                            color: Get.theme.colorScheme.secondary.withOpacity(0.1),
                            child: Text("View All".tr, style: Get.textTheme.subtitle1),
                            elevation: 0,
                          ),
                        ],
                      ),
                    ),
                    CategoriesCarouselWidget(),
                   /* FeaturedCategoriesWidget(),*/
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
