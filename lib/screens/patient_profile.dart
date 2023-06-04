
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:gp_project/main.dart';
import 'package:gp_project/models/allpatient_repo_model.dart';
import 'package:gp_project/screens/navbar_caregiver.dart';
import 'package:gp_project/screens/patient_notification.dart';

import 'package:shared_preferences/shared_preferences.dart';


class PatientProfile extends StatelessWidget {
//const PatientInfo({Key? key}) : super(key: key);


  //عشان اباصي الداتا من اسكرينه الكير للبيشنت داتا
  const PatientProfile({Key? key, required this.patientInfo,}) : super(key: key);
  final Data patientInfo;



  //Color primaryColor = HexColor(' #38761d');
  //Color accentColor = HexColor(' #468468');


  @override
  Widget build(BuildContext context) {

    patientId =patientInfo.id!;
    print('patientId ${patientId}');

    var gender;
    if (patientInfo.gender==0){
      gender='female';
    }
    else {gender='male';}


    return Scaffold(
      //drawer: sideBar(),
        appBar: AppBar(
          // foregroundColor: Colors.red,
          backgroundColor:Colors.indigo.shade900,
          title: Text("MyProfile",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          actions: [
            IconButton(
                icon: Icon(

                    Icons.notification_important,
                    color: Colors.white,
                    size: 32.0),
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            PatientNotification(patientInfo.id)),);
                }
            ),],
        ),

        backgroundColor: Colors.white,
        body: SafeArea(
          // child: Container(
          //   color: Colors.white,
          //   width: MediaQuery.of(context).size.width,
            child: ListView(

                children: [
                  Container(height: 30, ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(width: 1, color: Colors.white),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 20,
                                  offset: const Offset(5, 5),
                                ),
                              ],
                            ),
                            child: Container(
                              width: 250,
                              height: 250,
                              child: Center(
                                child: Image.network(
                                  patientInfo.photo!,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),


                          //SizedBox(height: 40),
                          SizedBox(height: 20,),
                          Text(patientInfo.name!, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                          SizedBox(height: 5),
                          Card(
                            child: Container(
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      ...ListTile.divideTiles(
                                        color: Colors.grey,
                                        tiles: [
                                          ListTile(
                                            contentPadding: EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 4),
                                            leading: Icon(Icons.my_location),
                                            title: Text("Address"),
                                            subtitle: Text(patientInfo.address!),
                                          ),
                                          ListTile(
                                            leading: Icon(Icons.date_range),
                                            title: Text("BirthDate"),
                                            subtitle: Text(patientInfo.birthDate!),
                                          ),
                                          ListTile(
                                            leading: Icon(Icons.phone),
                                            title: Text("Phone"),
                                            subtitle: Text(patientInfo.phone!),
                                          ),
                                          ListTile(
                                            leading: Icon(Icons.person),
                                            title: Text("Gender"),
                                            subtitle: Text(gender),
                                          ),
                                          ListTile(
                                            onTap: (){
                                              // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                              //   return  NotificationScreen() ;
                                              // }));

                                            },
                                            trailing:Icon(Icons.keyboard_arrow_right) ,

                                            title: Text("About Me"),
                                            subtitle: Text(
                                                "This is my medical record "),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),

                          // ),
                        ]),
                  ),

                ]  )
        )

    );

  }


}