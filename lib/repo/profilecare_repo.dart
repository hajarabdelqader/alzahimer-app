

import 'package:dio/dio.dart';
import 'package:gp_project/models/profilcare_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';


class CareProfileRepo{

  Future<CareProfileModel> getCaregiver() async {
    final prefs = await SharedPreferences.getInstance();
    var id = prefs.get('caregiverId');
    var token = prefs.get('user_access_token');
      print(id);
    final response = await Dio().get('$url/api/auth/user-profile',
        options: Options(headers: {'Connection': 'Keep-Alive',}),
        queryParameters:{'token':'$token'});

    var data = await response.data;
    print(data);
    //print ll respons 3 at2kd mn api

    CareProfileModel caregiverdata= CareProfileModel.fromJson(response.data);
    print('kkkk$caregiverdata');

    return caregiverdata;
  }
}
