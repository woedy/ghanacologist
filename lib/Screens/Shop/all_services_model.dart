class AllServicesModel {
  String? message;
  List<Data>? data;
  Meta? meta;

  AllServicesModel({this.message, this.data, this.meta});

  AllServicesModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) { data!.add(new Data.fromJson(v)); });
    }
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
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

  Data({this.name, this.phone, this.email, this.city, this.region, this.url, this.description, this.uuid, this.updatedAt, this.createdAt, this.photo});

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

class Meta {
  Pagination? pagination;

  Meta({this.pagination});

  Meta.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null ? new Pagination.fromJson(json['pagination']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class Pagination {
  int? total;
  int? count;
  int? perPage;
  int? currentPage;
  int? totalPages;
  //Links? links;

  Pagination({this.total, this.count, this.perPage, this.currentPage, this.totalPages,});

  Pagination.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    count = json['count'];
    perPage = json['per_page'];
    currentPage = json['current_page'];
    totalPages = json['total_pages'];
    //links = json['links'] != null ? new Links.fromJson(json['links']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['count'] = this.count;
    data['per_page'] = this.perPage;
    data['current_page'] = this.currentPage;
    data['total_pages'] = this.totalPages;
   /* if (this.links != null) {
      data['links'] = this.links!.toJson();
    }*/
    return data;
  }
}

