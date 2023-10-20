import 'package:beauty_salons_customer/common/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../global_widgets/custom_bottom_nav_bar.dart';
import '../../global_widgets/main_drawer_widget.dart';
import '../controllers/root_controller.dart';

class RootView extends GetView<RootController> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return WillPopScope(
        onWillPop: controller.currentIndex.value!=0?()async{
          controller.currentIndex.value = 0;
          return Future.value();
        }:Helper().onWillPop,
        child: Scaffold(
          key: scaffoldKey,
          drawer: Drawer(
            child: MainDrawerWidget(),
            elevation: 0,
          ),
          body: controller.currentPage,
          bottomNavigationBar: CustomBottomNavigationBar(
            backgroundColor: context.theme.scaffoldBackgroundColor,
            itemColor: context.theme.colorScheme.secondary,
            currentIndex: controller.currentIndex.value,
            onChange: (index) {
              if(index!=3){
                controller.changePage(index);
              }else{
                scaffoldKey.currentState.openDrawer();
               // Scaffold.of(context).openDrawer();
              }
            },
            children: [
              CustomBottomNavigationItem(
                icon: Icons.home_outlined,
                label: "Home".tr,
              ),
              // CustomBottomNavigationItem(
              //   icon: Icons.location_on,
              //   label: "Map".tr,
              // ),
              CustomBottomNavigationItem(
                icon: Icons.assignment_outlined,
                label: "Bookings".tr,
              ),
              CustomBottomNavigationItem(
                icon: Icons.chat_outlined,
                label: "Buzz".tr,
              ),
              CustomBottomNavigationItem(
                icon: Icons.person_outline,
                label: "Account".tr,
              ),
            ],
          ),
        ),
      );
    });
  }
}
