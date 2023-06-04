import 'dart:io';

import 'package:dio/dio.dart';
import 'package:gp_project/main.dart';
import 'package:gp_project/models/tasks_model.dart';

import 'package:shared_preferences/shared_preferences.dart';



class TasksRepo {

  Future<TasksModel> getAllTasks(patientid) async {

    final prefs = await SharedPreferences.getInstance();

    var token = prefs.get('user_access_token');

    final response = await Dio().get('$url/api/tasks/$patientid',
        queryParameters:{'token':'$token'},
        options:Options(headers:{'Connection':'Keep-Alive'}));

    print(response);
    TasksModel listOfTasks = TasksModel.fromJson(response.data);

    return listOfTasks;
  }
}
