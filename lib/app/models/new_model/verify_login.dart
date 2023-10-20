/// success : true
/// data : {"id":1,"name":"Hyatt Zimmerman","email":"admin@demo.com","phone_number":"12348996321","phone_verified_at":"2022-01-10T11:52:10.000000Z","email_verified_at":"2022-01-10T11:52:10.000000Z","api_token":"PivvPlsQWxPl1bB5KrbKNBuraJit0PrUZekQUgtLyTRuyBq921atFtoR1HuA","device_token":"","otp":3032,"created_at":null,"updated_at":"2022-12-14T09:43:14.000000Z","custom_fields":{"bio":{"value":"Consequatur error ip.&nbsp;","view":"Consequatur error ip.&nbsp;","name":"bio"},"address":{"value":"Qui vero ratione vel","view":"Qui vero ratione vel","name":"address"}},"has_media":false,"media":[]}
/// message : "User retrieved successfully"

class VerifyLogin {
  VerifyLogin({
      bool success, 
      Data data, 
      String message,}){
    _success = success;
    _data = data;
    _message = message;
}

  VerifyLogin.fromJson(dynamic json) {
    _success = json['success'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
    _message = json['message'];
  }
  bool _success;
  Data _data;
  String _message;
VerifyLogin copyWith({  bool success,
  Data data,
  String message,
}) => VerifyLogin(  success: success ?? _success,
  data: data ?? _data,
  message: message ?? _message,
);
  bool get success => _success;
  Data get data => _data;
  String get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    if (_data != null) {
      map['data'] = _data.toJson();
    }
    map['message'] = _message;
    return map;
  }

}

/// id : 1
/// name : "Hyatt Zimmerman"
/// email : "admin@demo.com"
/// phone_number : "12348996321"
/// phone_verified_at : "2022-01-10T11:52:10.000000Z"
/// email_verified_at : "2022-01-10T11:52:10.000000Z"
/// api_token : "PivvPlsQWxPl1bB5KrbKNBuraJit0PrUZekQUgtLyTRuyBq921atFtoR1HuA"
/// device_token : ""
/// otp : 3032
/// created_at : null
/// updated_at : "2022-12-14T09:43:14.000000Z"
/// custom_fields : {"bio":{"value":"Consequatur error ip.&nbsp;","view":"Consequatur error ip.&nbsp;","name":"bio"},"address":{"value":"Qui vero ratione vel","view":"Qui vero ratione vel","name":"address"}}
/// has_media : false
/// media : []

