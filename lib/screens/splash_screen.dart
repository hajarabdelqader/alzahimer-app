//
//
// import 'package:flutter/material.dart';
//
// import 'package:gp_project/screens/login_screen.dart';
// import 'package:gp_project/screens/navbar_caregiver.dart';
//
//
// import 'package:shared_preferences/shared_preferences.dart';
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({Key? key}) : super(key: key);
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     initApp();
//   }
//
//   void initApp() {
//     Future.delayed(Duration(milliseconds: 2300), () async {
//       final prefs = await SharedPreferences.getInstance();
//       final accessToken = await prefs.get('user_access_token');
//       final careId= prefs.getInt('caregiverId');
//       // final patientId= prefs.getInt('patientId');
//       //
//       // print(prefs.getString('user_access_token'));
//
//       if (accessToken == null) {
//
//         Navigator.of(context).pushAndRemoveUntil(
//             MaterialPageRoute(builder: (context) {
//               return LoginPage();
//             }), (route) => false);
//
//       } else{
//
//         Navigator.of(context).pushAndRemoveUntil(
//             MaterialPageRoute(builder: (context) {
//               return NavCare();
//             }), (route) => false);
//       };
//
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//
//         child: Container(height: 250,
//             width: 200,
//             child: Image.asset('assets/images/logo.png', height: 80)),
//
//       ),
//     );
//   }
// }