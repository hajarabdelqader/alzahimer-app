part of 'all_noti_cubit.dart';

@immutable
abstract class AllNotiState {}

class AllNotiInitial extends AllNotiState {}

class GetAllNotifiSuccess extends AllNotiState {

  final CareNotifiModel allNotifiList;

  GetAllNotifiSuccess(this.allNotifiList);
}
class LoadingAllNotifi extends AllNotiState {}


class ErrorInAllNotifi extends AllNotiState {
  final Exception error;
  ErrorInAllNotifi(this.error);
}