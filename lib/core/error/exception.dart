import 'package:citzenapp/core/error/faliure.dart';

class ServerException implements Exception {
  final String message;

  ServerException(this.message);
}

class UnauthorizedException implements Exception {
  final String message;

  UnauthorizedException(this.message);
}

class CacheException implements Exception {
  final String message;

  CacheException(this.message);
}

class EmptyCacheException
    implements Exception {

  final String message;

  EmptyCacheException(this.message);
}



/*Exception
 تحدث داخل:
 Data Layer
*/

