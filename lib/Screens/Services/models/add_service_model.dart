class AddServicesModel {
  String? message;
  Data? data;

  AddServicesModel({this.message, this.data});

  AddServicesModel.fromJson(Map<String, dynamic> json) {
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
  String? name;
  String? phone;
  String? email;
  String? city;
  String? region;
  String? url;
  String? description;
  String? uuid;
  String? updatedAt;
  String? createdAt;
  String? photo;

  Data(
      {this.name,
        this.phone,
        this.email,
        this.city,
        this.region,
        this.url,
        this.description,
        this.uuid,
        this.updatedAt,
        this.createdAt,
        this.photo});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    city = json['city'];
    region = json['region'];
    url = json['url'];
    description = json['description'];
    uuid = json['uuid'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['city'] = this.city;
    data['region'] = this.region;
    data['url'] = this.url;
    data['description'] = this.description;
    data['uuid'] = this.uuid;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['photo'] = this.photo;
    return data;
  }
}
