
import 'package:beauty_salons_customer/app/models/media_model.dart';
import 'package:beauty_salons_customer/app/models/parents/model.dart';

class PackageModel extends Model {
  int id1;
  String name;
  int salonCategoryId;
  int salonLevelId;
  int addressId;
  String lat;
  String lng;
  String description;
  String phoneNumber;
  String mobileNumber;
  double availabilityRange;
  bool available;
  bool featured;
  bool accepted;
  List<String> customFields;
  bool hasMedia;
  int rate;
  bool closed;
  int totalReviews;
  SalonCategory salonCategory;
  List<EFeaturedServices> eFeaturedServices;
  List<Media> media;
  List<AvailabilityHours> availabilityHours;

  PackageModel(
      {this.id1,
        this.name,
        this.salonCategoryId,
        this.salonLevelId,
        this.addressId,
        this.lat,
        this.lng,
        this.description,
        this.phoneNumber,
        this.mobileNumber,
        this.availabilityRange,
        this.available,
        this.featured,
        this.accepted,
        this.customFields,
        this.hasMedia,
        this.rate,
        this.closed,
        this.totalReviews,
        this.salonCategory,
        this.eFeaturedServices,
        this.media,
        this.availabilityHours});

  PackageModel.fromJson(Map<String, dynamic> json) {
    id1 = json['id'];
    name = transStringFromJson(json, 'name');
    description = transStringFromJson(json, 'description', defaultValue: null);
    salonCategoryId = json['salon_category_id'];
    salonLevelId = json['salon_level_id'];
    addressId = json['address_id'];
    lat = json['lat'];
    lng = json['lng'];
    phoneNumber = json['phone_number'];
    mobileNumber = json['mobile_number'];
    availabilityRange = json['availability_range'];
    available = json['available'];
    featured = json['featured'];
    accepted = json['accepted'];
    if (json['custom_fields'] != null) {
      customFields = <String>[];
      json['custom_fields'].forEach((v) {
        customFields.add(v);
      });
    }
    hasMedia = json['has_media'];
    rate = json['rate'];
    closed = json['closed'];
    totalReviews = json['total_reviews'];
    salonCategory = json['salon_category'] != null?
         new SalonCategory.fromJson(json['salon_category'])
        : null;
    if (json['e_featured_services'] != null) {
      eFeaturedServices = <EFeaturedServices>[];
      json['e_featured_services'].forEach((v) {
        eFeaturedServices.add(new EFeaturedServices.fromJson(v));
      });
    }
    if (json['media'] != null) {
      media = <Null>[];
      json['media'].forEach((v) {
        media.add(new Media.fromJson(v));
      });
    }
    if (json['availability_hours'] != null) {
      availabilityHours = <AvailabilityHours>[];
      json['availability_hours'].forEach((v) {
        availabilityHours.add(new AvailabilityHours.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (name != null) data['name'] = this.name;
    if (this.description != null) data['description'] = this.description;
    data['salon_category_id'] = this.salonCategoryId;
    data['salon_level_id'] = this.salonLevelId;
    data['address_id'] = this.addressId;
    data['lat'] = this.lat;
    data['lng'] = this.lng;

    data['phone_number'] = this.phoneNumber;
    data['mobile_number'] = this.mobileNumber;
    data['availability_range'] = this.availabilityRange;
    data['available'] = this.available;
    data['featured'] = this.featured;
    data['accepted'] = this.accepted;
    if (this.customFields != null) {
      data['custom_fields'] =
          this.customFields.map((v) => v).toList();
    }
    data['has_media'] = this.hasMedia;
    data['rate'] = this.rate;
    data['closed'] = this.closed;
    data['total_reviews'] = this.totalReviews;
    if (this.salonCategory != null) {
      data['salon_category'] = this.salonCategory.toJson();
    }
    if (this.eFeaturedServices != null) {
      data['e_featured_services'] =
          this.eFeaturedServices.map((v) => v.toJson()).toList();
    }
    if (this.media != null) {
      data['media'] = this.media.map((v) => v.toJson()).toList();
    }
    if (this.availabilityHours != null) {
      data['availability_hours'] =
          this.availabilityHours.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class SalonCategory {
  int id;
  String title;
  int status;
  Null salonCategoryId;
  String createdAt;
  String updatedAt;

  SalonCategory(
      {this.id,
        this.title,
        this.status,
        this.salonCategoryId,
        this.createdAt,
        this.updatedAt});

  SalonCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    status = json['status'];
    salonCategoryId = json['salon_category_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['status'] = this.status;
    data['salon_category_id'] = this.salonCategoryId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class EFeaturedServices extends Model {
  int id1;
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

  EFeaturedServices(
      {this.id1,
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

  EFeaturedServices.fromJson(Map<String, dynamic> json) {
    id1 = json['id'];
    name = transStringFromJson(json, 'name');
    description = transStringFromJson(json, 'description', defaultValue: null);
    price = json['price'];
    discountPrice = json['discount_price'];
    duration = json['duration'];
    featured = json['featured'];
    enableBooking = json['enable_booking'];
    enableAtCustomerAddress = json['enable_at_customer_address'];
    enableAtSalon = json['enable_at_salon'];
    available = json['available'];
    salonId = json['salon_id'];
    if (json['custom_fields'] != null) {
      customFields = <String>[];
      json['custom_fields'].forEach((v) {
        customFields.add( v);
      });
    }
    hasMedia = json['has_media'];
    isFavorite = json['is_favorite'];
    if (json['media'] != null) {
      media = <Null>[];
      json['media'].forEach((v) {
        media.add(new Media.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (name != null) data['name'] = this.name;
    if (this.description != null) data['description'] = this.description;
    data['price'] = this.price;
    data['discount_price'] = this.discountPrice;
    data['duration'] = this.duration;

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

class AvailabilityHours extends Model{
  int id1;
  String day;
  String startAt;
  String endAt;
  String data;
  int salonId;
  List<String> customFields;

  AvailabilityHours(
      {this.id1,
        this.day,
        this.startAt,
        this.endAt,
        this.data,
        this.salonId,
        this.customFields});

  AvailabilityHours.fromJson(Map<String, dynamic> json) {
    id1 = json['id'];
    day = json['day'];
    startAt = json['start_at'];
    endAt = json['end_at'];
    data = transStringFromJson(json, 'data');

    salonId = json['salon_id'];
    if (json['custom_fields'] != null) {
      customFields = <String>[];
      json['custom_fields'].forEach((v) {
        customFields.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id1;
    data['day'] = this.day;
    data['start_at'] = this.startAt;
    data['end_at'] = this.endAt;
    if (this.data != null) {
      data['data'] = this.data;
    }
    data['salon_id'] = this.salonId;
    if (this.customFields != null) {
      data['custom_fields'] =
          this.customFields.map((v) => v).toList();
    }
    return data;
  }
}
