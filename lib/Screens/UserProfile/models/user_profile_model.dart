class ProfileModel {
  String? message;
  Data? data;

  ProfileModel({this.message, this.data});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? uuid;
  String? username;
  String? firstName;
  String? lastName;
  String? title;
  String? email;
  String? phone;
  String? emailVerifiedAt;
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
