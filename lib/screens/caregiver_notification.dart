
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gp_project/cubits/CareNotifi_cubite/all_noti_cubit.dart';
import 'package:gp_project/cubits/PatientNotification_cubite/patient_notification_cubit.dart';


class CareNotification extends StatefulWidget {
  CareNotification();
  //var pId;

  @override
  State<CareNotification> createState() => _CareNotificationState();
}

class _CareNotificationState extends State<CareNotification> {
  @override
  void initState() {
    // TODO: implement initState
   context.read<AllNotiCubit>().getAllNotifi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade900,
        title: Text('MyNotifications', style: TextStyle(color: Colors.white)),
      ),
      body: SafeArea(
        child: BlocBuilder<AllNotiCubit, AllNotiState>(
          builder: (context, state) {
            if (state is LoadingAllNotifi) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is GetAllNotifiSuccess) {
              final careNotifi = state.allNotifiList;
              if(careNotifi.data!.isEmpty){
                return Center(child: Text("no data yet",style:TextStyle(fontWeight:FontWeight.w700) ));
              }else {
                return ListView.builder(
                  itemCount: careNotifi.data!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(15),
                      child: ListTile(
                        onTap: () {},
                        title: Text(careNotifi.data![index].patient!),
                        subtitle: Text(
                          careNotifi.data![index].message!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
                  },
                );}
            }
            if (state is ErrorInAllNotifi) {
              return Text('No Internet Connection!');
            }

            return Text('Try Again Later!');
          },
        ),
      ),

    );
  }

}
