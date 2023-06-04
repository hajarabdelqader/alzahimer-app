import 'dart:io';

import 'package:dio/dio.dart';
import 'package:gp_project/main.dart';
import 'package:gp_project/models/memories_model.dart';

import 'package:shared_preferences/shared_preferences.dart';



  class MemoriesRepo {


  Future<MemoriesRepoModel> getAllMemories(patientid) async {


    final prefs = await SharedPreferences.getInstance();

    var token = prefs.get('user_access_token');

    final response = await Dio().get('$url/api/memories/$patientid',
        queryParameters:{'token':'$token'},options:Options(headers:{'Connection':'Keep-Alive'}));

    print(response);

   MemoriesRepoModel listOfMemories = MemoriesRepoModel.fromJson(response.data);

  return listOfMemories;
  }
  }
