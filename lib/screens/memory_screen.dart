import 'package:dio/dio.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gp_project/cubits/AllMemories_cubite/all_memories_cubit.dart';
import 'package:gp_project/main.dart';
import 'package:gp_project/screens/add_memory_screen.dart';
import 'package:gp_project/screens/memory_data_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemoryScreen extends StatefulWidget {
  MemoryScreen(this.pId);
  var pId; //b5zn el id mn argu fe slider ll constrctor

  @override
  State<MemoryScreen> createState() => _MemoryScreenState();
}

class _MemoryScreenState extends State<MemoryScreen> {
  // const MemoryScreen({Key? key}) : super(key: key);
  @override
  void initState() {
    super.initState();
    context
        .read<AllMemoriesCubit>()
        .getAllMemories(widget.pId); // basy el id ll cubite
  }

  Widget build(BuildContext context) {
    print(widget.pId);

    return Scaffold(
      //backgroundColor: Color(0xff100B20),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade900,
        title: Text('MemoryLibrary'),
        actions: [
          /* IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return PatientHome();
                }),
              );
            },
          ),
          */
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<AllMemoriesCubit, AllMemoriesState>(
          builder: (context, state) {
            if (state is LoadingMemories) {
              return Center(
                child: Container(
                  height: 50,
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (state is GetMemoriesSuccess) {
              final listOfMemories = state.memoriesList;
              if (listOfMemories.data!.isEmpty) {
                return Center(
                    child: Text("no data yet",
                        style: TextStyle(fontWeight: FontWeight.w700)));
              } else {
                return Expanded(
                  child: GridView.builder(
                    // padding:EdgeInsets.zero,
                    itemCount: listOfMemories.data!.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          /* Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            return MemoryData();
                          }),
                        );*/
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) {
                              return MemoryData(
                                  memorydata: listOfMemories.data![index]);
                            }),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.teal.shade900, width: 1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Image.network(
                                listOfMemories.data![index].photo!,
                                height:
                                    MediaQuery.of(context).size.width * 0.35,
                                width: MediaQuery.of(context).size.width * 0.8,
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Container(
                                //width: MediaQuery.of(context).size.width * 0.8,
                                //height: MediaQuery.of(context).size.height* 0.7,
                                margin: EdgeInsets.only(left: 8),
                                padding: EdgeInsets.only(left: 8),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.teal, width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      listOfMemories.data![index].name ?? '',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.teal.shade900,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    //SizedBox(width:15),
                                    /* GestureDetector(
                                  onTap: () {

                                  },
                                  child: Icon(Icons.edit_outlined,
                                  color: Colors.teal,)),*/
                                    Spacer(),
                                    GestureDetector(
                                        onTap: () {
                                          deletMemory(
                                              listOfMemories.data![index].id!);
                                        },
                                        child: Icon(
                                          Icons.delete_outlined,
                                          color: Colors.teal,
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.9,
                    ),
                  ),
                );
              }
            }
            if (state is ErrorInMemories) {
              return Text('No Internet Connection!');
            }

            return Text('Try Again Later!');
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.photo_filter_rounded),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        onPressed: () => {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return AddMemory();
          }))
        },
      ),
    );
  }

  Future<void> deletMemory(int memoryId) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      var token = prefs.get('user_access_token');

      final response = await Dio().get('$url/api/memory/delete/$memoryId',
          queryParameters: {'token': '$token'});
      print(response);
      if (response.data['status'] == 200 || response.data['status'] == 201) {
        context.read<AllMemoriesCubit>().getAllMemories(widget.pId);
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
