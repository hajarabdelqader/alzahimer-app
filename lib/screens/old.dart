

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:dio/dio.dart';
import 'package:gp_project/main.dart';
import 'login_screen.dart';

class Registerpage extends StatelessWidget {
  //const Register({Key? key}) : super(key: key);
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController password_confirmation = TextEditingController();

  final GlobalKey<FormState> formkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Form(
            key: formkey,
            child: Container(
                color: Colors.white,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: ListView(children: [
                  SizedBox(height: 60),
                  Center(
                    child: Image.asset(
                      'assets/images/mo.jpg',
                      width: 80,
                      height: 80,
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      'Lets get started',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff223263)),
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Text(
                      'create new account',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey),
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: TextFormField(
                      controller: nameController,
                      /* validator: (text) {
                        if (text!.length > 20) {
                          return 'name should be shorter than 20';
                        }
                        return null;
                      },*/
                      decoration: InputDecoration(
                          hintText: "Full name",
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder()),
                    ),
                  ),
                  // SizedBox(height: 5),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: TextFormField(
                      controller: emailController,
                      /* validator: (text) {
                        if (!text!.contains('@')) {
                          return 'You should write @';
                        }
                        return null;
                      },*/
                      decoration: InputDecoration(
                          hintText: "Your email",
                          prefixIcon: Icon(Icons.email_outlined),
                          border: OutlineInputBorder()),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      /* validator: (text) {
                        if (text!.length <2) {
                          return 'password should be more 6 ';
                        }
                        return null;
                      },*/
                      decoration: InputDecoration(
                          hintText: "Password",
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder()),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: TextFormField(
                      controller: password_confirmation,
                      //34an lpass ybaa dots bst5dm obscure
                      obscureText: true,
                      /* validator: (text) {
                        if (text!.length < 2) {
                          return 'password should be more 6 ';
                        }
                        return null;
                      },*/
                      decoration: InputDecoration(
                          hintText: "Password again",
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder()),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    height: 80,
                    child: ElevatedButton(
                      onPressed: () {
                        register(context);
                        /* if (formkey.currentState!.validate()) {
                         register(context);}*/

                        //  Navigator.of(context).pushAndRemoveUntil(
                        // MaterialPageRoute(builder: (context) {
                        //return LoginPage();
                        // }), (route) => false);
                      },
                      child: Text(
                        "sign up",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.teal.shade900,
                        fixedSize: Size.fromWidth(5),
                      ),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have account?",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) {
                                return LoginPage();
                              }), (route) => false);
                        },
                        label: Text('Sign In',
                            style: (TextStyle(color: Colors.teal.shade900))),
                        icon: Icon(
                          Icons.add_circle_outline_sharp,
                          color: Colors.teal.shade900,
                        ),
                      ),
                    ],
                  )
                ])),
          )),
    );
  }


  void register(BuildContext context) async {
    //  late LoginModel listOflogindata;
    try {
      var response =
      await Dio().post('$url/api/auth/registercaregiver', data: {
        "name": nameController.text,
        "email": emailController.text,
        "password": passwordController.text,
        "password_confirmation": password_confirmation.text,
        "Role": 1,
      });
      if (response.data['status'] == 200 || response.data['status'] == 201) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) {
              return LoginPage();
            }), (route) => false);
      }
      if (response.data['status'] == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(response.data['msg']),
              backgroundColor: Colors.red.shade900),
        );
      }
    } //try
    catch (e) {
      print(e.toString());
    }
  }
}




