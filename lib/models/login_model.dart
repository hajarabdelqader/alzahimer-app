class LoginModel {
  int? status;
  List<Data>? data;
  String? msg;

  LoginModel({this.status, this.data, this.msg});

  LoginModel.fromJson(Map<String, dynamic> json) {
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
  String? photo;
  int? type;
  int? gender;
  String? token;

  Data(
      {this.id,
        this.name,
        this.email,
        this.stage,
        this.address,
        this.birthDate,
        this.phone,
        this.photo,
        this.type,
        this.gender,
        this.token});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    stage = json['Stage'];
    address = json['address'];
    birthDate = json['birth_date'];
    phone = json['phone'];
    photo = json['photo'];
    type = json['type'];
    gender = json['gender'];
    token = json['token'];
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
    data['photo'] = this.photo;
    data['type'] = this.type;
    data['gender'] = this.gender;
    data['token'] = this.token;
    return data;
  }
}
