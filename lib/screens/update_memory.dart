import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gp_project/cubits/AllMemories_cubite/all_memories_cubit.dart';
import 'package:gp_project/main.dart';
import 'package:gp_project/repo/memories_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../models/memories_model.dart';

class UpdateMemory extends StatefulWidget {
  const UpdateMemory({Key? key, required this.memorydata}) : super(key: key);
  final Data memorydata;


  @override
  State<UpdateMemory> createState() => _UpdateMemoryState();
}

class _UpdateMemoryState extends State<UpdateMemory> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String? image;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.memorydata.name!;
    descriptionController.text = widget.memorydata.description!;
   // image= widget.memorydata.photo!;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //toolbarHeight: 70,
        backgroundColor: Colors.indigo.shade900,
        title: Text('UpdateMemory',
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.done), onPressed: () => {
          updateMemory(),
          MemoriesRepo().getAllMemories(patientId),

          }),
        ],

      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height:7),
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
                  width: 250,
                  height:250,
                  child: Center(
                    child:Image.network(widget.memorydata.photo!,fit: BoxFit.fill, ),
                  ),
                ),
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
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateMemory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      //var id = prefs.get('caregiverId');
      var token = prefs.get('user_access_token');
      var memoryId = widget.memorydata.id;

      final response = await Dio().post('$url/api/memory/$memoryId',
          options: Options(headers: {'Connection': 'Keep-Alive',}),
          data: {
            "name": nameController.text,
            "description": descriptionController.text,
            //"photo": '',
            "type": 1,
          },

          queryParameters: {
            'token': '$token'
          });
      print(response);

      if (response.data['status'] == 200 || response.data['status'] == 201) {
        MemoriesRepoModel listOfMemories = MemoriesRepoModel.fromJson(response.data);

        Data memory = listOfMemories.data![0];
        print(listOfMemories.data![0]);
        context.read<AllMemoriesCubit>().getAllMemories(patientId);
        Navigator.pop(context);
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