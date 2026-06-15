import '../../domain/entity/entity.dart';

abstract class TypeProcessState {}

class TypeProcessInitial
    extends TypeProcessState {}

class TypeProcessLoading
    extends TypeProcessState {}

class TypeProcessLoaded
    extends TypeProcessState {

  final List<TypeProcessEntity>
      processes;

  TypeProcessLoaded(
    this.processes,
  );
}

class TypeProcessError
    extends TypeProcessState {

  final String message;

  TypeProcessError(
    this.message,
  );
}

class TypeProcessEmpty
    extends TypeProcessState {

  final String message;

  TypeProcessEmpty(
    this.message,
  );
}