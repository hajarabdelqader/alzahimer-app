import 'package:bloc/bloc.dart';
import 'package:gp_project/models/profilcare_model.dart';
import 'package:gp_project/repo/profilecare_repo.dart';
import 'package:meta/meta.dart';

part 'care_profile_state.dart';

class CareProfileCubit extends Cubit<CareProfileState> {
  CareProfileCubit() : super(CareProfileInitial());

  void getCaregiver() async {
    try {
      emit(LoadingCareData());

      final CareProfileModel caregiverdata= await CareProfileRepo().getCaregiver();

      emit(GetCareDataSuccess(caregiverdata));
    }
    on Exception

    catch(e){

      emit(ErrorInCareData(e));
    }


  }

}
