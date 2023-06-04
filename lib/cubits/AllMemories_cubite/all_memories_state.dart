part of 'all_memories_cubit.dart';


@immutable
abstract class AllMemoriesState {}

class AllMemoriesInitial extends AllMemoriesState {}
class GetMemoriesSuccess extends AllMemoriesState{

  final MemoriesRepoModel memoriesList;

  GetMemoriesSuccess(this.memoriesList);

 get listOfMemories => null;
}
class LoadingMemories extends AllMemoriesState {}

class ErrorInMemories extends AllMemoriesState {
  final Exception error;

  ErrorInMemories(this.error);
}