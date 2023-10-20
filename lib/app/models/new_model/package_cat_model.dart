import 'package:beauty_salons_customer/app/models/category_model.dart';

import '../parents/model.dart';

class PackageCatModel extends Model {
  String id;
  String name;
  List<Category> category;

  PackageCatModel({this.id, this.name, this.category});

  PackageCatModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'] is Map? transStringFromJson(json, 'name'):json['name'];
    if (json['category'] != null) {
      category = <Category>[];
      json['category'].forEach((v) {
        category.add(new Category.fromJson(v));
      });
    }
    if (json['sub_categories'] != null) {
      category = <Category>[];
      json['sub_categories'].forEach((v) {
        category.add(new Category.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.category != null) {
      data['category'] = this.category.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

/*class Category extends Model{
  int catId;
  String name;
  String color;
  String description;
  Null order;
  bool featured;
  int parentId;
  int isPackage;
  int selectedGender;
  List<Null> customFields;
  bool hasMedia;
  List<Null> media;

  Category(
      {this.catId,
        this.name,
        this.color,
        this.description,
        this.order,
        this.featured,
        this.parentId,
        this.isPackage,
        this.selectedGender,
        this.customFields,
        this.hasMedia,
        this.media});

  Category.fromJson(Map<String, dynamic> json) {
    catId = json['id'];
    name = json['name'] != null?  transStringFromJson(json, 'name') : null;
    color = json['color'];
    description = json['description'] != null
        ? transStringFromJson(json, 'description')
        : null;
    order = json['order'];
    featured = json['featured'];
    parentId = json['parent_id'];
    isPackage = json['is_package'];
    selectedGender = json['selected_gender'];
    if (json['custom_fields'] != null) {
      customFields = [];
      json['custom_fields'].forEach((v) {
        customFields.add(v);
      });
    }
    hasMedia = json['has_media'];
    if (json['media'] != null) {
      media = [];
      json['media'].forEach((v) {
        media.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.name != null) {
      data['name'] = this.name;
    }
    data['color'] = this.color;
    if (this.description != null) {
      data['description'] = this.description;
    }
    data['order'] = this.order;
    data['featured'] = this.featured;
    data['parent_id'] = this.parentId;
    data['is_package'] = this.isPackage;
    data['selected_gender'] = this.selectedGender;
    if (this.customFields != null) {
      data['custom_fields'] =
          this.customFields.map((v) => v).toList();
    }
    data['has_media'] = this.hasMedia;
    if (this.media != null) {
      data['media'] = this.media.map((v) => v).toList();
    }
    return data;
  }
}*/

