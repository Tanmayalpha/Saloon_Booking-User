import 'package:flutter/material.dart';

import 'e_service_model.dart';
import 'media_model.dart';
import 'parents/model.dart';

class Category extends Model {
  String id;
  String name;
  String description;
  Color color;
  Media image;
  bool featured;
  bool checked;
  List<Category> subCategories;
  List<EService> eServices;

  Category({this.id, this.name, this.description, this.color, this.image, this.featured, this.subCategories, this.eServices,this.checked});

  Category.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    name = transStringFromJson(json, 'name');
    checked = false;
    color = colorFromJson(json, 'color');
    description = transStringFromJson(json, 'description');
    image = mediaFromJson(json, 'image');
    featured = boolFromJson(json, 'featured');
    eServices = listFromJsonArray(json, ['e_services', 'featured_e_services'], (v) => EService.fromJson(v));
    subCategories = listFromJson(json, 'sub_categories', (v) => Category.fromJson(v));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['color'] = '#${this.color.value.toRadixString(16)}';
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is Category &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          color == other.color &&
          image == other.image &&
          featured == other.featured &&
          subCategories == other.subCategories &&
          eServices == other.eServices;

  @override
  int get hashCode =>
      super.hashCode ^ id.hashCode ^ name.hashCode ^ description.hashCode ^ color.hashCode ^ image.hashCode ^ featured.hashCode ^ subCategories.hashCode ^ eServices.hashCode;
}
class NewCategory extends Model{
  String id;
  String title;
  int status;
  String salonCategoryId;
  String createdAt;
  String updatedAt;

  NewCategory(
      {this.id,
        this.title,
        this.status,
        this.salonCategoryId,
        this.createdAt,
        this.updatedAt});

  NewCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    title = json['title']!=null?json['title']:json['name']!=null?transStringFromJson(json, 'name'):json['text'];
    status = json['status'];
    salonCategoryId = json['salon_category_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id.toString();
    data['title'] = this.title;
    data['status'] = this.status;
    data['salon_category_id'] = this.salonCategoryId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

