
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gp_project/cubits/CareProfile_cubite/care_profile_cubit.dart';

import 'package:gp_project/screens/login_screen.dart';

class CareProfile extends StatefulWidget {
  @override
  State<CareProfile> createState() => _CareProfileState();
}

class _CareProfileState extends State<CareProfile> {
  // CareProfile({Key? key, required this.caregiverInfo}) : super(key: key);
  @override
  void initState() {
    // TODO: implement initState
    context.read<CareProfileCubit>().getCaregiver();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.indigo.shade900,
          title: Text(
            "profile",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocBuilder<CareProfileCubit, CareProfileState>(
            builder: (context, state) {
          if (state is LoadingCareData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is GetCareDataSuccess) {
            final caredata = state.caredata;
             print('caregiver id ${caredata.id}');
            return ListView(
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Container(
                      height: 100,
                      alignment: Alignment.topLeft,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage:
                              AssetImage("assets/images/user3.png"),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(caredata.name!,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500),
                    )
                  ],
                ),
                ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  leading: Icon(Icons.email_outlined),
                  title: Text(caredata.email!),
                  subtitle: Text(caredata.email!),
                ),
                Divider(
                  thickness: 1,
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) {
                          return LoginPage();
                        }), (route) => false);
                  },
                  trailing: Icon(Icons.arrow_forward_sharp),
                  title: Text(
                    "Logout",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            );
          };
          if (state is ErrorInCareData) {
            return Text('No Internet Connection!');
          }
          return Text('Try Again Later!');
        }),
      ),
    );
  }

  // @override
  // void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  //   super.debugFillProperties(properties);
  //   properties.add(DiagnosticsProperty<LoginModel>('caregiverInfo', caregiverInfo));
  // }
}
