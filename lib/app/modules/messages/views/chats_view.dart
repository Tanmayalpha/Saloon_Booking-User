/*
 * File name: chats_view.dart
 * Last modified: 2022.02.18 at 19:24:11
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/chat_model.dart';
import '../../../models/media_model.dart';
import '../../../models/message_model.dart';
import '../../../models/new_model/buzz_model.dart';
import '../../../models/user_model.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../../root/controllers/root_controller.dart';
import '../controllers/buzz_controller.dart';
import '../controllers/messages_controller.dart';
import '../widgets/buzz_item_widget.dart';
// ignore: must_be_immutable
class BuzzView extends GetView<BuzzController> {
  final _myListKey = GlobalKey<AnimatedListState>();

  Widget BuzzList() {
    return Obx(
      () {
        if (controller.buzz.isEmpty) {
          return CircularLoadingWidget(
            height: Get.height,
            // onCompleteText: "Type a message to start chat!".tr,
          );
        } else {
          return ListView.builder(
              key: _myListKey,
              reverse: true,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              itemCount: controller.buzz.length,
              shrinkWrap: false,
              primary: true,
              itemBuilder: (context, index) {
                BuzData _buzz = controller.buzz.elementAt(index);
                // // Chat _chat = controller.buzz.elementAt(index);
                // _buzz.user = controller.value.buzz.firstWhere((_buzz) => _buzz.id == _buzz.id, orElse: () =>new Data(name: "-", avatar: new Media())
                // );
                return BuzzItem(
                  // chat: _chat,
                  buzz: _buzz,
                );
              });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // controller.value = Get.arguments as Message;
    // if (controller.value.id != null) {
    //   // controller.listenForChats();
    // }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
            onPressed: () async {
              // controller.value = new Message([]);
              // controller.buzz.clear();
              // await controller.refreshMessages();
              // Get.find<RootController>().changePage(2);
            }),
        automaticallyImplyLeading: false,
        title: Obx(() {
          return Text("Buzz",
            // controller.value.name,
            overflow: TextOverflow.fade,
            maxLines: 1,
            style: Get.textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
          );
        }),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            // child: chatList(),
            child: BuzzList(),
          ),
          // Obx(() {
          //   if (controller.uploading.isTrue)
          //     return Container(
          //       padding: EdgeInsets.symmetric(vertical: 30),
          //       child: CircularProgressIndicator(),
          //     );
          //   else
          //     return SizedBox();
          // }),
          // Container(
          //   decoration: BoxDecoration(
          //     color: Get.theme.primaryColor,
          //     boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.10), offset: Offset(0, -4), blurRadius: 10)],
          //   ),
          //   child: Row(
          //     children: [
          //       Wrap(
          //         children: [
          //           SizedBox(width: 10),
          //           IconButton(
          //             padding: EdgeInsets.zero,
          //             onPressed: () async {
          //               var imageUrl = await controller.getImage(ImageSource.gallery);
          //               if (imageUrl != null && imageUrl.trim() != '') {
          //                 await controller.addMessage(controller.value, imageUrl);
          //               }
          //               Timer(Duration(milliseconds: 100), () {
          //                 // controller.chatTextController.clear();
          //               });
          //             },
          //             icon: Icon(
          //               Icons.photo_outlined,
          //               color: Get.theme.colorScheme.secondary,
          //               size: 30,
          //             ),
          //           ),
          //           IconButton(
          //             padding: EdgeInsets.zero,
          //             onPressed: () async {
          //               var imageUrl = await controller.getImage(ImageSource.camera);
          //               if (imageUrl != null && imageUrl.trim() != '') {
          //                 await controller.addMessage(controller.value, imageUrl);
          //               }
          //               Timer(Duration(milliseconds: 100), () {
          //                 // controller.chatTextController.clear();
          //               });
          //             },
          //             icon: Icon(
          //               Icons.camera_alt_outlined,
          //               color: Get.theme.colorScheme.secondary,
          //               size: 30,
          //             ),
          //           ),
          //         ],
          //       ),
          //       Expanded(
          //         child: TextField(
          //           // controller: controller.chatTextController,
          //           style: Get.textTheme.bodyText1,
          //           decoration: InputDecoration(
          //             contentPadding: EdgeInsets.all(20),
          //             hintText: "Type to start chat".tr,
          //             hintStyle: TextStyle(color: Get.theme.focusColor.withOpacity(0.8)),
          //             suffixIcon: IconButton(
          //               padding: EdgeInsetsDirectional.only(end: 20, start: 10),
          //               onPressed: () {
          //                 // controller.addMessage(controller.message.value, controller.chatTextController.text);
          //                 Timer(Duration(milliseconds: 100), () {
          //                   // controller.chatTextController.clear();
          //                 });
          //               },
          //               icon: Icon(
          //                 Icons.send_outlined,
          //                 color: Get.theme.colorScheme.secondary,
          //                 size: 30,
          //               ),
          //             ),
          //             border: UnderlineInputBorder(borderSide: BorderSide.none),
          //             enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
          //             focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }
}
