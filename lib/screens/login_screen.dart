import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gp_project/main.dart';
import 'package:gp_project/models/allpatient_repo_model.dart';
import 'package:gp_project/screens/cach_notifi.dart';
import 'package:gp_project/screens/navbar_caregiver.dart';
import 'package:gp_project/screens/patient_home.dart';
import 'package:gp_project/screens/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  // const LoginPage({Key? key}) : super(key: key);
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white,
        body: SafeArea(
            child: SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: formkey,
          child: Column(
            children: [
              SizedBox(height: 50),
              Image.asset(
                "assets/images/logo.png",
                height: 150,
                width: 150,
              ),
              SizedBox(height:20),
              Text(
                'Welcome to BALZ',
                style: TextStyle(
                  color: Color(0xff223263),
                  fontSize: 19,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'Sign to continue',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(

                padding: EdgeInsets.all(20),
                child: TextFormField(
                  controller: emailController,
                  /*validator: (text) {
                    if (!text!.contains("@")) {
                      return "you should write correct email";
                    }
                  },*/
                  decoration: InputDecoration(
                    hintText: ('Enter Your Email'),
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(right: 20, left: 20),
                child: TextFormField(
                  controller: passwordController,
                  /* validator: (text) {
                    if (text!.length < 6) {
                      return "enter more than 6 character";
                    }
                  },*/
                  decoration: InputDecoration(
                    hintText: ('Enter Your password'),
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),

              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                child: ElevatedButton(
                  onPressed: () {
                    //1-validate
                    //2-send data to api
                    //3-if api true
                    // (validate el login)

                    bool isvalidate = formkey.currentState!.validate();
                    if (isvalidate) {
                      login(context);
                    }
                    // Navigator.of(context).pushAndRemoveUntil(
                    //     MaterialPageRoute(builder: (context) {
                    //   return CaregiverHome();
                    // }), (route) => false);
                  },
                  child: Text('Sign in'),
                  style:
                      ElevatedButton.styleFrom(primary: Colors.indigo.shade900),
                ),
              ),
              TextButton(
                  onPressed: () {},
                  child: Text('forgot password?',
                      style: TextStyle(color: Colors.indigo.shade900))),
              /* TextButton(onPressed: () {}, child: Text('dont have account?')),*/
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'dont have account ?',
                    style: TextStyle(
                      color: Color(0xff9098B1),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                        return Registerpage();
                      }));
                    },
                    child: Text('register',
                        style: TextStyle(color: Colors.indigo.shade900)),
                  ),
                ],
              ),
              //TextButton(onPressed: () {}, child: Text('register')),
            ],
          ),
        ),
      ),
    )));
  }

  void login(context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      print(emailController.text);
      print(passwordController.text);
      final response = await Dio().post(
        '$url/api/auth/login',
        data: {
          "email": emailController.text,
          "password": passwordController.text,
        },
      );
      print(response);
      if (response.data['status'] == 200 || response.data['status'] == 201) {
        final accessToken = response.data['data'][0]['token'];

        await prefs.setString('user_access_token', accessToken).then((value) {
          print(prefs.getString('user_access_token'));
        });

        // print(response.data[0]);
        if (response.data['data'][0]['type'] == 1) {
          print(response.data['data'][0]['id']);
          final caregiverId = response.data['data'][0]['id'];
          await prefs.setInt('caregiverId', caregiverId).then((value) {
            print(prefs.getInt('caregiverId'));
          });

          //var careinfo = LoginModel.fromJson(response.data);

          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) {
            return NavCare();
          }), (route) => false);

        } else if (response.data['data'][0]['type'] == 0) {
          print(response.data['data'][0]['id']);

          final patientId = response.data['data'][0]['id'];

          await prefs.setInt('patientId', patientId).then((value) {
            print(prefs.getInt('patientId'));
          });
          final patient = AllPatientRepoModel.fromJson(response.data);
          fetchTasksAndCache(patientId, accessToken);

          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) {
            return PatientHome(patientInfo: patient.data![0]);
          }), (route) => false);
        }
      }

      if (response.data['status'] == 401 || response.data['status'] == 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(response.data['msg'].toString()),
              backgroundColor: Colors.red.shade900),
        );
      }
    } //try
    catch (e) {
      print(e.toString());
    }
  }
}
