import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gp_project/cubits/AllMemories_cubite/all_memories_cubit.dart';
import 'package:gp_project/cubits/AllPatient_cubite/all_patient_cubit.dart';
import 'package:gp_project/cubits/AllTasks_cubite/all_tasks_cubit.dart';
import 'package:gp_project/cubits/CareNotifi_cubite/all_noti_cubit.dart';
import 'package:gp_project/cubits/CareProfile_cubite/care_profile_cubit.dart';
import 'package:gp_project/cubits/PatientNotification_cubite/patient_notification_cubit.dart';
import 'package:gp_project/screens/cach_notifi.dart';
import 'package:gp_project/screens/class_notification.dart';
import 'package:gp_project/screens/confirm.dart';
import 'package:gp_project/screens/login_screen.dart';
import 'package:gp_project/screens/navbar_caregiver.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';



var url ='https://egip-2023.000webhostapp.com';
var patientId=0;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  Widget? widget ;
  var shared=await SharedPreferences.getInstance();
  String?token= shared.getString('user_access_token') ;
  if (token != null){
    widget=NavCare();
  }else
    widget=LoginPage();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) async {
      final Map<String, dynamic> payload = jsonDecode(response.payload ?? '{}');
      final bool isTaskNotification = payload.containsKey('isTaskNotification')
          ? payload['isTaskNotification']
          : false;
      if (isTaskNotification) {
        // Navigate to the task details page when a task notification is tapped
        navigatorKey.currentState!.push(
          MaterialPageRoute(builder: (context) => Confirm()),
        );
      }
    },
  );

  runApp(MyApp(widget: widget,));

}

class MyApp extends StatefulWidget {
  final Widget widget;
  const MyApp({super.key, required this.widget});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
  String _eventData = '';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    clearCachedTasks(); // clear cached data when app is started
    //fetchTasksAndCache();
    loadCachedTasks();
    scheduleNotificationTimer(); // load cached tasks data
    _setupPusher();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {}

  Future<void> clearCachedTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("cachedTasks");
  }

  void _setupPusher() async {

    PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
    try {
      await pusher.init(
        apiKey: 'c4413d2d7f467e740c8e',
        cluster: 'ap1',
        onConnectionStateChange: onConnectionStateChange,
        onError: onError,
        onSubscriptionSucceeded: onSubscriptionSucceeded,
        //onEvent: onEvent,
        onSubscriptionError: onSubscriptionError,
      );
      // await pusher.subscribe(channelName: 'my-channel');
      final rasberryChannel = await pusher.subscribe(
          channelName: "rpi-notify",
          onEvent: (event) async {
            var data = event.data;
            print(data);
            final rassData = jsonDecode(event.data);

            print('hiii 2');

             final patient_id = rassData["patient_id"];
            List<dynamic> caregiversId = rassData["caregiver_Ids"];

             print(patient_id);
            final prefs = await SharedPreferences.getInstance();
            var pId =prefs.getInt('patientId');
            var careId =prefs.getInt('caregiverId');
            print(careId);
            print(caregiversId.contains(careId));
             if(pId == patient_id || caregiversId.contains(careId)){

            LocalNotifications.pushNotifications('rasberryBiNotification', rassData["message"]);}

           // print("Got channel event: $event");
          }
      );
      /////////////channel 2 ll tasks
      print('on channel 2');

      final tasksChannel = await pusher.subscribe(
          channelName: "Tasks-event",
          onEvent: (event) async {
            final prefs = await SharedPreferences.getInstance();
            var pId =prefs.getInt('patientId');
            var pToken= prefs.getString('user_access_token');

            print ("on taskk channel pusher");
            final tasksData = jsonDecode(event.data);
            print("task data$tasksData");
            print(pId);
            print (tasksData['patient_id']);
            print(pToken);


            if(pId==tasksData['patient_id']) {
              clearCachedTasks();
              print(' on if channel 2');
              fetchTasksAndCache(pId!, pToken!);
            }
          }
      );
      await pusher.connect();
    } catch (e) {
      print("ERROR: $e");
    }
  }


  void onSubscriptionSucceeded(String channelName, dynamic data) {
    print("onSubscriptionSucceeded: $channelName data: $data");
  }

  void onEvent(PusherEvent event) {
    setState(() {
      _eventData = event.data;
    });
    print('Received event ${event.eventName} from channel ${event.channelName} with data ${event.data}');
  }

  void onSubscriptionError(String message, dynamic e) {
    print("onSubscriptionError: $message Exception: $e");
  }
  void onConnectionStateChange(dynamic currentState, dynamic previousState) {
    print("Connection: $currentState");
  }

  void onError(String message, int? code, dynamic e) {
    print("onError: $message code: $code exception: $e");
  }



  // Color _primaryColor = HexColor(' #38761d');
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AllPatientCubit()..getAllPatient()),
        BlocProvider(create: (context) => AllMemoriesCubit()),
        BlocProvider(create: (context) => CareProfileCubit()),
        BlocProvider(create: (context) => AllTasksCubit()),
        BlocProvider(create: (context) => PatientNotificationCubit()),
        BlocProvider(create: (context) => AllNotiCubit()),

      ],
      child: MaterialApp(
        home:LoginPage(),
        debugShowCheckedModeBanner: false, //bashel el shretaa
        navigatorKey: navigatorKey,
      ),



    );
  }
}

