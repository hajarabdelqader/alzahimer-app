import 'dart:async';
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class Task {
  final int id;
  final String name;
  final String details;
  final DateTime time;
  final int status;
  final int repeatsPerDay;
  final DateTime startDate;
  final DateTime endDate;
  final String repeatType;
  final int patientId;

  Task({
    required this.id,
    required this.name,
    required this.details,
    required this.time,
    required this.status,
    required this.repeatsPerDay,
    required this.startDate,
    required this.endDate,
    required this.repeatType,
    required this.patientId,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      name: json['name'],
      details: json['details'],
      time: DateTime.parse(json['time']),
      status: json['status'],
      repeatsPerDay: json['repeats_per_day'],
      startDate: DateTime.parse(json['Start_date']),
      endDate: DateTime.parse(json['End_date']),
      repeatType: json['Repeat Type'],
      patientId: json['patient_id'],
    );
  }



}

// //دي اول واجده خالص اللي اشتغلت اول مره قبل ما اضيف تاسكايه
// //Define a method to fetch the list of tasks from the API and cache them in SharedPreferences
void  fetchTasksAndCache(int pId, String pToken) async {
  final response = await http.get(Uri.parse('$url/api/tasks/today/$pId?token=$pToken'));

  List<dynamic> tasksJson = jsonDecode(response.body)['data'];
  List<Task> tasks = tasksJson.map((json) => Task.fromJson(json)).toList();

  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('cachedTasks', jsonEncode(tasksJson));

  print(" fetch task and cach  $response");

}

// //كود اللود القديم


Future<List<Task>> loadCachedTasks() async {
  print(" on load cached");

  final prefs = await SharedPreferences.getInstance();
  String? cachedTasksJson = prefs.getString('cachedTasks');

  print(prefs);//get instance

  if (cachedTasksJson != null) {
    List<dynamic> tasksJson = jsonDecode(cachedTasksJson);
    print(tasksJson);
    print(' on if on load');

    return tasksJson.map((json) => Task.fromJson(json)).toList();
  } else {
    print("on lad on else");
    return [];
  }
  }




Future<void> checkNotificationTimesForTasks() async {
  List<Task> tasks = await loadCachedTasks();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
    "channel_id",
    "channel_name",
    importance: Importance.max,
    priority: Priority.high,
    showWhen: false,

  );
  const NotificationDetails platformChannelSpecifics =
  NotificationDetails(android: androidPlatformChannelSpecifics);

  var currentTime = DateTime.now();
  if (tasks.isNotEmpty){
    for (var task in tasks) {
      if (task.time.hour == currentTime.hour &&
          task.time.minute == currentTime.minute ) {
        await flutterLocalNotificationsPlugin.show(
          task.id,
          task.name,
          task.details,
          platformChannelSpecifics,
          payload: jsonEncode({
            "type": "task",
            "id": task.id.toString(),
            "isTaskNotification": true
          }),

        );
      }
    }
} else print('no notiiiiii');
}

// Define a method to schedule the timer to check the notification time every 1 minute
void scheduleNotificationTimer() {
  Timer.periodic(Duration(seconds: 50), (timer) async {
    print("Checking notification times...");
    await checkNotificationTimesForTasks();
  });
}