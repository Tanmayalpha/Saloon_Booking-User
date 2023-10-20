/*
 * File name: services_list_item_widget.dart
 * Last modified: 2022.02.14 at 11:09:50
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:beauty_salons_customer/app/models/salon_model.dart';
import 'package:beauty_salons_customer/app/modules/details/controllers/detail_controller.dart';
import 'package:beauty_salons_customer/app/modules/salon/widgets/services_list_item_widget.dart';
import 'package:beauty_salons_customer/app/services/auth_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/e_service_model.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/duration_chip_widget.dart';
import '../../global_widgets/salon_availability_badge_widget.dart';

class SalonListItemWidget extends GetView<DetailController> {
  SalonListItemWidget({
    Key key,
    @required this.value,
    @required Salon service,
  })  : _service = service,
        super(key: key);

  final Salon _service;
  final String value;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.SALON,
            arguments: {'salon': _service, 'heroTag': 'service_list_item','offer':value=='Offers'?"1":"0"});
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
                Column(
                  children: [
                    Hero(
                      tag: 'service_list_item' + _service.id,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        child: CachedNetworkImage(
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                          imageUrl: _service.firstImageUrl,
                          placeholder: (context, url) => Image.asset(
                            'assets/img/loading.gif',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 80,
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.photo),
                        ),
                      ),
                    ),
                    _service.offer_percent != "" &&
                            _service.offer_percent != null
                        ? Container(
                            color: Get.theme.colorScheme.secondary,
                            padding: EdgeInsets.all(5.0),
                            width: 80,
                            child: Text(
                              "${_service.offer_percent}% OFF",
                              textAlign: TextAlign.center,
                              style: Get.textTheme.bodyText2
                                  .copyWith(color: Get.theme.primaryColor),
                              maxLines: 3,
                              // textAlign: TextAlign.end,
                            ),
                          )
                        : SizedBox(),
                    SalonAvailabilityBadgeWidget(
                        salon: _service, withImage: true),
                    SizedBox(height: 20),
                  ],
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Wrap(
                    runSpacing: 10,
                    alignment: WrapAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _service.name ?? '',
                              style: Get.textTheme.headline5,
                              maxLines: 3,
                              // textAlign: TextAlign.end,
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                if(Get.find<AuthService>().isAuth){
                                  controller.addFav(
                                      _service.isFavorites, _service.id);
                                }else{
                                  Get.showSnackbar(Ui.ErrorSnackBar(message: "Please login first"));
                                }
                              },
                              child: Icon(
                                _service.isFavorites
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: _service.isFavorites
                                    ? Colors.red
                                    : Colors.grey,
                                size: 32.0,
                              ))
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.end,
                              children: List.from(
                                  Ui.getStarsList(_service.rate ?? 0, size: 10))
                                ..addAll([
                                  SizedBox(width: 5),
                                  Text(
                                    "Reviews (%s)".trArgs(
                                        [_service.totalReviews.toString()]),
                                    style: Get.textTheme.caption,
                                  ),
                                ]),
                            ),
                          ),
                          Text(
                            Ui.getDistance(_service.distance),
                            style: Get.textTheme.caption,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              Ui.filterData(_service),
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              style: Get.textTheme.bodyText1,
                            ),
                          ),
                        ],
                      ),
                      //   Ui.applyHtml(_service.description, style: Get.textTheme.bodyText1),
                      Divider(height: 8, thickness: 1),
                      _service.address != null
                          ? Ui.applyHtml(_service.address.address.tr,
                              style: Get.textTheme.bodyText1.copyWith(
                                fontWeight: FontWeight.w500,fontSize: 10
                              ))
                          : SizedBox(),
                      Divider(height: 8, thickness: 1),
                      value == ""
                          ? Wrap(
                              spacing: 5,
                              children: List.generate(
                                  _service.availabilityHours.length, (index) {
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  child: Text(
                                      _service.availabilityHours
                                          .elementAt(index)
                                          .day,
                                      style: Get.textTheme.caption
                                          .merge(TextStyle(fontSize: 10))),
                                  decoration: BoxDecoration(
                                      color: Get.theme.primaryColor,
                                      border: Border.all(
                                        color: Get.theme.focusColor
                                            .withOpacity(0.2),
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                );
                              }),
                              runSpacing: 5,
                            )
                          : SizedBox()
                    ],
                  ),
                ),
              ],
            ),
            controller.name.value == "Top Brands"
                ? SizedBox()
                : _service.eService != null && _service.eService.length > 0
                    ? Wrap(
                        spacing: 5,
                        children:
                            List.generate(_service.eService.length>1?1:_service.eService.length, (index) {
                          var service = _service.eService.elementAt(index);
                          return FeaturedServicesListItemWidget(
                            service: service,
                            salon: _service,
                            onTap: () {
                              int index = controller.eSalon.indexWhere(
                                  (element) => element.id == _service.id);
                              int indexE = controller.eSalon.value
                                  .elementAt(index)
                                  .eService
                                  .indexWhere(
                                      (element) => element.id == service.id);
                              if (index != -1 && indexE != -1) {
                                controller.eSalon
                                        .elementAt(index)
                                        .eService
                                        .elementAt(indexE)
                                        .showDesc =
                                    !controller.eSalon
                                        .elementAt(index)
                                        .eService
                                        .elementAt(indexE)
                                        .showDesc;
                                controller.eSalon.refresh();
                              }
                            },
                            showImage: true,
                          );
                        }),
                        runSpacing: 5,
                      )
                    : SizedBox(),
          ],
        ),
      ),
    );
  }
}
