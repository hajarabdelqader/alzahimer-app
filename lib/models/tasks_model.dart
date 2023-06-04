class TasksModel {
  int? status;
  List<Data>? data;
  String? msg;

  TasksModel({this.status, this.data, this.msg});

  TasksModel.fromJson(Map<String, dynamic> json) {
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
  String? details;
  String? time;
  int? status;
  int? repeatsPerDay;
  String? startDate;
  String? endDate;
  String? repeatType;
  int? patientId;

  Data(
      {this.id,
        this.name,
        this.details,
        this.time,
        this.status,
        this.repeatsPerDay,
        this.startDate,
        this.endDate,
        this.repeatType,
        this.patientId});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    details = json['details'];
    time = json['time'];
    status = json['status'];
    repeatsPerDay = json['repeats_per_day'];
    startDate = json['Start_date'];
    endDate = json['End_date'];
    repeatType = json['Repeat Type'];
    patientId = json['patient_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['details'] = this.details;
    data['time'] = this.time;
    data['status'] = this.status;
    data['repeats_per_day'] = this.repeatsPerDay;
    data['Start_date'] = this.startDate;
    data['End_date'] = this.endDate;
    data['Repeat Type'] = this.repeatType;
    data['patient_id'] = this.patientId;
    return data;
  }
}
