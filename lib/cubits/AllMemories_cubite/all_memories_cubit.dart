import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gp_project/models/memories_model.dart';
import 'package:gp_project/repo/memories_repository.dart';
part 'all_memories_state.dart';
class AllMemoriesCubit extends Cubit<AllMemoriesState> {

  AllMemoriesCubit() : super(AllMemoriesInitial());
  void getAllMemories(pId) async {
    try {
      print( 'lllllllllllllll $pId');
      emit(LoadingMemories());
      print( 'lllllllllllllll $pId');

      MemoriesRepoModel memory = await MemoriesRepo().getAllMemories(pId);

      emit(GetMemoriesSuccess(memory));

    } on Exception catch (e) {

      emit(ErrorInMemories(e));
    }

  }

}

