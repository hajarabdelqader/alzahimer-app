import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gp_project/cubits/AllTasks_cubite/all_tasks_cubit.dart';
import 'package:gp_project/main.dart';
import 'package:gp_project/screens/add_task.dart';

import 'package:gp_project/screens/task_details.dart';
import 'package:gp_project/screens/update_task.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllTasks extends StatefulWidget {
  AllTasks(this.pId);
  var pId;

  @override
  State<AllTasks> createState() => _AllTasksState();
}

class _AllTasksState extends State<AllTasks> {
  @override
  void initState() {
    // TODO: implement initState
    context.read<AllTasksCubit>().getAllTasks(widget.pId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade900,
        title: Text('AllTasks', style: TextStyle(color: Colors.white)),
      ),
      body: SafeArea(
        child: BlocBuilder<AllTasksCubit, AllTasksState>(
          builder: (context, state) {
            if (state is LoadingAllTasks) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is GetAllTasksSucsses) {
              final tasks = state.TasksList;
              if(tasks.data!.isEmpty){
                return Center(child: Text("no data yet",
                    style:TextStyle(fontWeight:FontWeight.w700) ));
              }else {
              return ListView.builder(
                itemCount: tasks.data!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(15),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(context,MaterialPageRoute(
                              builder: (context) => TaskDetails(taskData: tasks.data![index]),
                        ),);
                      },
                      /* leading: Container(
                      width: 80,
                      height:80,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage("assets/images/download.png"),
                              fit: BoxFit.cover)),
                    ),*/
                      title: Text(tasks.data![index].name!),
                      subtitle: Text(
                        tasks.data![index].time!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                              onTap: () { deletTask(tasks.data![index].id!);},
                              child: Icon(
                                Icons.delete_outline,
                                color: Colors.indigo.shade900,
                              )),
                          SizedBox(width: 20),
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return UpdateTask( taskdata:tasks.data![index]);
                                }));

                              },
                              child: Icon(
                                Icons.edit_outlined,
                                color: Colors.indigo.shade900,
                              )),
                        ],
                      ),
                    ),
                  );
                },
              );}
            }
            if (state is ErorrInAllTasks) {
              return Text('No Internet Connection!');
            }

            return Text('Try Again Later!');
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // materialTapTargetSize: ,
        backgroundColor: Colors.indigo.shade900,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return AddTask();
          }));
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
  Future<void> deletTask(int taskId) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      var token = prefs.get('user_access_token');

      final response = await Dio().get(

          '$url/api/task/delete/$taskId',
          queryParameters: {'token': '$token'});

      print(response);

      if (response.data['status'] == 200 || response.data['status'] == 201) {
        context.read<AllTasksCubit>().getAllTasks(widget.pId);

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
