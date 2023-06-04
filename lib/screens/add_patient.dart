import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gp_project/main.dart';

import 'package:gp_project/screens/navbar_caregiver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddPatient extends StatefulWidget {
  @override
  State<AddPatient> createState() => _AddPatientState();
}

class _AddPatientState extends State<AddPatient> {
  //const ({Key? key}) : super(key: key);
  // String userImage="https://as2.ftcdn.net/v2/jpg/00/84/67/19/1000_F_84671939_jxymoYZO8Oeacc3JRBDE8bSXBWj0ZfA9.jpg";
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController rePasswordController = TextEditingController();
  final TextEditingController stageController = TextEditingController();
  var gender;

  File? image;

  final picker = ImagePicker();
  //we can upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media) async {
    final pickedFile = await picker.pickImage(source: media);
    setState(() {
      image = File(pickedFile!.path);
      print(image);
    });
  }

  //show popup dialog
  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Please choose media to select'),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.indigo,
                    ),
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.image,
                        ),
                        Text(
                          'From Gallery',
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    style: ElevatedButton.styleFrom(
                      primary: Colors.indigo,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
    //image
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade900,
        title: Text('Add Patient'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.done),
              onPressed: () => {
                    addpatient(),
                    // AllPatientRepo().getAllPatient(),
                  }),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 4),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  if (image != null)
                    CircleAvatar(
                      radius: 90,
                      backgroundImage: FileImage(
                        File(image!.path),
                      ),
                    )
                  else
                    CircleAvatar(
                      radius: 90,
                      backgroundImage: AssetImage("assets/images/user3.png"),
                    ),
                  IconButton(
                    onPressed: () {
                      myAlert();
                    },
                    icon: CircleAvatar(
                      backgroundColor: Colors.indigo,
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              //SizedBox(height: 0),
              // Image.asset(
              //   "assets/images/addpatient.png",
              //   height: 80,
              //   width: 80,
              // ),
              // SizedBox(height: 15),
              // Text(
              //   'Add Patient',
              //   style: TextStyle(
              //     color: Color(0xff223263),
              //     fontSize: 19,
              //     fontWeight: FontWeight.w500,
              //   ),
              // ),
              // SizedBox(
              //   height: 0,
              // ),
              // Text(
              //   'Sign to continue',
              //   style: TextStyle(
              //     color: Colors.grey,
              //     fontWeight: FontWeight.w500,
              //     fontSize: 15,
              //   ),
              // ),
              SizedBox(
                height: 5,
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: ('Name'),
                    prefixIcon: Icon(Icons.account_box_sharp),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(right: 20, left: 20),
                child: TextFormField(
                  controller: birthdateController,
                  onTap: () async {
                    DateTime? pickeddate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101));
                    if (pickeddate != null) {
                      setState(() {
                        birthdateController.text =
                            DateFormat("yyyy-MM-dd").format(pickeddate);
                      });
                    }
                  },
                  decoration: InputDecoration(
                    hintText: ('BirthDate'),
                    prefixIcon: Icon(Icons.date_range),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20, right: 20, left: 20),
                child: TextFormField(
                  controller: addressController,
                  decoration: InputDecoration(
                    hintText: ('Address'),
                    prefixIcon: Icon(Icons.home_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20, right: 20, left: 20),
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: ('Email'),
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20, right: 20, left: 20),
                child: TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: ('Password'),
                    prefixIcon: Icon(Icons.password),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20, right: 20, left: 20),
                child: TextFormField(
                  controller: rePasswordController,
                  decoration: InputDecoration(
                    hintText: ('Password confirmation'),
                    prefixIcon: Icon(Icons.password),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20, right: 20, left: 20),
                child: TextFormField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    hintText: ('Phone number'),
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20, right: 20, left: 20),
                child: TextFormField(
                  controller: stageController,
                  decoration: InputDecoration(
                    hintText: ('stage'),
                    //prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              // Container(
              //   padding: EdgeInsets.only(top:20,right: 20, left: 20),
              //   child: TextFormField(
              //     decoration: InputDecoration(
              //       hintText: ('Gender'),
              //       prefixIcon: Icon(Icons.account_box_rounded),
              //       border: OutlineInputBorder(),
              //     ),
              //   ),
              // ),
              SizedBox(
                height: 15,
              ),
              RadioListTile(
                title: Text("Male"),
                value: 1,
                groupValue: gender,
                onChanged: (value) {
                  setState(() {
                    gender = value;
                  });
                },
              ),

              RadioListTile(
                title: Text("Female"),
                value: 0,
                groupValue: gender,
                onChanged: (value) {
                  setState(() {
                    gender = value;
                  });
                },
              ),
              //  Container(
              //    width: 130,
              //    height: 45,
              //    child:ElevatedButton(onPressed: () {  },style:
              //        ElevatedButton.styleFrom(primary:Colors.teal.shade900),
              //      child:Text('Add',style:TextStyle(fontSize:20,)),),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addpatient() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var id = prefs.get('caregiverId');
      var token = prefs.get('user_access_token');

      FormData formData = FormData.fromMap({
        "email": emailController.text,
        "password": passwordController.text,
        "name": nameController.text,
        "Stage": stageController.text,
        "address": addressController.text,
        "phone": phoneController.text,
        "photo": (image == null)
            ? ''
            : await MultipartFile.fromFile(image!.path, filename: "photo.jpg"),
        "gender": gender,
        "birth_date": birthdateController.text,
        "password_confirmation": rePasswordController.text,
        "caregiver_id": '$id',
      });

      final response = await Dio().post(
        '$url/api/patient',
        data: formData,
        queryParameters: {'token': '$token'},
      );
      print(response);

      if (response.data['status'] == 200 || response.data['status'] == 201) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NavCare()),
        );
      }
      if (response.data['status'] == 400 || response.data['status'] == 401) {
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
