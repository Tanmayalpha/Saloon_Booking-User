/*
 * File name: payment_details_widget.dart
 * Last modified: 2022.02.11 at 18:19:29
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/booking_model.dart';
import '../../bookings/widgets/booking_row_widget.dart';

class PaymentDetailsWidget extends StatelessWidget {
  const PaymentDetailsWidget({
    Key key,
    @required Booking booking,
  })  : _booking = booking,
        super(key: key);

  final Booking _booking;

  @override
  Widget build(BuildContext context) {
    List<Widget> _paymentDetails = [
      Column(
        children: List.generate(_booking.taxes.length, (index) {
          var _tax = _booking.taxes.elementAt(index);
          return BookingRowWidget(
              description: _tax.name,
              child: Align(
                alignment: Alignment.centerRight,
                child: _tax.type == 'percent'
                    ? Text(_tax.value.toString() + '%', style: Get.textTheme.bodyText1)
                    : Ui.getPrice(
                        _tax.value,
                        style: Get.textTheme.bodyText1,
                      ),
              ),
              hasDivider: (_booking.taxes.length - 1) == index);
        }),
      ),
      BookingRowWidget(
        description: "Seat No. ".tr,
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(_booking.employee.seat_no.toString(), style: Get.textTheme.subtitle2),
        ),
        hasDivider: true,
      ),
      BookingRowWidget(
        description: "Tax Amount".tr,
        child: Align(
          alignment: Alignment.centerRight,
          child: Ui.getPrice(_booking.getTaxesValue(), style: Get.textTheme.subtitle2),
        ),
        hasDivider: false,
      ),
      BookingRowWidget(
          description: "Subtotal".tr,
          child: Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if(_booking.getDiscountSubtotal()>0)
                  Ui.getPrice(
                    _booking.getDiscountSubtotal(),
                    style: Get.textTheme.headline6.merge(
                        TextStyle(
                            color: Get.theme.focusColor,
                            decoration:
                            TextDecoration.lineThrough)),
                  ),
                Ui.getPrice(_booking.getSubtotal(), style: Get.textTheme.subtitle2),
              ],
            ),
          ),
          hasDivider: true),
      BookingRowWidget(
          description: "Booking Charges".tr,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text("Free", style: Get.textTheme.subtitle2.copyWith(
              color: Colors.green
            )),
          ),
          hasDivider: true),
      if ((_booking.coupon?.discount ?? 0) > 0)
        BookingRowWidget(
            description: "Coupon".tr,
            child: Align(
              alignment: Alignment.centerRight,
              child: Wrap(
                children: [
                  Text(' - ', style: Get.textTheme.bodyText1),
                  Ui.getPrice(_booking.getCouponValue(), style: Get.textTheme.bodyText1),
                ],
              ),
            ),
            hasDivider: true),
      BookingRowWidget(
        description: "Total Amount".tr,
        child: Align(
          alignment: Alignment.centerRight,
          child: Ui.getPrice(_booking.getTotal(), style: Get.textTheme.headline6),
        ),
      ),
    ];
    _booking.eServices.forEach((_eService) {
      var _options = _booking.options.where((option) => option.eServiceId == _eService.id);
      _paymentDetails.insert(
        0,
        Wrap(
          children: [
            BookingRowWidget(
              description: _eService.name,
              child: Align(
                alignment: Alignment.centerRight,
                child: Ui.getPrice(_eService.getPrice, style: Get.textTheme.subtitle2),
              ),
              hasDivider: true,
            ),
            Column(
              children: List.generate(_options.length, (index) {
                var _option = _options.elementAt(index);
                return BookingRowWidget(
                    description: _option.name,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Ui.getPrice(_option.price, style: Get.textTheme.bodyText1),
                    ),
                    hasDivider: (_options.length - 1) == index);
              }),
            ),
          ],
        ),
      );
    });
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: _paymentDetails,
      ),
    );
  }
}
