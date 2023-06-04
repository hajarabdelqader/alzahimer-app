import 'package:bloc/bloc.dart';
import 'package:gp_project/models/patientNotifi_model.dart';
import 'package:gp_project/repo/PatientNotifi_repo.dart';
import 'package:meta/meta.dart';

part 'patient_notification_state.dart';

class PatientNotificationCubit extends Cubit<PatientNotificationState> {
  PatientNotificationCubit() : super(PatientNotificationInitial());

  void getPatientNotifi(pId) async {
    try {
      print( 'notifi $pId');

      emit(LoadingPatientNotifi());

      print( 'notifi $pId');

      PatientNotifiModel pNotifi = await  PatientNotifiRepo().getPatientNotifi(pId);

      emit(GetPatientNotifiSucsses(pNotifi));

    } on Exception catch (e) {

      emit(ErorrInPatientNotifi(e));
    }

  }



}
