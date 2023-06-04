import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gp_project/main.dart';
import 'package:gp_project/models/allpatient_repo_model.dart';
import 'package:gp_project/screens/navbar_patient.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdatePatient extends StatefulWidget {
  const UpdatePatient(
      {Key? key, required this.allPatientRepoModel, required this.index})
      : super(key: key);
  final AllPatientRepoModel allPatientRepoModel;
  final int index;

  @override
  State<UpdatePatient> createState() => _UpdatePatientState();
}

class _UpdatePatientState extends State<UpdatePatient> {
  //const ({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController stageController = TextEditingController();
  var gender;
  String? patientImage;
  File? image;

  @override
  void initState() {
    super.initState();

    nameController.text = widget.allPatientRepoModel.data![widget.index].name!;
    emailController.text =
        widget.allPatientRepoModel.data![widget.index].email!;
    addressController.text =
        widget.allPatientRepoModel.data![widget.index].address!;
    birthdateController.text =
        widget.allPatientRepoModel.data![widget.index].birthDate!;
    phoneController.text =
        widget.allPatientRepoModel.data![widget.index].phone!;
    stageController.text =
        widget.allPatientRepoModel.data![widget.index].stage.toString();

    gender = widget.allPatientRepoModel.data![widget.index].gender!;

    patientImage = widget.allPatientRepoModel.data![widget.index].photo!;
  }

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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade900,
        title: Text('update Patient'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.done),
              onPressed: () => {
                    updatepatient(),
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
                  image == null
                      ? CircleAvatar(
                          radius: 90,
                          backgroundImage: NetworkImage(patientImage!),
                        )
                      : CircleAvatar(
                          radius: 90,
                          backgroundImage: FileImage(
                            File(image!.path),
                          ),
                        ),
                  IconButton(
                    onPressed: () {
                      myAlert();
                    },
                    icon: const CircleAvatar(
                      backgroundColor: Colors.indigo,
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
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
                    prefixIcon: Icon(Icons.phone),
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
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
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
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updatepatient() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.get('user_access_token');
      var patintId = widget.allPatientRepoModel.data![widget.index].id!;

      print(patintId);

      var arr = {
        "email": emailController.text,
        "name": nameController.text,
        "Stage": stageController.text,
        "address": addressController.text,
        "phone": phoneController.text,
        "gender": gender,
        "birth_date": birthdateController.text,
        //"photo":patientImage,
      };

      FormData formDataNoImage = FormData.fromMap({
        "email": emailController.text,
        "name": nameController.text,
        "Stage": stageController.text,
        "address": addressController.text,
        "phone": phoneController.text,
        "gender": gender,
        "birth_date": birthdateController.text,
      });
      print(formDataNoImage);

      FormData formData = FormData.fromMap({
        "email": emailController.text,
        "name": nameController.text,
        "Stage": stageController.text,
        "address": addressController.text,
        "phone": phoneController.text,
        "photo": (image == null)
            ? SizedBox()
            : await MultipartFile.fromFile(image!.path, filename: "photo.jpg"),
        "gender": gender,
        "birth_date": birthdateController.text,
      });
      print(formData);
      print(image);

      final response = await Dio().post(
        '$url/api/patient/$patintId',
        data: formData,
        queryParameters: {'token': '$token'},
      );
      print(response);

      if (response.data['status'] == 200 || response.data['status'] == 201) {
        AllPatientRepoModel patient =
            AllPatientRepoModel.fromJson(response.data);

        // context.read<AllPatientCubit>().getAllPatient();
        // Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => NavPatient(patientInfo: patient.data![0])),
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
