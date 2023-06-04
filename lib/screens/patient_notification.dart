
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gp_project/cubits/PatientNotification_cubite/patient_notification_cubit.dart';


class PatientNotification extends StatefulWidget {
  PatientNotification(this.pId);
  var pId;

  @override
  State<PatientNotification> createState() => _PatientNotificationState();
}

class _PatientNotificationState extends State<PatientNotification> {
  @override
  void initState() {
    // TODO: implement initState
    context.read<PatientNotificationCubit>().getPatientNotifi(widget.pId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade900,
        title: Text('MyNotfi', style: TextStyle(color: Colors.white)),
      ),
      body: SafeArea(
        child: BlocBuilder<PatientNotificationCubit, PatientNotificationState>(
          builder: (context, state) {
            if (state is LoadingPatientNotifi) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is GetPatientNotifiSucsses) {
              final pNotifi = state.patientNotifiList;
              if(pNotifi.data!.isEmpty){
                return Center(child: Text("no data yet",style:TextStyle(fontWeight:FontWeight.w700) ));
              }else {
                return ListView.builder(
                  itemCount: pNotifi.data!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(15),
                      child: ListTile(
                        onTap: () {
                        },
                        title: Text(pNotifi.data![index].message!),
                        subtitle: Text(
                          pNotifi.data![index].time!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
                  },
                );}
            }
            if (state is ErorrInPatientNotifi) {
              return Text('No Internet Connection!');
            }

            return Text('Try Again Later!');
          },
        ),
      ),

    );
  }

}
