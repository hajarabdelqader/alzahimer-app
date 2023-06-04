import 'dart:io';

import 'package:dio/dio.dart';
import 'package:gp_project/main.dart';
import 'package:gp_project/models/patientNotifi_model.dart';
import 'package:gp_project/models/tasks_model.dart';

import 'package:shared_preferences/shared_preferences.dart';



class PatientNotifiRepo {

  Future<PatientNotifiModel> getPatientNotifi(patientid) async {

    final prefs = await SharedPreferences.getInstance();

    var token = prefs.get('user_access_token');

    final response = await Dio().get('$url/api/patient/notifications/$patientid',
        queryParameters:{'token':'$token'},
        options:Options(headers:{'Connection':'Keep-Alive'}));

    print(response);
    PatientNotifiModel listOfPatientNotifi = PatientNotifiModel.fromJson(response.data);

    return listOfPatientNotifi;
  }
}
