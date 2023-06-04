import 'package:dio/dio.dart';
import 'package:gp_project/models/CaregiverNotifi_Model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

// care giver notifications
class AllNotifiRepo {

  Future<CareNotifiModel> getAllNotifi() async {

    final prefs = await SharedPreferences.getInstance();
    var id = prefs.get('caregiverId');
    var token = prefs.get('user_access_token');
    print(id);
    print(token);
    final response = await Dio().get('$url/api/caregiver/notifications/$id',
        options: Options(headers: {'Connection': 'Keep-Alive',}),
        queryParameters:{'token':'$token'});
    print(response.data);

    //print ll respons 3 at2kd mn api
    CareNotifiModel allNotifi = CareNotifiModel.fromJson(response.data);

   print("ggggggggggkkkkkkkkkkkk");
    return allNotifi;
  }
}