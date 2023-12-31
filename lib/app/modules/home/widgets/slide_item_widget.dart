/*
 * File name: slide_item_widget.dart
 * Last modified: 2022.02.04 at 18:23:47
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/slide_model.dart';
import '../../../routes/app_routes.dart';

class SlideItemWidget extends StatelessWidget {
  final Slide slide;

  const SlideItemWidget({
    this.slide,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(
              Directionality.of(context) == TextDirection.rtl ? math.pi : 0),
          child: CachedNetworkImage(
            width: double.infinity,
            height: 310,
            fit: Ui.getBoxFit(slide.imageFit),
            imageUrl: slide.image.url,
            placeholder: (context, url) => Image.asset(
              'assets/img/loading.gif',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            errorWidget: (context, url, error) => Icon(Icons.photo),
          ),
        ),
        Container(
            alignment: Ui.getAlignmentDirectional(slide.textPosition),
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 85, horizontal: 20),
            child: SizedBox(
              width: Get.width / 2.5,
              child: Column(
                children: [
                  if (slide.text != null && slide.text != '')
                    Text(
                      slide.text,
                      style: Get.textTheme.bodyText2
                          .merge(TextStyle(color: slide.textColor)),
                      overflow: TextOverflow.fade,
                      maxLines: 3,
                    ),
                  if (slide.button != null && slide.button != '')
                    MaterialButton(
                      onPressed: () {

                        //return;
                        if (slide.salon != null) {
                          Get.toNamed(Routes.SALON, arguments: {
                            'salon': slide.salon,
                            'heroTag': 'salon_slide_item'
                          });
                        } else if (slide.eService != null) {
                          Get.toNamed(Routes.E_SERVICE, arguments: {
                            'eService': slide.eService,
                            'heroTag': 'slide_item'
                          });
                        }else{
                          Get.toNamed(Routes.DETAIL, arguments: "Near By");
                        }
                      },
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                      color: slide.buttonColor,
                      shape: StadiumBorder(),
                      child: Text(
                        slide.button,
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Get.theme.primaryColor),
                      ),
                      elevation: 0,
                    ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment:
                    Ui.getCrossAxisAlignment(slide.textPosition),
              ),
            )),
      ],
    );
  }
}
