class SignUpModel {
  String? message;
  Data? data;
  Meta? meta;
  Map<String, List<String>>? errors;

  SignUpModel({this.message, this.data, this.meta, this.errors});

  SignUpModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
    errors = json['errors'] != null ? _parseErrors(json['errors']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }

    return data;
  }


  static Map<String, List<String>> _parseErrors(Map<String, dynamic> errorData) {
    Map<String, List<String>> errors = {};
    errorData.forEach((key, value) {
      if (value is List) {
        errors[key] = List<String>.from(value);
      } else if (value is String) {
        errors[key] = [value];
      }
    });
    return errors;
  }
}

class Data {
  String? uuid;
  String? username;
  String? firstName;
  String? lastName;
  Null? title;
  String? email;
  String? phone;
  Null? emailVerifiedAt;
  Null? phoneVerifiedAt;
  String? avatar;

  Data(
      {this.uuid,
        this.username,
        this.firstName,
        this.lastName,
        this.title,
        this.email,
        this.phone,
        this.emailVerifiedAt,
        this.phoneVerifiedAt,
        this.avatar});

  Data.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    username = json['username'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    title = json['title'];
    email = json['email'];
    phone = json['phone'];
    emailVerifiedAt = json['email_verified_at'];
    phoneVerifiedAt = json['phone_verified_at'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['username'] = this.username;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['title'] = this.title;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['phone_verified_at'] = this.phoneVerifiedAt;
    data['avatar'] = this.avatar;
    return data;
  }
}

class Meta {
  String? token;

  Meta({this.token});

  Meta.fromJson(Map<String, dynamic> json) {
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    return data;
  }
}
