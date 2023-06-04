import 'package:bloc/bloc.dart';
import 'package:gp_project/models/CaregiverNotifi_Model.dart';
import 'package:gp_project/repo/allNotifi_repo.dart';
import 'package:meta/meta.dart';

part 'all_noti_state.dart';

class AllNotiCubit extends Cubit<AllNotiState> {
  AllNotiCubit() : super(AllNotiInitial());

  void getAllNotifi() async {
    try {
      emit(LoadingAllNotifi());

      final CareNotifiModel allNotifi= await AllNotifiRepo().getAllNotifi();

      emit(GetAllNotifiSuccess(allNotifi));
    }
    on Exception

    catch(e){

      emit(ErrorInAllNotifi(e));
    }


  }


}