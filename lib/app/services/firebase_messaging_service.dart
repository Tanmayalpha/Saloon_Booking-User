import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../../common/ui.dart';
import '../models/booking_model.dart';
import '../models/message_model.dart';
import '../modules/bookings/controllers/booking_controller.dart';
import '../modules/bookings/controllers/bookings_controller.dart';
import '../modules/messages/controllers/messages_controller.dart';
import '../modules/root/controllers/root_controller.dart';
import '../routes/app_routes.dart';
import 'auth_service.dart';

class FireBaseMessagingService extends GetxService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  Future<FireBaseMessagingService> init() async {
    FirebaseMessaging.instance.requestPermission(sound: true, badge: true, alert: true);
    await fcmOnLaunchListeners();
    await fcmOnResumeListeners();
    await fcmOnMessageListeners();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');

    final InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
    return this;
  }

  Future fcmOnMessageListeners() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(message.toString());
      print(message.notification.toString());
      print(message.data.toString());
      String payload = "";

      if (message != null && message.notification != null) {
        generateSimpleNotification(
            message.notification.title.toString(),
            message.notification.body.toString(),
            "",
            payload != "" ? payload : message.notification.hashCode.toString());
      }
      if (Get.isRegistered<RootController>()) {
        Get.find<RootController>().getNotificationsCount();
      }
     /* if (message.data['id'] == "App\\Notifications\\NewMessage") {
         _newMessageNotification(message);
      }
      else {
        _bookingNotification(message);
      }*/
    });
  }

  Future fcmOnLaunchListeners() async {
    RemoteMessage message =
    await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      print(message.toString());
      print(message.notification.toString());
      print(message.data.toString());
      String payload = "";

    }
  }
  Future<void> generateSimpleNotification(
      String title, String msg, String type, String id) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'default_notification_channel', 'High Importance Notifications',
      channelDescription:'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');


    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, title, msg, platformChannelSpecifics, payload: id);
  }
  Future fcmOnResumeListeners() async {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(message.toString());
      print(message.notification.toString());
      print(message.data.toString());
      String payload = "";
      if (message.data != null) {
        payload = message.data['course_type'] + "_" + message.data['slug'];
      }
      if (message != null && message.notification != null) {
        generateSimpleNotification(
            message.notification.title.toString(),
            message.notification.body.toString(),
            "",
            payload != "" ? payload : message.notification.hashCode.toString());
      }
     // _notificationsBackground(message);
    });
  }

  void _notificationsBackground(RemoteMessage message) {
    if (message.data['id'] == "App\\Notifications\\NewMessage") {
      _newMessageNotificationBackground(message);
    } else {
      _newBookingNotificationBackground(message);
    }
  }

  void _newBookingNotificationBackground(message) {
    if (Get.isRegistered<RootController>()) {
      Get.toNamed(Routes.BOOKING, arguments: new Booking(id: message.data['bookingId']));
    }
  }

  void _newMessageNotificationBackground(RemoteMessage message) {
    if (message.data['messageId'] != null) {
     // Get.toNamed(Routes.CHAT, arguments: new Message([], id: message.data['messageId']));
    }
  }

  Future<String> setDeviceToken() async {
    Get.find<AuthService>().user.value.deviceToken = await FirebaseMessaging.instance.getToken();
    print("fcmToken${Get.find<AuthService>().user.value.deviceToken}");
    return Get.find<AuthService>().user.value.deviceToken ?? "";
  }

  void _bookingNotification(RemoteMessage message) {
    if (Get.currentRoute == Routes.ROOT) {
      Get.find<BookingsController>().refreshBookings();
    }
    if (Get.currentRoute == Routes.BOOKING) {
      Get.find<BookingController>().refreshBooking();
    }
    RemoteNotification notification = message.notification;
    Get.showSnackbar(Ui.notificationSnackBar(
      title: notification.title,
      message: notification.body,
      mainButton: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        width: 52,
        height: 52,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          child: CachedNetworkImage(
            width: double.infinity,
            fit: BoxFit.cover,
            imageUrl: message.data != null ? message.data['icon'] : "",
            placeholder: (context, url) => Image.asset(
              'assets/img/loading.gif',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            errorWidget: (context, url, error) => Icon(Icons.photo),
          ),
        ),
      ),
      onTap: (getBar) async {
        if (message.data['bookingId'] != null) {
          await Get.back();
          Get.toNamed(Routes.BOOKING, arguments: new Booking(id: message.data['bookingId']));
        }
      },
    ));
  }

  void _newMessageNotification(RemoteMessage message) {
    RemoteNotification notification = message.notification;
    if (Get.find<MessagesController>().initialized) {
      //Get.find<MessagesController>().refreshMessages();
    }
    if (Get.currentRoute != Routes.CHAT) {
      Get.showSnackbar(Ui.notificationSnackBar(
        title: notification.title,
        message: notification.body,
        mainButton: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          width: 42,
          height: 42,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(42)),
            child: CachedNetworkImage(
              width: double.infinity,
              fit: BoxFit.cover,
              imageUrl: message.data != null ? message.data['icon'] : "",
              placeholder: (context, url) => Image.asset(
                'assets/img/loading.gif',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
              errorWidget: (context, url, error) => Icon(Icons.photo),
            ),
          ),
        ),
        onTap: (getBar) async {
          /*if (message.data['messageId'] != null) {
            await Get.back();
            Get.toNamed(Routes.CHAT, arguments: new Message([], id: message.data['messageId']));
          }*/
        },
      ));
    }
  }
}