class Data {
  Data({
      num id, 
      String name, 
      String email, 
      String phoneNumber, 
      String phoneVerifiedAt, 
      String emailVerifiedAt, 
      String apiToken, 
      String deviceToken, 
      num otp, 
      dynamic createdAt, 
      String updatedAt, 
      CustomFields customFields, 
      bool hasMedia, 
      List<dynamic> media,}){
    _id = id;
    _name = name;
    _email = email;
    _phoneNumber = phoneNumber;
    _phoneVerifiedAt = phoneVerifiedAt;
    _emailVerifiedAt = emailVerifiedAt;
    _apiToken = apiToken;
    _deviceToken = deviceToken;
    _otp = otp;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _customFields = customFields;
    _hasMedia = hasMedia;
    _media = media;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _email = json['email'];
    _phoneNumber = json['phone_number'];
    _phoneVerifiedAt = json['phone_verified_at'];
    _emailVerifiedAt = json['email_verified_at'];
    _apiToken = json['api_token'];
    _deviceToken = json['device_token'];
    _otp = json['otp'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _customFields = json['custom_fields'] != null ? CustomFields.fromJson(json['custom_fields']) : null;
    _hasMedia = json['has_media'];
    if (json['media'] != null) {
      _media = [];
      json['media'].forEach((v) {
        _media.add(v.fromJson(v));
      });
    }
  }
  num _id;
  String _name;
  String _email;
  String _phoneNumber;
  String _phoneVerifiedAt;
  String _emailVerifiedAt;
  String _apiToken;
  String _deviceToken;
  num _otp;
  dynamic _createdAt;
  String _updatedAt;
  CustomFields _customFields;
  bool _hasMedia;
  List<dynamic> _media;
Data copyWith({  num id,
  String name,
  String email,
  String phoneNumber,
  String phoneVerifiedAt,
  String emailVerifiedAt,
  String apiToken,
  String deviceToken,
  num otp,
  dynamic createdAt,
  String updatedAt,
  CustomFields customFields,
  bool hasMedia,
  List<dynamic> media,
}) => Data(  id: id ?? _id,
  name: name ?? _name,
  email: email ?? _email,
  phoneNumber: phoneNumber ?? _phoneNumber,
  phoneVerifiedAt: phoneVerifiedAt ?? _phoneVerifiedAt,
  emailVerifiedAt: emailVerifiedAt ?? _emailVerifiedAt,
  apiToken: apiToken ?? _apiToken,
  deviceToken: deviceToken ?? _deviceToken,
  otp: otp ?? _otp,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  customFields: customFields ?? _customFields,
  hasMedia: hasMedia ?? _hasMedia,
  media: media ?? _media,
);
  num get id => _id;
  String get name => _name;
  String get email => _email;
  String get phoneNumber => _phoneNumber;
  String get phoneVerifiedAt => _phoneVerifiedAt;
  String get emailVerifiedAt => _emailVerifiedAt;
  String get apiToken => _apiToken;
  String get deviceToken => _deviceToken;
  num get otp => _otp;
  dynamic get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  CustomFields get customFields => _customFields;
  bool get hasMedia => _hasMedia;
  List<dynamic> get media => _media;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['email'] = _email;
    map['phone_number'] = _phoneNumber;
    map['phone_verified_at'] = _phoneVerifiedAt;
    map['email_verified_at'] = _emailVerifiedAt;
    map['api_token'] = _apiToken;
    map['device_token'] = _deviceToken;
    map['otp'] = _otp;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    if (_customFields != null) {
      map['custom_fields'] = _customFields.toJson();
    }
    map['has_media'] = _hasMedia;
    if (_media != null) {
      map['media'] = _media.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// bio : {"value":"Consequatur error ip.&nbsp;","view":"Consequatur error ip.&nbsp;","name":"bio"}
/// address : {"value":"Qui vero ratione vel","view":"Qui vero ratione vel","name":"address"}

class CustomFields {
  CustomFields({
      Bio bio, 
      Address address,}){
    _bio = bio;
    _address = address;
}

  CustomFields.fromJson(dynamic json) {
    _bio = json['bio'] != null ? Bio.fromJson(json['bio']) : null;
    _address = json['address'] != null ? Address.fromJson(json['address']) : null;
  }
  Bio _bio;
  Address _address;
CustomFields copyWith({  Bio bio,
  Address address,
}) => CustomFields(  bio: bio ?? _bio,
  address: address ?? _address,
);
  Bio get bio => _bio;
  Address get address => _address;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_bio != null) {
      map['bio'] = _bio.toJson();
    }
    if (_address != null) {
      map['address'] = _address.toJson();
    }
    return map;
  }

}

/// value : "Qui vero ratione vel"
/// view : "Qui vero ratione vel"
/// name : "address"

class Address {
  Address({
      String value, 
      String view, 
      String name,}){
    _value = value;
    _view = view;
    _name = name;
}

  Address.fromJson(dynamic json) {
    _value = json['value'];
    _view = json['view'];
    _name = json['name'];
  }
  String _value;
  String _view;
  String _name;
Address copyWith({  String value,
  String view,
  String name,
}) => Address(  value: value ?? _value,
  view: view ?? _view,
  name: name ?? _name,
);
  String get value => _value;
  String get view => _view;
  String get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['value'] = _value;
    map['view'] = _view;
    map['name'] = _name;
    return map;
  }

}

/// value : "Consequatur error ip.&nbsp;"
/// view : "Consequatur error ip.&nbsp;"
/// name : "bio"

class Bio {
  Bio({
      String value, 
      String view, 
      String name,}){
    _value = value;
    _view = view;
    _name = name;
}

  Bio.fromJson(dynamic json) {
    _value = json['value'];
    _view = json['view'];
    _name = json['name'];
  }
  String _value;
  String _view;
  String _name;
Bio copyWith({  String value,
  String view,
  String name,
}) => Bio(  value: value ?? _value,
  view: view ?? _view,
  name: name ?? _name,
);
  String get value => _value;
  String get view => _view;
  String get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['value'] = _value;
    map['view'] = _view;
    map['name'] = _name;
    return map;
  }

}