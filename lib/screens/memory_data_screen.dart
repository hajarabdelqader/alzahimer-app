
import 'package:flutter/material.dart';
import 'package:gp_project/models/memories_model.dart';
import 'package:gp_project/screens/update_memory.dart';



class MemoryData extends StatefulWidget {


  const MemoryData({Key? key, required this.memorydata}) : super(key: key);
  final Data memorydata;



  @override
  State<MemoryData> createState() => _MemoryDataState();
}

class _MemoryDataState extends State<MemoryData> {
  // const MemoryData({Key? key}) : super(key: key);
  // String title = "Title: Birthday party";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
       // toolbarHeight: 70,
        backgroundColor: Colors.indigo.shade900,
        title: Text('MemoryDetails'),
      ),
      body: SafeArea(
        child: ListView(scrollDirection: Axis.vertical, children: [
          Column(
            children: [
              SizedBox(height:7),

              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 1, color: Colors.white),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 20, offset: const Offset(5, 5),),
                  ],
                ),
                child:  Container(
                  width: 250,
                  height:250,
                  child: Center(
                    child:Image.network(widget.memorydata.photo!,fit: BoxFit.fill, ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            width: 60,
            height: 60,
            alignment: Alignment.bottomLeft,
            child: Text("Title: ${widget.memorydata.name}",style: TextStyle(
              fontSize: 20,
              fontStyle: FontStyle.italic,
              color: Colors.black,

            ),),
          ),
          //SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(10.0),
            width: 100,
            height: 100,
            alignment: Alignment.bottomLeft,
            child: Text( "Description:${widget.memorydata.description} ",style: TextStyle(
              fontSize: 20,
              fontStyle: FontStyle.italic,
              color: Colors.black,

            ),),
          ),

          Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.bottomRight,
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.indigo.shade700, //<-- SEE HERE
                child: IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return UpdateMemory(memorydata: widget.memorydata);
                    }));

                  },
                ),
              )
          )

        ]),
      ),
    );
  }
}