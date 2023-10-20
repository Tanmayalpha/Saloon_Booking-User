/*
 * File name: messages_view.dart
 * Last modified: 2022.02.18 at 19:24:11
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:beauty_salons_customer/common/ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import '../../../models/new_model/buzz_model.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../../global_widgets/notifications_button_widget.dart';
import '../controllers/buzz_controller.dart';
import '../controllers/messages_controller.dart';
import '../widgets/message_item_widget.dart';

class NewBuzzView extends GetView<BuzzController> {
  // ScrollController scrollController = ScrollController();
  // BuzData buzz;

  // BuzzItem({this.buzz});
  Widget conversationsList() {
    return Obx(
      () {
        if (controller.buzz.isNotEmpty) {
          // var _buzz = controller.buzz;
          return Container(
            padding: EdgeInsets.all(10),
            child: ListView.separated(
                physics: AlwaysScrollableScrollPhysics(),
                controller: controller.scrollController,
                itemCount: controller.buzz.length,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 10);
                },
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ExpansionTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.grey.withOpacity(0.3)),
                    ),
                    collapsedShape:  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.grey.withOpacity(0.3)),
                    ),
                    backgroundColor: Colors.white,
                    title: Text(
                        controller.buzz[index].title.toString(),
                      style: Get.theme.textTheme.titleSmall,
                    ),
                    tilePadding: EdgeInsets.all(10),
                    childrenPadding: EdgeInsets.all(10),
                    leading:ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        color: Get.theme.primaryColor,
                        child: CachedNetworkImage(
                            height: 100,
                             width: 80,
                            fit: BoxFit.fill,
                            imageUrl:controller.buzz[index].media.length>0?controller.buzz[index].firstImageUrl:""
                        ),
                      ),
                    ),
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        child: Ui.applyHtml(controller.buzz[index].description, style: Get.textTheme.bodyText1),
                      ),
                    ],
                  );
                  return
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0),),
                      child: Column(
                        children: [
                          // Ink.image(
                          //   image: AssetImage(controller.buzz[index].image),
                          // ),
                          // image: Image.network(controller.buzz[index].image),
                          // Ink.image(Image: Image.file(controller.buzz[index].image)),
                          // Ink.image(image: Image.network(controller.buzz[index].image)),
                          CachedNetworkImage(
                              height: 130,
                              // width: 68.5,
                              fit: BoxFit.cover,
                              imageUrl: controller.buzz[index].image
                          ),
                          Text(controller.buzz[index].title.toString(),
                            style: Get.textTheme.headline6.merge(TextStyle(letterSpacing: 1.2),
                            ),
                          ),
                          // SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Text(controller.buzz[index].description),
                          ),
                        ],
                      ),
                  ),
                    );
                  //   MessageItemWidget(
                  //   message: _buzz.elementAt(index),
                  //   onDismissed: (conversation) async {
                  //     await controller.deleteMessage(_buzz.elementAt(index));
                  //   },
                  // );
                }),
          );
        } else {
          return CircularLoadingWidget(
            height: Get.height,
            onCompleteText: "Buzz List Empty".tr,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Buzz".tr,
          style: Get.textTheme.headline6,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Get.theme.hintColor),
          onPressed: () => {Scaffold.of(context).openDrawer()},
        ),
        actions: [NotificationsButtonWidget()],
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            controller.buzz.clear();
            controller.refreshBuzz();
            // controller.lastDocument = new Rx<DocumentSnapshot>(null);
            // await controller.listenForMessages();
          },
          child: conversationsList()
      ),
    );
  }
}
