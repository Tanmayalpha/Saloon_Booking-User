import 'package:beauty_salons_customer/app/models/salon_model.dart';
import 'package:beauty_salons_customer/app/modules/global_widgets/salon_availability_badge_widget.dart';
import 'package:beauty_salons_customer/app/modules/home/widgets/salon_thumbs_widget.dart';
import 'package:beauty_salons_customer/app/routes/app_routes.dart';
import 'package:beauty_salons_customer/common/ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/e_service_model.dart';
import '../../category/widgets/services_list_item_widget.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../../home/widgets/salon_main_thumb_widget.dart';

class SearchServicesListWidget extends StatelessWidget {
  final List<EService> services;

  SearchServicesListWidget({Key key, List<EService> this.services}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (this.services.isEmpty) {
        return CircularLoadingWidget(height: 300);
      } else {
        return ListView.builder(
          padding: EdgeInsets.only(bottom: 10, top: 10),
          primary: false,
          shrinkWrap: true,
          itemCount: services.length,
          itemBuilder: ((_, index) {
            var _service = services.elementAt(index);
            return ServicesListItemWidget(service: _service);
          }),
        );
      }
    });
  }
}
class SearchSalonListWidget extends StatelessWidget {
  final List<Salon> services;

  SearchSalonListWidget({Key key, List<Salon> this.services}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (this.services.isEmpty) {
        return CircularLoadingWidget(height: 300);
      } else {
        return ListView.builder(
          padding: EdgeInsets.only(bottom: 10, top: 10),
          primary: false,
          shrinkWrap: true,
          itemCount: services.length,
          itemBuilder: ((_, index) {
            var _service = services.elementAt(index);
            return GestureDetector(
              onTap: () {
                Get.toNamed(Routes.SALON,
                    arguments: {'salon': _service, 'heroTag': 'service_list_item'});
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
                                      style: Get.textTheme.bodyText2,
                                      maxLines: 3,
                                      // textAlign: TextAlign.end,
                                    ),
                                  ),
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
                                  style: Get.textTheme.bodyText1)
                                  : SizedBox(),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );;
          }),
        );
      }
    });
  }
}