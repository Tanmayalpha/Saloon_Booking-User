/*
 * File name: maps_controller.dart
 * Last modified: 2022.02.26 at 14:50:11
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:beauty_salons_customer/app/services/auth_service.dart';
import 'package:beauty_salons_customer/common/location_details.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as LocationPlatformInterface;

import '../../../../common/ui.dart';
import '../../../models/address_model.dart';
import '../../../models/salon_model.dart';
import '../../../repositories/salon_repository.dart';
import '../../../services/settings_service.dart';

class MapsController extends GetxController {
  final salons = <Salon>[].obs;
  final allMarkers = <Marker>[].obs;
  TextEditingController searchController = new TextEditingController();
  final cameraPosition = new CameraPosition(
          target: LatLng(18.52189077471387, 73.85588410330736), zoom: 12)
      .obs;
  CarouselController carouselController = CarouselController();

  final mapController = Rx<GoogleMapController>(null);
  LocationPlatformInterface.Location location =
      new LocationPlatformInterface.Location();
  LocationPlatformInterface.PermissionStatus permissionGranted =
      LocationPlatformInterface.PermissionStatus.denied;
  bool isLocationServiceEnabled = false;
  SalonRepository _salonRepository;
  MapsController() {
    _salonRepository = new SalonRepository();
  }

  Address get currentAddress => Get.find<SettingsService>().address.value;

  @override
  void onInit() async {
    var arguments = Get.arguments as Map<String, dynamic>;
    getLocation();
    if (arguments['salons'] != null) {
      salons.value = arguments['salons'] as List<Salon>;
    }

    final Uint8List markerIcon =
        await _getBytesFromAsset('assets/img/marker.png', 120);
    if (salons != null && salons.isNotEmpty) {
      salons.forEach((element) {
        var salonMarket = getSalonMarker(element, markerIcon);
        if (element.address != null) {
          allMarkers.add(salonMarket);
        }
      });
      await Future.delayed(Duration(seconds: 1));
      if (salons[0].address != null && mapController != null) {
        mapController.value.animateCamera(
            CameraUpdate.newLatLngZoom(salons[0].address.getLatLng(), 12));
        mapController.value.showMarkerInfoWindow(MarkerId(salons[0].id));
      }
    }

    await refreshMaps();
    super.onInit();
  }

  Future refreshMaps({bool showMessage = false}) async {
    await getCurrentPosition();
    if (showMessage) {
      Get.showSnackbar(
          Ui.SuccessSnackBar(message: "Home page refreshed successfully".tr));
    }
  }

  getLocation() {
    GetLocation getLocation = new GetLocation((value) {
      Get.find<SettingsService>().address.update((val) {
        val.description = value.first.locality;
        val.address = value.first.addressLine;
        val.latitude = value.first.coordinates.latitude;
        val.longitude = value.first.coordinates.longitude;
        val.userId = Get.find<AuthService>().user.value.id;
      });
    });
    getLocation.getLoc();
  }

  Future<void> getCurrentPosition() async {
    cameraPosition.value = CameraPosition(
      target: currentAddress.getLatLng(),
      zoom: 12.4746,
    );
    Marker marker = await _getMyPositionMarker(currentAddress.getLatLng());
    allMarkers.add(marker);
  }

  Future getNearSalons({LatLng latLng}) async {
    try {
      final Uint8List markerIcon =
          await _getBytesFromAsset('assets/img/marker.png', 120);
      salons.clear();
      salons.assignAll(await _salonRepository.getNearSalons(
          latLng ?? currentAddress.getLatLng(), cameraPosition.value.target));
      salons.forEach((element) {
        var salonMarket = getSalonMarker(element, markerIcon);
        allMarkers.add(salonMarket);
      });
      if (salons.isNotEmpty) {
        await Future.delayed(Duration(seconds: 1));
        if (salons[0].address != null) {
          mapController.value.showMarkerInfoWindow(MarkerId(salons[0].id));
          mapController.value.animateCamera(
              CameraUpdate.newLatLngZoom(salons[0].address.getLatLng(), 12));
        }
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.message));
    }
  }

  Future<Uint8List> _getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  Future<Marker> _getMyPositionMarker(LatLng latLng) async {
    final Uint8List markerIcon =
        await _getBytesFromAsset('assets/img/my_marker.png', 120);
    final Marker marker = Marker(
        markerId: MarkerId(Random().nextInt(100).toString()),
        icon: BitmapDescriptor.fromBytes(markerIcon),
        anchor: ui.Offset(0.5, 0.5),
        position: latLng);

    return marker;
  }

  Marker getSalonMarker(Salon salon, markerIcon) {
    final Marker marker = Marker(
      markerId: MarkerId(salon.id),
      icon: BitmapDescriptor.fromBytes(markerIcon),
      onTap: () {
        int index = salons.indexWhere((element) => element.id == salon.id);
        if (index != -1) {
          carouselController.animateToPage(index);
        }
      },
      anchor: ui.Offset(0.5, 0.5),
      infoWindow: InfoWindow(
          title: salon.name,
          snippet: Ui.getDistance(salon.distance),
          onTap: () {
            //print(CustomTrace(StackTrace.current, message: 'Info Window'));
          }),
      position: salon.address.getLatLng(),
    );

    return marker;
  }
}
