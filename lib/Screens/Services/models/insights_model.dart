// Model for Insights
class Insights {
  String? message;
  Data? data;

  Insights({this.message, this.data});

  Insights.fromJson(Map<String, dynamic> json) {
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
  String? caption;
  String? media;
  String? updatedAt;
  String? createdAt;
  User? user;

  Data(
      {this.uuid,
        this.caption,
        this.media,
        this.updatedAt,
        this.createdAt,
        this.user});

  Data.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    caption = json['caption'];
    media = json['media'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['caption'] = this.caption;
    data['media'] = this.media;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  String? uuid;
  String? firstName;
  String? lastName;
  String? avatar;

  User({this.uuid, this.firstName, this.lastName, this.avatar});

  User.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['avatar'] = this.avatar;
    return data;
  }
}
