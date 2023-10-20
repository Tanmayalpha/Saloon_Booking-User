
import 'dart:math';

import 'package:beauty_salons_customer/app/modules/bookings/widgets/booking_row_widget.dart';
import 'package:beauty_salons_customer/app/modules/details/controllers/contact_controller.dart';
import 'package:beauty_salons_customer/app/modules/global_widgets/select_dialog.dart';
import 'package:beauty_salons_customer/app/modules/global_widgets/text_field_widget.dart';
import 'package:beauty_salons_customer/common/ui.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../models/new_model/query_model.dart';
import '../../../models/user_model.dart';


class QueryView extends GetView<ContactController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Query".tr,
          style: Get.textTheme.headline6
              .merge(TextStyle(color: context.theme.primaryColor)),
        ),
        centerTitle: true,
        backgroundColor: Get.theme.colorScheme.secondary,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Get.theme.primaryColor),
          onPressed: () => {
            Get.back()
            //Get.find<RootController>().changePageOutRoot(0)
          },
        ),
      ),
      body: Obx(() {
        return !controller.loading.value
            ? Container(
          padding: EdgeInsets.all(18.0),
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: controller.query.length,
              itemBuilder: (context,index){
                QueryModel model = controller.query[index];
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                margin: EdgeInsets.symmetric( vertical: 5),
                decoration: Ui.getBoxDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: BookingRowWidget(
                              descriptionFlex: 2,
                              valueFlex: 1,
                              description: "Query ID".tr,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(right: 12, left: 12, top: 6, bottom: 6),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                      color: Get.theme.focusColor.withOpacity(0.1),
                                    ),
                                    child: Text(
                                      model.id.toString(),
                                      overflow: TextOverflow.clip,
                                      maxLines: 1,
                                      softWrap: true,
                                      style: TextStyle(color: Get.theme.hintColor),
                                    ),
                                  ),
                                ],
                              ),
                              hasDivider: true),
                        ),
                        Expanded(
                            flex: 3,
                            child: SizedBox()),
                        //SizedBox(width: 20,),
                        Container(
                          padding: const EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: model.statusText.toLowerCase().contains("open")? Colors.red : Colors.green,
                          ),
                          child: Center(
                            child: Text(
                              model.statusText,
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                              softWrap: true,
                              style: TextStyle(color: Get.theme.scaffoldBackgroundColor,fontSize: 9),
                            ),
                          ),
                        ),
                      ],
                    ),
                    BookingRowWidget(
                        descriptionFlex: 2,
                        descriptionStyle:   Get.textTheme.headline2,
                        valueFlex: 2,
                        description: "${model.name}".tr,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(right: 12, left: 12, top: 6, bottom: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                color: Get.theme.focusColor.withOpacity(0.1),
                              ),
                              child: Text(
                                model.type.toString(),
                                overflow: TextOverflow.clip,
                                maxLines: 1,
                                softWrap: true,
                                style: TextStyle(color: Get.theme.hintColor),
                              ),
                            ),
                          ],
                        ),),
                    SizedBox(height: 5,),
                    Text(
                      "${model.mobile}",
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      style: Get.textTheme.bodyText1,
                    ),
                    SizedBox(height: 8,),
                    Divider(height: 1, thickness: 1),
                    SizedBox(height: 8,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                          Icon(
                            Icons.paste,
                            size: 18,
                            color: Get.theme.focusColor,
                          ),
                          SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              "${model.description}",
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              style: Get.textTheme.bodyText1,
                            ),
                          ),
                          SizedBox(width: 5,),
                        ],),
                        Row(
                            mainAxisSize: MainAxisSize.min,

                            mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                                onTap: () {
                                  logOutDailog(context,model.id.toString(), index,controller);
                                 // controller.deleteQuery(model.id.toString(), index);
                                },
                                child: Icon(Icons.delete, color: Colors.black26,)),]
                        ),
                      ],
                    ),
                  ],
                ),
              );
          }),
        )
            : Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }
  Widget buildCategory(String val) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Text(val ?? '', style: Get.textTheme.bodyText2),
        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
    );
  }

  logOutDailog(BuildContext context, String id, int index, ContactController controller, ) async {
    await dialogAnimate(context,
        StatefulBuilder(builder: (BuildContext context, StateSetter setStater) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setStater) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  content: Text(
                    'Are you sure, you want to delete ?',
                    style: TextStyle(color: Colors.black),
                  ),
                  actions: <Widget>[
                    new TextButton(
                        child: Text(
                          'No',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        }),
                    new TextButton(
                        child: Text(
                          'YES',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () async {
                          //favList.clear();
                          controller.deleteQuery(id, index);
                          Navigator.of(context).pop();
                        })
                  ],
                );
              });
        }));
  }
  dialogAnimate(BuildContext context, Widget dialge) {
    return showGeneralDialog(
        barrierColor: Colors.black26,
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(opacity: a1.value, child: dialge),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        // pageBuilder: null
        pageBuilder: (context, animation1, animation2) {
          return Container();
        } //as Widget Function(BuildContext, Animation<double>, Animation<double>)
    );
  }
}
