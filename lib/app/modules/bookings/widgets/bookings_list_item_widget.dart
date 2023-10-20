/*
 * File name: bookings_list_item_widget.dart
 * Last modified: 2022.02.26 at 14:50:11
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:beauty_salons_customer/app/modules/bookings/widgets/booking_row_widget.dart';
import 'package:beauty_salons_customer/app/services/global_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../common/ui.dart';
import '../../../models/booking_model.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/booking_address_chip_widget.dart';
import 'booking_options_popup_menu_widget.dart';

class BookingsListItemWidget extends StatelessWidget {
  const BookingsListItemWidget({
    Key key,
    @required Booking booking,
  })  : _booking = booking,
        super(key: key);

  final Booking _booking;

  @override
  Widget build(BuildContext context) {
    Color _color = _booking.cancel ? Get.theme.focusColor : Get.theme.colorScheme.secondary;
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.BOOKING, arguments: _booking);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: Ui.getBoxDecoration(),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: BookingRowWidget(
                      descriptionFlex: 2,
                      valueFlex: 1,
                      description: "Booking ID".tr,
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
                              _booking.id,
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
                    flex: 2,
                    child: SizedBox()),
                //SizedBox(width: 20,),
                _booking.status!=null?Container(
                  padding: const EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: _booking.status.status.toLowerCase().contains("confirmed")?Colors.yellow:
                    _booking.status.status.toLowerCase().contains("completed")?Colors.green:_booking.status.status.toLowerCase().contains("accepted")?Colors.orange:Colors.red,
                  ),
                  child: Center(

                    child: Text(
                      _booking.status.order == Get.find<GlobalService>().global.value.noShow?_booking.status.status:_booking.cancel?_booking.cancelBy!=null&&_booking.cancelBy!=""?"${_booking.status.status} by ${_booking.cancelBy}":"${_booking.status.status} by user":_booking.status.status,
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                      softWrap: true,
                      style: TextStyle(color: _booking.status.status.toLowerCase().contains("confirmed")?Colors.black:Get.theme.scaffoldBackgroundColor,fontSize: 9),
                    ),
                  ),
                ):SizedBox(),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                      child: Container(
                        height: 80,
                        width: 80,
                        child: Stack(
                          children: [
                            CachedNetworkImage(
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                              imageUrl: _booking.salon.firstImageThumb,
                              placeholder: (context, url) => Image.asset(
                                'assets/img/loading.gif',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 80,
                              ),
                              errorWidget: (context, url, error) => Icon(Icons.photo),
                            ),
                            _booking.otpVerified==1?Image.asset(
                              'assets/icon/check.png',
                              fit: BoxFit.cover,
                              width:  80,
                              height: 80,
                            ):SizedBox(width: 0,),
                          ],
                        ),
                      ),
                    ),
                    if (_booking.payment != null)
                      Container(
                        width: 80,
                        child: Text(_booking.payment.paymentStatus?.status ?? '',
                            style: Get.textTheme.caption.merge(
                              TextStyle(fontSize: 10),
                            ),
                            maxLines: 1,
                            softWrap: false,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.fade),
                        decoration: BoxDecoration(
                          color: Get.theme.focusColor.withOpacity(0.2),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                      ),
                    /*Container(
                      width: 80,
                      child: Column(
                        children: [
                          Text(DateFormat('HH:mm', Get.locale.toString()).format(_booking.bookingAt),
                              maxLines: 1,
                              style: Get.textTheme.bodyText2.merge(
                                TextStyle(color: Get.theme.primaryColor, height: 1.4),
                              ),
                              softWrap: false,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.fade),
                          Text(DateFormat('dd', Get.locale.toString()).format(_booking.bookingAt),
                              maxLines: 1,
                              style: Get.textTheme.headline3.merge(
                                TextStyle(color: Get.theme.primaryColor, height: 1),
                              ),
                              softWrap: false,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.fade),
                          Text(DateFormat('MMM', Get.locale.toString()).format(_booking.bookingAt),
                              maxLines: 1,
                              style: Get.textTheme.bodyText2.merge(
                                TextStyle(color: Get.theme.primaryColor, height: 1),
                              ),
                              softWrap: false,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.fade),
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: _color,
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                    ),*/
                  ],
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Opacity(
                    opacity: _booking.cancel ? 0.3 : 1,
                    child: Wrap(
                      runSpacing: 10,
                      alignment: WrapAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                _booking.salon?.name ?? '',
                                style: Get.textTheme.bodyText2,
                                maxLines: 3,
                              ),
                            ),
                            BookingOptionsPopupMenuWidget(booking: _booking),
                          ],
                        ),
                        Text(_booking.bookingAt!=null?"Service Time : "+DateFormat('d, MMMM y  h:mma', Get.locale.toString()).format(_booking.bookingAt):"",
                            maxLines: 1,
                            style: Get.textTheme.subtitle1.merge(
                              TextStyle( height: 1,fontSize: 10),
                            ),
                            softWrap: false,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.fade),
                        if (_booking.employee != null)
                          Row(
                            children: [
                              Icon(
                                Icons.badge_outlined,
                                size: 18,
                                color: Get.theme.focusColor,
                              ),
                              SizedBox(width: 5),
                              Flexible(
                                child: Text(
                                  "${_booking.employee.name}(Seat ${_booking.employee.seat_no})",
                                  maxLines: 1,
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                  style: Get.textTheme.bodyText1,
                                ),
                              ),
                            ],
                          ),
                        Divider(height: 1, thickness: 1),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.call,
                              size: 18,
                              color: Get.theme.focusColor,
                            ),
                            SizedBox(width: 5),
                            Flexible(
                              child: Text(
                                "OTP - "+_booking.otp.toString(),
                                maxLines: 1,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                style: Get.textTheme.bodyText1,
                              ),
                            ),
                          ],
                        ),
                        Divider(height: 1, thickness: 1),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.design_services,
                              size: 18,
                              color: Get.theme.focusColor,
                            ),
                            SizedBox(width: 5),
                            Wrap(
                              children: _booking.eServices.map((e) {
                                  return Text(
                                    "${e.name},",
                                    maxLines: 1,
                                    overflow: TextOverflow.fade,
                                    softWrap: false,
                                    style: Get.textTheme.bodyText1,
                                  );
                              }).toList(),
                            ),

                          ],
                        ),
                        Divider(height: 8, thickness: 1),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.place_outlined,
                              size: 18,
                              color: Get.theme.focusColor,
                            ),
                            SizedBox(width: 5),
                            Flexible(
                              child: BookingAddressChipWidget(booking: _booking),
                            ),
                          ],
                        ),
                        Divider(height: 8, thickness: 1),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                "Total".tr,
                                maxLines: 1,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                style: Get.textTheme.bodyText1,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Align(
                                alignment: AlignmentDirectional.centerEnd,
                                child: Ui.getPrice(
                                  _booking.getTotal(),
                                  style: Get.textTheme.headline6.merge(TextStyle(color: _color)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
