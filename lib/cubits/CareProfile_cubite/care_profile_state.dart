part of 'care_profile_cubit.dart';

@immutable
abstract class CareProfileState {}

class CareProfileInitial extends CareProfileState {}

class GetCareDataSuccess extends CareProfileState {

  final CareProfileModel caredata;

  GetCareDataSuccess(this.caredata);
}
class LoadingCareData extends CareProfileState {}


class ErrorInCareData extends CareProfileState {
  final Exception error;
  ErrorInCareData(this.error);
}

