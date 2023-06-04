part of 'all_tasks_cubit.dart';

@immutable
abstract class AllTasksState {}

class AllTasksInitial extends AllTasksState {}


class GetAllTasksSucsses extends AllTasksState {

  final TasksModel TasksList;

  GetAllTasksSucsses(this.TasksList);
}

class LoadingAllTasks extends AllTasksState {}

class ErorrInAllTasks extends AllTasksState {
  Exception error;
  ErorrInAllTasks(this.error);
}

