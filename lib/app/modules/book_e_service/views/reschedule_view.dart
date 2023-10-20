/*
 * File name: book_e_service_view.dart
 * Last modified: 2022.03.11 at 23:35:29
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:beauty_salons_customer/app/modules/book_e_service/controllers/reschedule_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../common/ui.dart';
import '../../../models/booking_model.dart';
import '../../../providers/laravel_provider.dart';
import '../../../routes/app_routes.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/tab_bar_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/book_e_service_controller.dart';

class RescheduleView extends GetView<RescheduleController> {
  Booking _booking;

  RescheduleView(this._booking);

  @override
  Widget build(BuildContext context) {
    controller.onCall(_booking);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: Ui.getBoxDecoration(),
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: DatePicker(
                  DateTime.now(),
                  width: 60,
                  height: 90,
                  daysCount: 7,
                  controller: controller.datePickerController,
                  initialSelectedDate: DateTime.now(),
                  selectionColor: Get.theme.colorScheme.secondary,
                  selectedTextColor: Get.theme.primaryColor,
                  locale: Get.locale.toString(),
                  onDateChange: (date) async {
                    // New date selected
                    Get.find<TabBarController>(tag: 'hours')
                        .selectedId
                        .value = "";
                    controller.selectedDate = date;
                    await controller.getTimes(date: date);
                  },
                ),
              ),

              Obx(() {
                if (controller.morningTimes.isEmpty) {
                  return SizedBox();
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 5, left: 20, right: 20),
                        child: Text("Morning".tr, style: Get.textTheme.bodyText2),
                      ),
                      TabBarWidget(
                        initialSelectedId: "",
                        tag: 'hours',
                        tabs: List.generate(controller.morningTimes.length,
                                (index) {
                              final _time = controller.morningTimes
                                  .elementAt(index)
                                  .elementAt(0);
                              bool _available = controller.morningTimes
                                  .elementAt(index)
                                  .elementAt(1);
                              if (_available) {
                                return ChipWidget(
                                  backgroundColor: Get.theme.colorScheme.secondary
                                      .withOpacity(0.2),
                                  style: Get.textTheme.bodyText1.merge(TextStyle(
                                      color: Get.theme.colorScheme.secondary)),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 15),
                                  tag: 'hours',
                                  text: DateFormat('hh:mm a')
                                      .format(DateTime.parse(_time).toLocal()),
                                  id: _time,
                                  onSelected: (id) {
                                    print(controller.booking.value.employee);
                                    if(controller.booking.value.employee == null){
                                      Get.showSnackbar(Ui.ErrorSnackBar(message: "Please Select Employee"));
                                      return;
                                    }else{

                                      controller.booking.update((val) {
                                        val.bookingAt =
                                            DateTime.parse(id).toLocal();
                                      });
                                    }

                                  },
                                );
                              } else {
                                return RawChip(
                                  elevation: 0,
                                  label: Text(
                                      DateFormat('hh:mm a').format(
                                          DateTime.parse(_time).toLocal()),
                                      style: Get.textTheme.caption),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 15),
                                  backgroundColor:
                                  Get.theme.focusColor.withOpacity(0.1),
                                  selectedColor: Get.theme.colorScheme.secondary,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  showCheckmark: false,
                                  pressElevation: 0,
                                ).marginSymmetric(horizontal: 5);
                              }
                            }),
                      ),
                    ],
                  );
                }
              }),

              Obx(() {
                if (controller.afternoonTimes.isEmpty) {
                  return SizedBox();
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 5, left: 20, right: 20),
                        child:
                        Text("Afternoon".tr, style: Get.textTheme.bodyText2),
                      ),
                      TabBarWidget(
                        initialSelectedId: "",
                        tag: 'hours',
                        tabs: List.generate(controller.afternoonTimes.length,
                                (index) {
                              final _time = controller.afternoonTimes
                                  .elementAt(index)
                                  .elementAt(0);
                              bool _available = controller.afternoonTimes
                                  .elementAt(index)
                                  .elementAt(1);
                              if (_available) {
                                return ChipWidget(
                                  backgroundColor: Get.theme.colorScheme.secondary
                                      .withOpacity(0.2),
                                  style: Get.textTheme.bodyText1.merge(TextStyle(
                                      color: Get.theme.colorScheme.secondary)),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 15),
                                  tag: 'hours',
                                  text: DateFormat('hh:mm a')
                                      .format(DateTime.parse(_time).toLocal()),
                                  id: _time,
                                  onSelected: (id) {
                                    print(controller.booking.value.employee);
                                    if(controller.booking.value.employee == null){
                                      Get.showSnackbar(Ui.ErrorSnackBar(message: "Please Select Employee"));

                                    } else {
                                      controller.booking.update((val) {
                                        val.bookingAt =
                                            DateTime.parse(id).toLocal();
                                      });
                                    }
                                  },
                                );
                              } else {
                                return RawChip(
                                  elevation: 0,
                                  label: Text(
                                      DateFormat('hh:mm a').format(
                                          DateTime.parse(_time).toLocal()),
                                      style: Get.textTheme.caption),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 15),
                                  backgroundColor:
                                  Get.theme.focusColor.withOpacity(0.1),
                                  selectedColor: Get.theme.colorScheme.secondary,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  showCheckmark: false,
                                  pressElevation: 0,
                                ).marginSymmetric(horizontal: 5);
                              }
                            }),
                      ),
                    ],
                  );
                }
              }),

              Obx(() {
                if (controller.eveningTimes.isEmpty) {
                  return SizedBox();
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 5, left: 20, right: 20),
                        child: Text("Evening".tr, style: Get.textTheme.bodyText2),
                      ),
                      TabBarWidget(
                        initialSelectedId: "",
                        tag: 'hours',
                        tabs: List.generate(controller.eveningTimes.length,
                                (index) {
                              final _time = controller.eveningTimes
                                  .elementAt(index)
                                  .elementAt(0);
                              bool _available = controller.eveningTimes
                                  .elementAt(index)
                                  .elementAt(1);
                              if (_available) {
                                return ChipWidget(
                                  backgroundColor: Get.theme.colorScheme.secondary
                                      .withOpacity(0.2),
                                  style: Get.textTheme.bodyText1.merge(TextStyle(
                                      color: Get.theme.colorScheme.secondary)),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 15),
                                  tag: 'hours',
                                  text: DateFormat('hh:mm a')
                                      .format(DateTime.parse(_time).toLocal()),
                                  id: _time,
                                  onSelected: (id) {
                                    print(controller.booking.value.employee);
                                    if(controller.booking.value.employee == null){
                                      Get.showSnackbar(Ui.ErrorSnackBar(message: "Please Select Employee"));

                                    }else{
                                      controller.booking.update((val) {
                                        val.bookingAt =
                                            DateTime.parse(id).toLocal();
                                      });
                                    }

                                  },
                                );
                              } else {
                                return RawChip(
                                  elevation: 0,
                                  label: Text(
                                      DateFormat('hh:mm a').format(
                                          DateTime.parse(_time).toLocal()),
                                      style: Get.textTheme.caption),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 15),
                                  backgroundColor:
                                  Get.theme.focusColor.withOpacity(0.1),
                                  selectedColor: Get.theme.colorScheme.secondary,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  showCheckmark: false,
                                  pressElevation: 0,
                                ).marginSymmetric(horizontal: 5);
                              }
                            }),
                      ),
                    ],
                  );
                }
              }),

              Obx(() {
                if (controller.nightTimes.isEmpty) {
                  return SizedBox();
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 5, left: 20, right: 20),
                        child: Text("Night".tr, style: Get.textTheme.bodyText2),
                      ),
                      TabBarWidget(
                        initialSelectedId: "",
                        tag: 'hours',
                        tabs: List.generate(controller.nightTimes.length,
                                (index) {
                              final _time = controller.nightTimes
                                  .elementAt(index)
                                  .elementAt(0);
                              bool _available = controller.nightTimes
                                  .elementAt(index)
                                  .elementAt(1);
                              if (_available) {
                                return ChipWidget(
                                  backgroundColor: Get.theme.colorScheme.secondary
                                      .withOpacity(0.2),
                                  style: Get.textTheme.bodyText1.merge(TextStyle(
                                      color: Get.theme.colorScheme.secondary)),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 15),
                                  tag: 'hours',
                                  text: DateFormat('hh:mm a')
                                      .format(DateTime.parse(_time).toLocal()),
                                  id: _time,
                                  onSelected: (id) {
                                    print(controller.booking.value.employee);
                                    if(controller.booking.value.employee == null){
                                      Get.showSnackbar(Ui.ErrorSnackBar(message: "Please Select Employee"));

                                    }else{
                                      controller.booking.update((val) {
                                        val.bookingAt =
                                            DateTime.parse(id).toLocal();
                                      });
                                    }

                                  },
                                );
                              } else {
                                return RawChip(
                                  elevation: 0,
                                  label: Text(
                                      DateFormat('hh:mm a').format(
                                          DateTime.parse(_time).toLocal()),
                                      style: Get.textTheme.caption),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 15),
                                  backgroundColor:
                                  Get.theme.focusColor.withOpacity(0.1),
                                  selectedColor: Get.theme.colorScheme.secondary,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  showCheckmark: false,
                                  pressElevation: 0,
                                ).marginSymmetric(horizontal: 5);
                              }
                            }),
                      ),
                    ],
                  );
                }
              }),
            ],
          ),
        ),
        SizedBox(height: 20),
        buildBlockButtonWidget(controller.booking.value),
        SizedBox(height: 20),
      ],
    );
  }

  Widget buildBlockButtonWidget(Booking _booking) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Get.theme.primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
              color: Get.theme.focusColor.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -5)),
        ],
      ),
      child:
      //Obx(() {return
          Row(
          children: [
            Expanded(
              flex: 1,
              child: BlockButtonWidget(
                  text: Stack(
                    alignment: AlignmentDirectional.centerEnd,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          "Back".tr,
                          textAlign: TextAlign.center,
                          style: Get.textTheme.headline6.merge(
                            TextStyle(color: Get.theme.primaryColor,fontSize: 14.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  color: Get.theme.hintColor,
                  onPressed: () {
                    Get.back();
                  }),
            ),
            SizedBox(width: 20),
            Expanded(
              flex: 1,
              child: BlockButtonWidget(
                  text: Stack(
                    alignment: AlignmentDirectional.centerEnd,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          "Reschedule".tr,
                          textAlign: TextAlign.center,
                          style: Get.textTheme.headline6.merge(
                            TextStyle(color: Get.theme.primaryColor,fontSize: 14.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  color: Get.theme.hintColor,
                  onPressed: () {
                    if(_booking.bookingAt==null){
                      Get.showSnackbar(Ui.ErrorSnackBar(message: "Please Select Time"));
                      return;
                    }
                    controller.updateBooking(_booking);
                  }),
            ),
          ],
        )
    //  }),
    );
  }
}
