import 'salon_model.dart';

class FavoriteSalonModel {
  int id;
  int salonId;
  int userId;
  String createdAt;
  String updatedAt;
  List<String> customFields;
  List<String> options;
  List<Salon> salons;

  FavoriteSalonModel(
      {this.id,
        this.salonId,
        this.userId,
        this.createdAt,
        this.updatedAt,
        this.customFields,
        this.options,
        this.salons});

  FavoriteSalonModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    salonId = json['salon_id'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['custom_fields'] != null) {
      customFields = <String>[];
      json['custom_fields'].forEach((v) {
        customFields.add(v);
      });
    }
    if (json['options'] != null) {
      options = <Null>[];
      json['options'].forEach((v) {
        options.add(v);
      });
    }
    if (json['salons'] != null) {
      salons = <Salon>[];
      json['salons'].forEach((v) {
        salons.add(new Salon.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['salon_id'] = this.salonId;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.customFields != null) {
      data['custom_fields'] =
          this.customFields.map((v) => v).toList();
    }
    if (this.options != null) {
      data['options'] = this.options.map((v) => v).toList();
    }
    if (this.salons != null) {
      data['salons'] = this.salons.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

