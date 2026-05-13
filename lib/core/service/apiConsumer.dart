import 'package:citzenapp/core/service/reqestType.dart';

abstract class ApiConsumer {
  Future<dynamic> request({
    required String path,

    required RequestType method,

    dynamic data,

    Map<String, dynamic>? queryParameters,

    Map<String, dynamic>? headers,
  });
}


