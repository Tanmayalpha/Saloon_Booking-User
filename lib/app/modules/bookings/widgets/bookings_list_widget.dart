import 'package:beauty_salons_customer/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../global_widgets/circular_loading_widget.dart';
import '../controllers/bookings_controller.dart';
import 'bookings_list_item_widget.dart';

class BookingsListWidget extends GetView<BookingsController> {
  BookingsListWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {

        if (controller.isLoading.value) {
          return CircularLoadingWidget(height: 300);
        } else if (controller.bookings.isEmpty) {
          return Container(
            height: 400,
            width: Get.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "No Bookings Available",
                  style:
                      Get.textTheme.bodyText2.merge(TextStyle(fontSize: 20.0)),
                  maxLines: 3,
                  // textAlign: TextAlign.end,
                ),
                SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () {
                    Get.toNamed(Routes.DETAIL, arguments: "Near By");
                  },
                  child: Text(
                    "Explore Nearby Services",
                    style: Get.textTheme.bodyText2.merge(TextStyle(
                        color: Get.theme.iconTheme.color,
                        fontSize: 14.0,
                        decoration: TextDecoration.underline)),
                    maxLines: 3,
                    // textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          );
        }
       else {
        return ListView.builder(
          padding: EdgeInsets.only(bottom: 10, top: 10),
          primary: false,
          shrinkWrap: true,
          itemCount: controller.bookings.length + 1,
          itemBuilder: ((_, index) {
            if (index == controller.bookings.length) {
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
              var _booking = controller.bookings.elementAt(index);
              return BookingsListItemWidget(booking: _booking);
            }
          }),
        );
      }
    });
  }
}
