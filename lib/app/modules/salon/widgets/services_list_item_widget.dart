/*
 * File name: services_list_item_widget.dart
 * Last modified: 2022.02.11 at 18:43:34
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:beauty_salons_customer/app/routes/app_routes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/e_service_model.dart';
import '../../global_widgets/duration_chip_widget.dart';
import '../controllers/salon_e_services_controller.dart';
import '../widgets/option_group_item_widget.dart';

class ServicesListItemWidget extends GetView<SalonEServicesController> {
  const ServicesListItemWidget(
      {Key key, @required EService service, @required VoidCallback onTap})
      : _service = service,
        _onTap = onTap,
        super(key: key);
  final VoidCallback _onTap;
  final EService _service;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
     // margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: Ui.getBoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            return GestureDetector(
              onTap: () {
                controller.selectEService(_service);
              },
              child: Container(
                color: Colors.white,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Hero(
                          tag: 'salon_services_list_item' + _service.id,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: CachedNetworkImage(
                              height: 54,
                              width: 54,
                              fit: BoxFit.cover,
                              imageUrl: _service.firstImageUrl,
                              placeholder: (context, url) => Image.asset(
                                'assets/img/loading.gif',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 80,
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.add),
                            ),
                          ),
                        ),
                        Container(
                          height: 54,
                          width: 54,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Get.theme.colorScheme.secondary.withOpacity(
                                controller.isCheckedEService(_service) ? 0.8 : 0),
                          ),
                          child: Icon(
                            Icons.check,
                            size: 36,
                            color: Theme.of(context).primaryColor.withOpacity(
                                controller.isCheckedEService(_service) ? 1 : 0),
                          ),
                        ),
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
                              Text(
                                "${_service.name}(${_service.genderText})",
                                style: Get.textTheme.bodyText2.merge(TextStyle(
                                    color: controller.isCheckedEService(_service)
                                        ? Get.theme.colorScheme.secondary
                                        : Get.theme.hintColor)),
                                maxLines: 3,
                                // textAlign: TextAlign.end,
                              ),
                            ],
                          ),
                          Wrap(
                            spacing: 5,
                            children: List.generate(_service.categories.length,
                                (index) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                child: Text(
                                    _service.categories.elementAt(index).name,
                                    style: Get.textTheme.caption
                                        .merge(TextStyle(fontSize: 10))),
                                decoration: BoxDecoration(
                                    color: Get.theme.primaryColor,
                                    border: Border.all(
                                      color:
                                          Get.theme.focusColor.withOpacity(0.2),
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                              );
                            }),
                            runSpacing: 5,
                          ),
                          //Divider(height: 8, thickness: 1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              DurationChipWidget(duration: _service.duration),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  if (_service.getOldPrice > 0)
                                    Ui.getPrice(
                                      _service.getOldPrice,
                                      style: Get.textTheme.headline6.merge(
                                          TextStyle(
                                              color: Get.theme.focusColor,
                                              decoration:
                                                  TextDecoration.lineThrough)),
                                    ),
                                  Ui.getPrice(
                                    _service.getPrice,
                                    style: Get.textTheme.headline6,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
         /* InkWell(
            onTap: _onTap,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                !_service.showDesc ? "Explore" : "Hide",
                style: Get.textTheme.bodyText2.merge(TextStyle(
                    color: Get.theme.iconTheme.color,
                    decoration: TextDecoration.underline,
                    fontSize: 14.0)),
                maxLines: 3,
                // textAlign: TextAlign.end,
              ),
            ),
          ),*/
          _service.showDesc
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Ui.applyHtml(_service.description),
                )
              : SizedBox(),
          Divider(height: 24, thickness: 1),
          ListView.separated(
            padding: EdgeInsets.all(0),
            itemBuilder: (context, index) {
              return OptionGroupItemWidget(
                  optionGroup: _service.optionGroups.elementAt(index),
                  eService: _service);
            },
            separatorBuilder: (context, index) {
              return SizedBox(height: 6);
            },
            itemCount: _service.optionGroups.length,
            primary: false,
            shrinkWrap: true,
          ),
        ],
      ),
    );
  }
}

class FeaturedServicesListItemWidget extends StatelessWidget {
  FeaturedServicesListItemWidget(
      {this.service, this.salon, this.showImage = false, this.onTap});
  EService service;
  VoidCallback onTap;
  bool showImage;
  var salon;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: Ui.getBoxDecoration(),
      child: Column(
        children: [
          Obx(() {
            return GestureDetector(
              onTap: () {
                Get.toNamed(Routes.SALON, arguments: {
                  'salon': salon,
                  'heroTag': 'service_list_item',
                  'service': service
                });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      !showImage
                          ? Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                Hero(
                                  tag: 'salon_services_list_item' + service.id,
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    child: CachedNetworkImage(
                                      height: 54,
                                      width: 54,
                                      fit: BoxFit.cover,
                                      imageUrl: service.firstImageUrl,
                                      placeholder: (context, url) =>
                                          Image.asset(
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
                                Container(
                                  height: 54,
                                  width: 54,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    color: Get.theme.colorScheme.secondary
                                        .withOpacity(0),
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    size: 36,
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0),
                                  ),
                                ),
                              ],
                            )
                          : SizedBox(),
                      SizedBox(width: !showImage ? 12 : 0),
                      Expanded(
                        child: Wrap(
                          runSpacing: 10,
                          alignment: WrapAlignment.start,
                          children: <Widget>[
                            Row(
                              children: [
                                Text(
                                  service.name ?? '',
                                  style: Get.textTheme.bodyText2.merge(
                                      TextStyle(color: Get.theme.hintColor)),
                                  maxLines: 3,
                                  // textAlign: TextAlign.end,
                                ),
                              ],
                            ),
                            Wrap(
                              spacing: 5,
                              children: List.generate(service.categories.length,
                                  (index) {
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  child: Text(
                                      service.categories.elementAt(index).name,
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
                            ),
                            Divider(height: 8, thickness: 1),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                DurationChipWidget(duration: service.duration),
                                if (service.getOldPrice > 0)
                                  Ui.getPrice(
                                    service.getOldPrice,
                                    style: Get.textTheme.bodyMedium.merge(
                                        TextStyle(
                                            color: Get.theme.focusColor,
                                            decoration:
                                                TextDecoration.lineThrough)),
                                  ),
                                Ui.getPrice(
                                  service.getPrice,
                                  style: Get.textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: onTap,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        !service.showDesc ? "Explore" : "Hide",
                        style: Get.textTheme.bodyText2.merge(TextStyle(
                            color: Get.theme.iconTheme.color,
                            fontSize: 14.0,
                            decoration: TextDecoration.underline)),
                        maxLines: 3,
                        // textAlign: TextAlign.end,
                      ),
                    ),
                  ),
                  service.showDesc
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Ui.applyHtml(service.description),
                        )
                      : SizedBox(),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
