import 'dart:convert';

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gp_project/cubits/AllMemories_cubite/all_memories_cubit.dart';
import 'package:gp_project/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddMemory extends StatefulWidget {
  @override
  State<AddMemory> createState() => _AddMemoryState();
}

class _AddMemoryState extends State<AddMemory> {
  // const AddMemory({Key? key}) : super(key: key);
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  File? image;

  final picker = ImagePicker();
  //we can upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media) async {
    final pickedFile = await picker.pickImage(source: media);
    setState(() {
      image = File(pickedFile!.path);
      print(image);
    });
    /////////

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

                        Text(' From Camera'),
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
    print(patientId);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade900,
        title: Text('AddMemory'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.done), onPressed: () => {
            addMemory(),
          }),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30,),
              image!= null ?
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 1, color: Colors.white),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 20, offset: const Offset(5, 5),),
                  ],
                ),
                child:  Container(
                  width: 200,
                  height:200,
                  child: Center(
                    child:Image.file(File(image!.path),fit: BoxFit.fill, ),
                  ),
                ),
              )
                  : Column(
                    children: [
                      Container(
                width: 200,
                height: 150,
                child: Center(
                      child: IconButton(
                        onPressed: () {
                          myAlert();
                        },
                        icon: Icon(
                          Icons.add_photo_alternate_rounded
                        ),
                        color: Colors.indigo.shade900,
                        iconSize: 60,
                      ),
                ),
              ),
                      Text(
                        'Add Photo',
                        style: TextStyle(
                          color: Colors.indigo,//Color(0xff223263),
                          fontSize:20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'This will be your memory',
                        style: TextStyle(
                          color: Colors.grey,//Color(0xff223263),
                          //fontSize:20,
                          //fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

              /* Container(
                width:MediaQuery.of(context).size.width * 0.8,
                child: IconButton(onPressed:()
                { myAlert();
                  },
                    icon:Icon(Icons.add_a_photo_outlined), iconSize: 100,),
              ),*/
              // SizedBox(height: 15),


              SizedBox(
                height: 8,
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: ('Name'),
                    prefixIcon: Icon(Icons.edit),
                    border:OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(right: 20, left: 20),
                child: TextFormField(
                  controller:descriptionController,
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintText: ('Description'),
                    //prefixIcon: Icon(Icons.edit),
                    border: OutlineInputBorder(borderRadius:BorderRadius.circular(20),)
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addMemory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var id = prefs.get('caregiverId');
      var token = prefs.get('user_access_token');

      // final formData = FormData.fromMap({
      //   'photo': await MultipartFile.fromFile(image!.path),
      // });
      //
      // final response = await Dio().post('http://$url:8000/api/memory', data: {
      //   "name": nameController.text,
      //   "description": descriptionController.text,
      //   "photo":formData,
      //   "type": 1,
      //   "patient_id": '$patientId',
      // }, queryParameters: {
      //   'token': '$token'
      // });

      final formData = FormData.fromMap({
        'name': nameController.text,
        'description': descriptionController.text,
        'type': 1,
        'patient_id': patientId,
        "photo":(image == null)?Container() :await MultipartFile.fromFile(image!.path, filename: "photo.jpg"),
      });
      final response = await Dio().post(
        '$url/api/memory',
        data: formData,

        queryParameters: {
        'token': '$token'
        },
        options: Options(headers: {
         // 'Authorization': 'Bearer $token',
          'Content-Type': 'multipart/form-data',
        }),
      );
      print(response);
      if (response.data['status'] == 200 || response.data['status'] == 201) {
        context.read<AllMemoriesCubit>().getAllMemories(patientId);
        Navigator.pop(context);
      }
      if (response.data['status'] == 401) {
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
