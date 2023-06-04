

import 'package:dio/dio.dart';
import 'package:gp_project/models/allpatient_repo_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';


class AllPatientRepo {

  Future<AllPatientRepoModel> getAllPatient() async {
    final prefs = await SharedPreferences.getInstance();
    var id = prefs.get('caregiverId');
    var token = prefs.get('user_access_token');

    final response = await Dio().get('$url/api/patients/$id',
        options: Options(headers: {'Connection': 'Keep-Alive',}),
    queryParameters:{'token':'$token'});

    var data = await response.data;
    print(data);
    //print ll respons 3 at2kd mn api

    AllPatientRepoModel allpatient = AllPatientRepoModel.fromJson(data);

    return allpatient;
  }

  Future<AllPatientRepoModel> getSinglePatient(int patientId) async {
    final response = await Dio().get(
        'https://dummyjson.com/products/$patientId');
    final patient = AllPatientRepoModel.fromJson(response.data);
    return patient;
  }
}


     //دي اللي شغال
     // List<Data> patients=[];
     // for(var item in data){
     //   patients.add(Data.fromJson(item));
     // }
     // return patients;


// print(listofallpatients.toString());
//     return listofallpatients;




// Future<List<Data>> getAllPatient() async {
//   final response = await Dio().get('http://192.168.1.14:8000/api/patients/1');
//   Map<String,dynamic> responsedata=response.data;
//   final listofallpatient= List<Data>.from( responsedata['data'].map((value) {
//       return Data.fromJson(value);
//     }));
//      print(listofallpatient.first);
//     return listofallpatient;
// }