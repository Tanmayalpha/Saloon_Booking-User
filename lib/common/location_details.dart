
import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';


class GetLocation{
  LocationData _currentPosition;

   String _address = "";
  Location location1 = Location();
  String firstLocation = "",lat = "",lng = "";
  ValueChanged onResult;

  GetLocation(this.onResult);
  Future<void> getLoc() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location1.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location1.requestService();
      if (!_serviceEnabled) {
        print('ek');
        onResult(false);
        return;
      }
    }

    _permissionGranted = await location1.hasPermission();
    print("okay1");
    if (_permissionGranted == PermissionStatus.denied) {
      print("okay2");
      _permissionGranted = await location1.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        print('no');
        onResult(false);
        return;
      }
    }else{
      _serviceEnabled = await location1.serviceEnabled();
    }
    location1.getLocation().then((LocationData currentLocation) {
      print("okay");
      _currentPosition = currentLocation;
      print(currentLocation.latitude);

      _getAddress(_currentPosition.latitude,
          _currentPosition.longitude)
          .then((value) {
        /*      print(value.first.subAdminArea);
        print(value.first.subLocality);
        print(value.first.featureName);
        print(value.first.adminArea);
        print(value.first.addressLine);*/
        firstLocation = value.first.locality;
        //  latitude = _currentPosition!.latitude!;
        //longitude = _currentPosition!.longitude!;
        onResult(value);
      });
    });
   /* location1.onLocationChanged.listen((LocationData currentLocation) {
      //print("${currentLocation.latitude} : ${currentLocation.longitude}");
      _currentPosition = currentLocation;
      //print(currentLocation.latitude);

      _getAddress(_currentPosition.latitude,
          _currentPosition.longitude)
          .then((value) {
  *//*      print(value.first.subAdminArea);
        print(value.first.subLocality);
        print(value.first.featureName);
        print(value.first.adminArea);
        print(value.first.addressLine);*//*
        firstLocation = value.first.locality;
      //  latitude = _currentPosition!.latitude!;
        //longitude = _currentPosition!.longitude!;
        onResult(value);
      });
    });*/
  }

  Future<List<Address>> _getAddress(double lat, double lang) async {
    final coordinates = new Coordinates(lat, lang);
    List<Address> add =
    await Geocoder.local.findAddressesFromCoordinates(coordinates);
    return add;
  }
}