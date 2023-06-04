
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gp_project/models/login_model.dart';
import 'package:gp_project/screens/add_patient.dart';
import 'package:gp_project/screens/caregiver_home.dart';
import 'package:gp_project/screens/caregiver_profile.dart';

class NavCare extends StatefulWidget {

  // NavCare({this.careinfo});
  // LoginModel? careinfo;


  @override
  State<NavCare> createState() => _NavCareState();
}
class _NavCareState extends State<NavCare> {
  @override
  int navigationIndex = 0;

  Widget build(BuildContext context) {

    List<Widget> screenList = [
      CaregiverHome(),
      AddPatient(),
     CareProfile(),
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.indigo,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          setState(() {
            navigationIndex = index;
          });
        },
        currentIndex: navigationIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Patients"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add patient"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),


        ],
      ),
      body: screenList[navigationIndex],
    );
  }
}
