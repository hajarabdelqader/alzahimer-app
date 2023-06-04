

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gp_project/models/allpatient_repo_model.dart';
import 'package:gp_project/screens/all_tasks.dart';
import 'package:gp_project/screens/memory_screen.dart';
import 'package:gp_project/screens/patient_info.dart';



class NavPatient extends StatefulWidget {

 // const HomePage({Key? key}) : super(key: key);

  NavPatient({Key? key, required this.patientInfo,}) : super(key: key);

  final Data patientInfo;

  @override
  State<NavPatient> createState() => _NavPatientState();
}


class _NavPatientState extends State<NavPatient> {
  @override
  int navigationIndex = 0;

  Widget build(BuildContext context) {

    List<Widget> screenList = [
      PatientInfo(patientInfo : widget.patientInfo),

      MemoryScreen(widget.patientInfo.id),

      AllTasks(widget.patientInfo.id),

      // LocationScreen(),
    ];
    return Scaffold(

      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor:Colors.indigo ,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          setState(() {
            navigationIndex = index;
          });
        },
        currentIndex:  navigationIndex,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.person), label: "Patient"),
          const BottomNavigationBarItem(icon: Icon(Icons.monochrome_photos), label: "Memory"),
          const BottomNavigationBarItem(icon: Icon(Icons.table_chart), label: "Schedule"),
          //const BottomNavigationBarItem(icon: Icon(Icons.location_on_rounded), label: "Location"),

        ],
      ),
      body: screenList[navigationIndex],


    );
  }
}