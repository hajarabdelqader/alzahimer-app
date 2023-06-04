part of 'patient_notification_cubit.dart';

@immutable
abstract class PatientNotificationState {}

class PatientNotificationInitial extends PatientNotificationState {}

class GetPatientNotifiSucsses extends PatientNotificationState {

  final PatientNotifiModel patientNotifiList;

  GetPatientNotifiSucsses(this.patientNotifiList);
}

class LoadingPatientNotifi extends PatientNotificationState {}

class ErorrInPatientNotifi extends PatientNotificationState {
  Exception error;

  ErorrInPatientNotifi(this.error);
}
