class rasberryModel {
  int? patientId;
  List<int>? caregiverIds;
  String? message;

  rasberryModel({this.patientId, this.caregiverIds, this.message});

  rasberryModel.fromJson(Map<String, dynamic> json) {
    patientId = json['patient_id'];
    caregiverIds = json['caregiver_Ids'].cast<int>();
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['patient_id'] = this.patientId;
    data['caregiver_Ids'] = this.caregiverIds;
    data['message'] = this.message;
    return data;
  }
}
