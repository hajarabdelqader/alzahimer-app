
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gp_project/cubits/AllPatient_cubite/all_patient_cubit.dart';
import 'package:gp_project/main.dart';
import 'package:gp_project/screens/caregiver_notification.dart';
import 'package:gp_project/screens/navbar_caregiver.dart';
import 'package:gp_project/screens/navbar_patient.dart';
import 'package:gp_project/screens/update_patient.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CaregiverHome2 extends StatefulWidget {
  @override
  State<CaregiverHome2> createState() => _CaregiverHomeState2();
}

class _CaregiverHomeState2 extends State<CaregiverHome2> {
  // const CaregiverHome({Key? key}) : super(key: key);
  @override
  void initState() {
    // TODO: implement initState
    context.read<AllPatientCubit>().getAllPatient();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('AllPatients'),
        backgroundColor: Colors.indigo.shade900,
        actions: [
          IconButton(
              icon: Icon(Icons.notification_important,
                  color: Colors.white, size: 32.0),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)
                => CareNotification()),);
              }
          )
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<AllPatientCubit, AllPatientState>(
          builder: (context, state) {

            if (state is LoadingAllPatient) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is GetAllPatientSuccess) {
              final listofallpatient = state.allpatientList;
              if(listofallpatient.data!.isEmpty){
                return Center(child: Text("no data yet",style:TextStyle(fontWeight:FontWeight.w700) ));
              }else {
                return Container(

                  child: Padding(

                    padding: const EdgeInsets.all(9.0),
                    child: Expanded(
                      child: ListView.builder(
                         physics: BouncingScrollPhysics(),
                         scrollDirection: Axis.vertical,
                        itemCount: listofallpatient.data!.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) {
                                  return NavPatient(
                                    patientInfo: listofallpatient.data![index],
                                  );
                                }),
                              );
                            },
                            child: Row(


                              children:[
                                CircleAvatar(
radius: 50,
                                  backgroundImage:NetworkImage(
                                          listofallpatient.data![index].photo!)
                                ),
                                 SizedBox(width: 20,),
                                Padding(

                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5),
                                  child: Container(
                                    height:120,

                                    decoration: BoxDecoration(
                                      //boxShadow:B,
                                        borderRadius: BorderRadius.circular(7),
                                        border: Border(
                                            right: BorderSide(
                                                width: 1,
                                                color: Colors.indigo),
                                            left: BorderSide(
                                                width: 1,
                                                color: Colors.indigo),
                                            bottom: BorderSide(
                                                width: 1,
                                                color: Colors.indigo),
                                            top: BorderSide(
                                                width: 1,
                                                color: Colors.indigo))),
                              child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('hi'),
                                      SizedBox(width: 140,),
                                      GestureDetector(
                                          onTap: () { deletPatient(listofallpatient.data![index].id!);},
                                          child: Icon(
                                            Icons.delete_outline,
                                            color: Colors.indigo.shade900,
                                          )),
                                      SizedBox(width: 20),
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(builder: (context) {
                                              return  UpdatePatient(
                                                allPatientRepoModel: listofallpatient,index: index,
                                              );
                                            }));

                                          },
                                          child: Icon(
                                            Icons.edit_outlined,
                                            color: Colors.indigo.shade900,
                                          )),
                                    ],
                                  ),
                            ),
                                ),
                            ]),
                          );

                        },
                      ),
                    ),
                  ),
                );}
            }
            if (state is ErrorInAllPatient) {
              return Text('No Internet Connection!');
            }

            return Text('Try Again Later!');
          },
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.person_add),
      //   backgroundColor: Colors.teal.shade900,
      //   foregroundColor: Colors.white,
      //   onPressed: () => {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => AddPatient()),
      //     ).then((res) => AllPatientRepo().getAllPatient())
      //   },
      // ),
    );
  }

  Future<void> deletPatient(int patientid) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      var token = prefs.get('user_access_token');

      final response = await Dio().get(
          '$url/api/patient/delete/$patientid',
          queryParameters: {'token': '$token'});
      print(response);

      if (response.data['status'] == 200 || response.data['status'] == 201) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) {
              return NavCare();
            }), (route) => false);
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
