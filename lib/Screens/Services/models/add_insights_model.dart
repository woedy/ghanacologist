class AddInsightModel {
  String? message;
  List<Data>? data;

  AddInsightModel({this.message, this.data});

  AddInsightModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
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

  Data({this.uuid, this.caption, this.media, this.updatedAt, this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    caption = json['caption'];
    media = json['media'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['caption'] = this.caption;
    data['media'] = this.media;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    return data;
  }
}
