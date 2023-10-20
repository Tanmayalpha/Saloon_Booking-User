/*
 * File name: maps_view.dart
 * Last modified: 2022.02.26 at 14:50:11
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:beauty_salons_customer/app/services/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

import '../../../../common/ui.dart';
import '../controllers/maps_controller.dart';
import '../widgets/maps_carousel_widget.dart';

class MapsView extends GetView<MapsController> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "Maps Explorer".tr,
            style: Get.textTheme.headline6,
            textAlign: TextAlign.center,
          ),
          leading: IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
            onPressed: () => Get.back(),
          ),
         /* actions: [IconButton(
            icon: new Icon(Icons.search, color: Get.theme.hintColor),
            onPressed: ()async{

            },
          ),],*/
        ),
        body: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            Obx(() {
              return GoogleMap(
                mapToolbarEnabled: false,
                zoomControlsEnabled: true,
                zoomGesturesEnabled: true,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                padding: EdgeInsets.only(top: 10),
                mapType: MapType.normal,
                initialCameraPosition: controller.cameraPosition.value,
                markers: Set.from(controller.allMarkers),
                onMapCreated: (GoogleMapController _controller) {
                  controller.mapController.value = _controller;
                },
                onCameraMoveStarted: () {
                 // controller.salons.clear();
                },
                onCameraMove: (CameraPosition cameraPosition) {
                  controller.cameraPosition.value = cameraPosition;
                },
                onCameraIdle: () {
                  if(controller.salons.isEmpty){
                    controller.getNearSalons();
                  }
                },
              );
            }),

            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: placesAutoCompleteTextField(),
                ),
                MapsCarouselWidget(),
              ],
            ),

            // Container(
            //   margin: EdgeInsetsDirectional.only(end: 50),
            //   height: 120,
            //   child: Row(
            //     children: [
            //       new IconButton(
            //         icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
            //         onPressed: () => Get.back(),
            //       ),
            //       Expanded(
            //         child: Text(
            //           "Maps Explorer".tr,
            //           style: Get.textTheme.headline6,
            //           textAlign: TextAlign.center,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
  Widget placesAutoCompleteTextField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: GooglePlaceAutoCompleteTextField(

        textEditingController: controller.searchController,
        googleAPIKey: Get.find<SettingsService>().setting.value.googleMapsKey,
        inputDecoration: InputDecoration(
          hintText: "Search your location",
          border: InputBorder.none,

          filled: true,
          fillColor: Colors.white,
          enabledBorder: InputBorder.none,
        ),
        debounceTime: 400,
        countries: ["in"],
        boxDecoration: Ui.getBoxDecoration(),
        isLatLngRequired: true,
        getPlaceDetailWithLatLng: (Prediction prediction) {
          print("placeDetails" + prediction.lat.toString());
          print("placeDetails" + prediction.lng.toString());
          controller.getNearSalons(latLng: LatLng(double.parse(prediction.lat),double.parse(prediction.lng)));

        },
        itemClick: (Prediction prediction) {
          controller.searchController.text = prediction.description ?? "";

          controller.searchController.selection = TextSelection.fromPosition(
              TextPosition(offset: prediction.description?.length ?? 0));
          print("#${prediction.lat},${prediction.lng}");

        },
        seperatedBuilder: Divider(),
        // OPTIONAL// If you want to customize list view item builder
        itemBuilder: (context, index, Prediction prediction) {
          return Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Icon(Icons.location_on),
                SizedBox(
                  width: 7,
                ),
                Expanded(child: Text("${prediction.description??""}"))
              ],
            ),
          );
        },

        isCrossBtnShown: true,

        // default 600 ms ,
      ),
    );
  }
}
