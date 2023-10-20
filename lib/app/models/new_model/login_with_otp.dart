/// success : true
/// data : {"mobile":"12348996321","otp":1220}
/// message : "OTP sent successfully"

class LoginWithOtp {
  LoginWithOtp({
      bool success, 
      Data data, 
      String message,}){
    _success = success;
    _data = data;
    _message = message;
}

  LoginWithOtp.fromJson(dynamic json) {
    _success = json['success'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
    _message = json['message'];
  }
  bool _success;
  Data _data;
  String _message;
LoginWithOtp copyWith({  bool success,
  Data data,
  String message,
}) => LoginWithOtp(  success: success ?? _success,
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

/// mobile : "12348996321"
/// otp : 1220

class Data {
  Data({
      String mobile, 
      num otp,}){
    _mobile = mobile;
    _otp = otp;
}

  Data.fromJson(dynamic json) {
    _mobile = json['mobile'];
    _otp = json['otp'];
  }
  String _mobile;
  num _otp;
Data copyWith({  String mobile,
  num otp,
}) => Data(  mobile: mobile ?? _mobile,
  otp: otp ?? _otp,
);
  String get mobile => _mobile;
  num get otp => _otp;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['mobile'] = _mobile;
    map['otp'] = _otp;
    return map;
  }

}