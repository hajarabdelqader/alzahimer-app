import 'package:bloc/bloc.dart';
import 'package:gp_project/models/tasks_model.dart';
import 'package:gp_project/repo/tasks_repo.dart';
import 'package:meta/meta.dart';

part 'all_tasks_state.dart';

class AllTasksCubit extends Cubit<AllTasksState> {
  AllTasksCubit() : super(AllTasksInitial());
  void getAllTasks(pId) async {
    try {
      print( 'tasks $pId');

      emit(LoadingAllTasks());

      print( 'tasks $pId');

      TasksModel tasks = await TasksRepo().getAllTasks(pId);

      emit(GetAllTasksSucsses(tasks));

    } on Exception catch (e) {

      emit(ErorrInAllTasks(e));
    }

  }

}
