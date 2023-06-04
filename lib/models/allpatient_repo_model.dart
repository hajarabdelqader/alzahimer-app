
class AllPatientRepoModel {
  int? status;
  List<Data>? data;
  String? msg;

  AllPatientRepoModel({this.status, this.data, this.msg});

  AllPatientRepoModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['msg'] = this.msg;
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? email;
  int? stage;
  String? address;
  String? birthDate;
  String? phone;
  int? gender;
  String? photo;

  Data(
      {this.id,
        this.name,
        this.email,
        this.stage,
        this.address,
        this.birthDate,
        this.phone,
        this.gender,
        this.photo});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    stage = json['Stage'];
    address = json['address'];
    birthDate = json['birth_date'];
    phone = json['phone'];
    gender = json['gender'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['Stage'] = this.stage;
    data['address'] = this.address;
    data['birth_date'] = this.birthDate;
    data['phone'] = this.phone;
    data['gender'] = this.gender;
    data['photo'] = this.photo;
    return data;
  }
}












