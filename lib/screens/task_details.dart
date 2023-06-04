
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gp_project/cubits/AllTasks_cubite/all_tasks_cubit.dart';
import 'package:gp_project/models/tasks_model.dart';

import 'package:gp_project/screens/update_task.dart';


class TaskDetails extends StatefulWidget {

  const TaskDetails({Key? key, required this.taskData}) : super(key: key);
  final Data taskData;

  @override
  State<TaskDetails> createState() => _TaskDetailsState();


}


class _TaskDetailsState extends State<TaskDetails> {
  @override
  void initState() {
    super.initState();
    context.read<AllTasksCubit>().getAllTasks(widget.taskData.patientId);// basy el id ll cubite
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // leading:  IconButton(
        //   icon: Icon(Icons.arrow_back,color: Colors.white,),
        //   onPressed: () {
        //   Navigator.of(context).pop();
        //   },
        // ),
        backgroundColor: Colors.indigo.shade900,
        title: Text('Task Details', style: TextStyle(color: Colors.white)),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Card(
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        ...ListTile.divideTiles(
                          color: Colors.grey,
                          tiles: [
                            ListTile(
                              leading: Icon(Icons.title),
                              title: Text(widget.taskData.name!),
                              subtitle: Text("task name"),
                            ),
                            ListTile(
                              leading: Icon(Icons.description),
                              title: Text(widget.taskData.details!),
                              subtitle: Text("Task details"),
                            ),
                            ListTile(
                              leading: Icon(Icons.date_range),
                              title: Text(widget.taskData.startDate!),
                              subtitle: Text("Start date"),
                            ),
                            ListTile(
                              leading: Icon(Icons.date_range),
                              title: Text(widget.taskData.endDate!),
                              subtitle: Text("End date"),
                            ),
                            ListTile(
                              leading: Icon(Icons.timer),
                              title: Text(widget.taskData.time!),
                              subtitle: Text("Task time"),
                            ),
                            ListTile(
                              leading: Icon(Icons.repeat),
                              title: Text("Repeat per day"),
                              subtitle: Text(widget.taskData.repeatsPerDay!.toString()),
                            ),
                            ListTile(
                              leading: Icon(Icons.replay_5),
                              title: Text("Repeat type"),
                              subtitle: Text(widget.taskData.repeatType!),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            // Container(
            //     padding: EdgeInsets.all(10.0),
            //     alignment: Alignment.bottomRight,
            //     child: CircleAvatar(
            //       radius: 30,
            //       backgroundColor: Colors.indigo.shade900, //<-- SEE HERE
            //       child: IconButton(
            //         icon: Icon(
            //           Icons.edit,
            //           color: Colors.white,
            //         ),
            //         onPressed: () {
            //           Navigator.of(context)
            //               .push(MaterialPageRoute(builder: (context) {
            //             return UpdateTask(taskdata:widget.taskData);
            //           }));
            //
            //         },
            //       ),
            //     )
            // )
          ],

        ),
      ),
    );
  }
}