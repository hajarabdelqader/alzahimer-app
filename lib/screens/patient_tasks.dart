
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gp_project/cubits/AllTasks_cubite/all_tasks_cubit.dart';
import 'package:gp_project/screens/task_details.dart';


class PatientTasks extends StatefulWidget {
  PatientTasks(this.pId);
  var pId;

  @override
  State<PatientTasks> createState() => _PatientTasksState();
}

class _PatientTasksState extends State<PatientTasks> {
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
        title: Text('MyTasks', style: TextStyle(color: Colors.white)),
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
                return Center(child: Text("no data yet",style:TextStyle(fontWeight:FontWeight.w700) ));
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
                      title: Text(tasks.data![index].name!),
                      subtitle: Text(
                        tasks.data![index].time!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      // trailing: Row(
                      //   mainAxisSize: MainAxisSize.min,
                      //   children: [
                      //     GestureDetector(
                      //         onTap: () { deletTask(tasks.data![index].id!);},
                      //         child: Icon(
                      //           Icons.delete_outline,
                      //           color: Colors.indigo.shade900,
                      //         )),
                      //     SizedBox(width: 10),
                      //     GestureDetector(
                      //         onTap: () {
                      //           Navigator.of(context)
                      //               .push(MaterialPageRoute(builder: (context) {
                      //             return UpdateTask( taskdata:tasks.data![index]);
                      //           }));
                      //
                      //         },
                      //         child: Icon(
                      //           Icons.edit_outlined,
                      //           color: Colors.indigo.shade900,
                      //         )),
                      //   ],
                      // ),
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

    );
  }

}
