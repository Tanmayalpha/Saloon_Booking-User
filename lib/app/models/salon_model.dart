/*
 * File name: salon_model.dart
 * Last modified: 2022.02.16 at 22:12:52
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'dart:core';

import 'package:beauty_salons_customer/app/models/e_service_model.dart';

import 'address_model.dart';
import 'availability_hour_model.dart';
import 'media_model.dart';
import 'parents/model.dart';
import 'review_model.dart';
import 'salon_level_model.dart';
import 'tax_model.dart';
import 'user_model.dart';

class Salon extends Model {
  String id;
  String name;
  String offer_percent;
  String closed_message;
  String salonType;
  String description;
  List<Media> images;
  String phoneNumber;
  String mobileNumber;
  SalonLevel salonLevel;
  List<AvailabilityHour> availabilityHours;
  double availabilityRange;
  double distance;
  bool closed;
  bool featured;
  Address address;
  List<Tax> taxes;
  List<EService> eService;
  List<User> employees;
  double rate;
  List<Review> reviews;
  List<AmenitiesModel> amenities;
  int totalReviews;
  bool verified;
  bool isFavorites;

  Salon(
      {this.id,
      this.name,
        this.offer_percent,
      this.description,
        this.salonType,
        this.closed_message,
      this.images,
        this.isFavorites,
      this.phoneNumber,
      this.mobileNumber,
      this.salonLevel,
      this.availabilityHours,
      this.availabilityRange,
      this.distance,
      this.closed,
      this.featured,
      this.address,
      this.employees,
      this.rate,
      this.reviews,
      this.totalReviews,
        this.eService,
      this.verified});

  Salon.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    name = transStringFromJson(json, 'name');
    closed_message = stringFromJson(json, 'closed_message');
    offer_percent = stringFromJson(json, 'offer_percent');
    salonType = stringFromJson(json, 'salon_type');
    description = transStringFromJson(json, 'description', defaultValue: null);
    images = mediaListFromJson(json, 'images');
    phoneNumber = stringFromJson(json, 'phone_number');
    mobileNumber = stringFromJson(json, 'mobile_number');
    salonLevel = objectFromJson(json, 'salon_level', (v) => SalonLevel.fromJson(v));
    availabilityHours = listFromJson(json, 'availability_hours', (v) => AvailabilityHour.fromJson(v));
    availabilityRange = doubleFromJson(json, 'availability_range');
    distance = doubleFromJson(json, 'distance');
    closed = boolFromJson(json, 'closed');
    featured = boolFromJson(json, 'featured');
    isFavorites = boolFromJson(json, 'is_favorite');
    address = objectFromJson(json, 'address', (v) => Address.fromJson(v));
    taxes = listFromJson(json, 'taxes', (v) => Tax.fromJson(v));
    employees = listFromJson(json, 'users', (v) => User.fromJson(v));
    rate = doubleFromJson(json, 'rate');
    reviews = listFromJson(json, 'salon_reviews', (v) => Review.fromJson(v));
    amenities = listFromJson(json, 'amenities', (v) => AmenitiesModel.fromJson(v));
    eService  = json['e_services']!=null?
    listFromJson(json, 'e_services', (v) => EService.fromJson(v)):
    listFromJson(json, 'e_featured_services', (v) => EService.fromJson(v));
    totalReviews = reviews.isEmpty ? intFromJson(json, 'total_reviews') : reviews.length;
    verified = boolFromJson(json, 'verified');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['closed'] = this.closed;
    data['phone_number'] = this.phoneNumber;
    data['mobile_number'] = this.mobileNumber;
    data['rate'] = this.rate;
    data['total_reviews'] = this.totalReviews;
    data['verified'] = this.verified;
    data['distance'] = this.distance;
    return data;
  }

  String get firstImageUrl => this.images?.first?.url ?? '';

  String get firstImageThumb => this.images?.first?.thumb ?? '';

  String get firstImageIcon => this.images?.first?.icon ?? '';

  @override
  bool get hasData {
    return id != null && name != null;
  }
  Map<String, List<AvailabilityHour>> groupedAvailabilityHours() {
    Map<String, List<AvailabilityHour>> result = {};
    this.availabilityHours.forEach((element) {
      if (result.containsKey(element.day)) {
        result[element.day].add(element);
      } else {
        result[element.day] = [element];
      }
    });
    return result;
  }
  // Map<String, List<String>> groupedAvailabilityHours() {
  //   Map<String, List<String>> result = {};
  //   this.availabilityHours.forEach((element) {
  //     if (result.containsKey(element.day)) {
  //       result[element.day].add(element.startAt + ' - ' + element.endAt);
  //     } else {
  //       result[element.day] = [element.startAt + ' - ' + element.endAt];
  //     }
  //   });
  //   return result;
  // }

  List<String> getAvailabilityHoursData(String day) {
    List<String> result = [];
    this.availabilityHours.forEach((element) {
      if (element.day == day) {
        result.add(element.data);
      }
    });
    return result;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is Salon &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          images == other.images &&
          phoneNumber == other.phoneNumber &&
          mobileNumber == other.mobileNumber &&
          salonLevel == other.salonLevel &&
          availabilityRange == other.availabilityRange &&
          distance == other.distance &&
          closed == other.closed &&
          featured == other.featured &&
          address == other.address &&
          rate == other.rate &&
          reviews == other.reviews &&
          totalReviews == other.totalReviews &&
          verified == other.verified;

  @override
  int get hashCode =>
      super.hashCode ^
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      images.hashCode ^
      phoneNumber.hashCode ^
      mobileNumber.hashCode ^
      salonLevel.hashCode ^
      availabilityRange.hashCode ^
      distance.hashCode ^
      closed.hashCode ^
      featured.hashCode ^
      address.hashCode ^
      rate.hashCode ^
      reviews.hashCode ^
      totalReviews.hashCode ^
      verified.hashCode;
}
class AmenitiesModel {
  int id;
  String text;
  int salonId;
  String createdAt;
  String updatedAt;

  AmenitiesModel(
      {this.id, this.text, this.salonId, this.createdAt, this.updatedAt});

  AmenitiesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    salonId = json['salon_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['text'] = this.text;
    data['salon_id'] = this.salonId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class EFeaturedServiceModel extends Model{
  String id;
  String name;
  double price;
  double discountPrice;
  String duration;
  String description;
  bool featured;
  bool enableBooking;
  bool enableAtCustomerAddress;
  bool enableAtSalon;
  bool available;
  int salonId;
  List<String> customFields;
  bool hasMedia;
  bool isFavorite;
  List<Media> media;

  EFeaturedServiceModel(
      {this.id,
        this.name,
        this.price,
        this.discountPrice,
        this.duration,
        this.description,
        this.featured,
        this.enableBooking,
        this.enableAtCustomerAddress,
        this.enableAtSalon,
        this.available,
        this.salonId,
        this.customFields,
        this.hasMedia,
        this.isFavorite,
        this.media});

  EFeaturedServiceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = transStringFromJson(json, 'name');
    description = transStringFromJson(json, 'description', defaultValue: null);
    price = doubleFromJson(json, 'price');

    discountPrice = doubleFromJson(json, 'discount_price');
    duration = json['duration'];
    featured = json['featured'];
    enableBooking = json['enable_booking'] is int?json['enable_booking']==1?true:false:json['enable_booking'];
    enableAtCustomerAddress = json['enable_at_customer_address'] is int?json['enable_at_customer_address']==1?true:false:json['enable_at_customer_address'];
    enableAtSalon =  json['enable_at_salon'] is int?json['enable_at_salon']==1?true:false:json['enable_at_salon'];
  //  enableAtCustomerAddress = json['enable_at_customer_address'];
 //   enableAtSalon = json['enable_at_salon'];
    available = json['available'];
    salonId = json['salon_id'];
    if (json['custom_fields'] != null) {
      customFields = <String>[];
      json['custom_fields'].forEach((v) {
        customFields.add(v);
      });
    }
    hasMedia = json['has_media'];
    isFavorite = json['is_favorite'];
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media.add(new Media.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.name != null) {
      data['name'] = this.name;
    }
    data['price'] = this.price;
    data['discount_price'] = this.discountPrice;
    data['duration'] = this.duration;
    if (this.description != null) {
      data['description'] = this.description;
    }
    data['featured'] = this.featured;
    data['enable_booking'] = this.enableBooking;
    data['enable_at_customer_address'] = this.enableAtCustomerAddress;
    data['enable_at_salon'] = this.enableAtSalon;
    data['available'] = this.available;
    data['salon_id'] = this.salonId;
    if (this.customFields != null) {
      data['custom_fields'] =
          this.customFields.map((v) => v).toList();
    }
    data['has_media'] = this.hasMedia;
    data['is_favorite'] = this.isFavorite;
    if (this.media != null) {
      data['media'] = this.media.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


