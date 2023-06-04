
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gp_project/models/allpatient_repo_model.dart';
import 'package:gp_project/repo/all_patient_repository.dart';
part 'all_patient_state.dart';

class AllPatientCubit extends Cubit<AllPatientState> {
  AllPatientCubit() : super(AllPatientInitial());

  void getAllPatient() async {
    try {
      emit(LoadingAllPatient());

      final AllPatientRepoModel allpatient= await AllPatientRepo().getAllPatient();

      emit(GetAllPatientSuccess(allpatient));
    }
    on Exception

    catch(e){
      emit(ErrorInAllPatient(e));
    }


  }


}

