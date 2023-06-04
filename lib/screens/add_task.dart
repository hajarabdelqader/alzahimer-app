
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gp_project/cubits/AllTasks_cubite/all_tasks_cubit.dart';
import 'package:gp_project/main.dart';
import 'package:gp_project/repo/tasks_repo.dart';
import 'package:gp_project/screens/custom_task.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:intl/intl_browser.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController startDate= TextEditingController();
  final TextEditingController endDate = TextEditingController();
  final TextEditingController time = TextEditingController();
  List<String> itemsList = ["Repeat per day", " 1", " 2", " 3", " 4", "5"];
  var selectedNumber = "Repeat per day";
  List<String> itemList = [
    "Repeat type",
    "Once",
    "Daily",
    "Custom",
  ];
  var selectItem = "Repeat type";

   int selectRepeatId(String selectItem){
    if(selectItem== "Once")
    {  return 1;}
    else if( selectItem=="Daily")
      return 2;
    else
      return 3;
  }

  List<String> _selectedDays = [];

  void _showMultiSelect() async {
    // a list of selectable items
    // these items can be hard-coded or dynamically fetched from a database/API
    final List<String> items = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday'
    ];
    final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(items: items);
      },
    );

    // Update UI
    if (results != null) {
      setState(() {
        _selectedDays = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade900,
        title: Text('Add Task', style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.done), onPressed: () => {
            addTask(),
            TasksRepo().getAllTasks(patientId)
          }),
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.all(15),
              child: TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: ('Task Name'),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 15, left: 15),
              child: TextFormField(
                controller: descriptionController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: ('Task Description'),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.4,
                  padding: EdgeInsets.only(left: 15),
                  child: TextFormField(
                    controller: startDate,
                    onTap: () async {
                      DateTime? pickeddate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101));
                      if (pickeddate != null) {
                        setState(() {
                          startDate.text =
                              DateFormat("yyyy-MM-dd").format(pickeddate);
                        });
                      }
                    },
                    decoration: InputDecoration(
                      hintText: ('Start Date'),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  width: 68,
                ),
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.4,
                  padding: EdgeInsets.only(right:5),
                  child: TextFormField(
                    controller: endDate,
                    onTap: () async {
                      DateTime? pickeddate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101));
                      if (pickeddate != null) {
                        setState(() {
                          endDate.text =
                              DateFormat("yyyy-MM-dd").format(pickeddate);
                        });
                      }
                    },
                    decoration: InputDecoration(
                      hintText: ('End Date'),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),

            // time
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.1,
              padding: EdgeInsets.only(left: 15, right:200),
              child: TextFormField(
                controller: time,
                onTap: () async {
                  TimeOfDay? pickedtime = await showTimePicker(
                      context: context, initialTime: TimeOfDay.now());
                  if (pickedtime != null) {
                    setState(() {
                      time.text =
                      '${pickedtime.hour.toString().padLeft(2,'0')}:${pickedtime.minute.toString().padLeft(2, '0')}'+':00';

                    });
                  }
                },
                decoration: InputDecoration(
                  hintText: ('Select Time'),
                  prefixIcon: Icon(Icons.timer_sharp),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 20,),

            // Reapeat per day
            Container(
              padding: EdgeInsets.only(left: 15, right: 30),
              width: 360,
              height: 60,
              alignment: Alignment.bottomLeft,
              child: SizedBox(
                width: 350,
                height: 60,
                child: DropdownButtonFormField<dynamic>(
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 3, color: Colors.teal.shade900))),
                  value: selectedNumber,
                  items: itemsList.map((items) {
                    return DropdownMenuItem(value: items, child: Text(items));
                  }).toList(),
                  onChanged: (value) {
                    selectedNumber = value;
                    setState(() {});
                  },
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),

            //Reapeat type
            Container(
              padding: EdgeInsets.only(left: 15, right: 30),
              width: 360,
              height: 60,
              alignment: Alignment.bottomLeft,
              child: SizedBox(
                width: 350,
                height: 60,
                child: DropdownButtonFormField<dynamic>(
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1, color: Colors.teal.shade900))),
                  value: selectItem,
                  items: itemList.map((items) {
                    return DropdownMenuItem(value: items, child: Text(items));
                  }).toList(),
                  onChanged: (value) {
                    selectItem = value;
                    setState(() {});
                  },
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            selectItem=="Custom"?
              SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 15, right: 10),
                    child: ElevatedButton(
                      onPressed: _showMultiSelect,
                      child: const Text(
                        "Custom",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  Divider(
                    height: 30,
                  ),
                  // display selected items
                  Wrap(
                    children: _selectedDays
                        .map((e) => Chip(
                              label: Text(e),
                            ))
                        .toList(),
                  ),
                ],
              ),
            )
            :Container(),
            SizedBox(
              height: 10,
            ),
            // Container(
            //   alignment: Alignment.center,
            //   height: 60,
            //   width: 100,
            //   child: ElevatedButton(
            //       style: ElevatedButton.styleFrom(
            //           fixedSize: const Size(100, 40),
            //           backgroundColor: Colors.indigo.shade900,
            //           padding: const EdgeInsets.symmetric(
            //               horizontal: 10, vertical: 5),
            //           textStyle: const TextStyle(
            //               fontSize: 20, fontWeight: FontWeight.bold)),
            //       onPressed: () {
            //         addTask();
            //       },
            //       child: Text(
            //         "Save",
            //         style: TextStyle(color: Colors.white),
            //       )),
            // )
          ],
        ),
      ),
    );
  }

  Future<void> addTask() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var id = prefs.get('caregiverId');
      var token = prefs.get('user_access_token');

      final response = await Dio().post('$url/api/task', data: {
        "name":nameController.text,
        "details":descriptionController.text,
        "time":time.text,
        "repeats_per_day":selectedNumber,
        "start_date": startDate.text,
        "end_date": endDate.text,
        "repeat_typeID":selectRepeatId(selectItem),
        "days":_selectedDays,
        "patient_id": '$patientId',
      }, queryParameters: {
        'token': '$token'
      });
      print(response);
      if (response.data['status'] == 200 || response.data['status'] == 201) {
        context.read<AllTasksCubit>().getAllTasks(patientId);
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
