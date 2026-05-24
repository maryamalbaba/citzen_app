abstract class Failure {
  final String message;

  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure(super.message);
}

class UnauthorizedFailure extends Failure {
  UnauthorizedFailure(super.message);
}

class CacheFailure extends Failure {
  CacheFailure(super.message);
}


class EmptyCacheFailure
    extends Failure {

  EmptyCacheFailure(super.message);
}

class EmptyDataFailure extends Failure {
  EmptyDataFailure(super.message);
}