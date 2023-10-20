/// success : true
/// data : [{"id":1,"title":"Hair Cut Offer","description":"Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer ","image":"https://saloon.developmentalphawizz.com/public/images/no-image.png","status":1,"created_at":"2022-12-19T07:12:58.000000Z","updated_at":"2022-12-19T07:12:58.000000Z"},{"id":2,"title":"Make Up Offer","description":"Make Up Offer Make Up Offer Make Up Offer Make Up Offer Make Up Offer Make Up Offer Make Up Offer Make Up Offer Make Up Offer Make Up Offer Make Up Offer Make Up Offer Make Up Offer Make Up Offer Make Up Offer Make Up Offer Make Up Offer Make Up Offer Make Up Offer Make Up Offer Make Up Offer Make Up Offer Make Up Offer Make Up Offer Make Up Offer Make Up Offer Make Up Offer Make Up Offer Make Up Offer Make Up Offer Make Up Offer Make Up Offer Make Up Offer Make Up Offer Make Up Offer Make Up Offer","image":"https://saloon.developmentalphawizz.com/public/images/no-image.png","status":1,"created_at":"2022-12-19T07:12:58.000000Z","updated_at":"2022-12-19T07:12:58.000000Z"}]
/// message : "Buzz retrieved successfully"

class BuzzModel {
  BuzzModel({
      bool success, 
      List<BuzData> data,
      String message,}){
    _success = success;
    _data = data;
    _message = message;
}

  BuzzModel.fromJson(dynamic json) {
    _success = json['success'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data.add(BuzData.fromJson(v));
      });
    }
    _message = json['message'];
  }
  bool _success;
  List<BuzData> _data;
  String _message;

  Object get id => null;

  set user(user) {}
BuzzModel copyWith({  bool success,
  List<BuzData> data,
  String message,
}) => BuzzModel(  success: success ?? _success,
  data: data ?? _data,
  message: message ?? _message,
);
  bool get success => _success;
  List<BuzData> get data => _data;
  String get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    if (_data != null) {
      map['data'] = _data.map((v) => v.toJson()).toList();
    }
    map['message'] = _message;
    return map;
  }

}

/// id : 1
/// title : "Hair Cut Offer"
/// description : "Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer Hair Cut Offer "
/// image : "https://saloon.developmentalphawizz.com/public/images/no-image.png"
/// status : 1
/// created_at : "2022-12-19T07:12:58.000000Z"
/// updated_at : "2022-12-19T07:12:58.000000Z"

class BuzData {
  int id;
  String title;
  String description;
  String image;
  bool status;
  bool hasMedia;
  List<Media> media;

  BuzData(
      {this.id,
        this.title,
        this.description,
        this.image,
        this.status,
        this.hasMedia,
        this.media});

  BuzData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    status = json['status'];
    hasMedia = json['has_media'];
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media.add(new Media.fromJson(v));
      });
    }else{
      media = [];
    }
  }
  String get firstImageUrl => this.media?.first?.url ?? '';
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['image'] = this.image;
    data['status'] = this.status;
    data['has_media'] = this.hasMedia;
    if (this.media != null) {
      data['media'] = this.media.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Media {
  int id;
  String name;
  String url;
  String formatedSize;

  Media({this.id, this.name, this.url, this.formatedSize});

  Media.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    url = json['url'];
    formatedSize = json['formated_size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['url'] = this.url;
    data['formated_size'] = this.formatedSize;
    return data;
  }
}
