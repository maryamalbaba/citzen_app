import 'package:citzenapp/core/service/apiConsumer.dart';
import 'package:citzenapp/core/service/reqestType.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> getTypeRemote();
}



class GetTypeProcSourceImpl
    implements AuthRemoteDataSource {

  final ApiConsumer api;

  GetTypeProcSourceImpl(this.api);

  @override
  Future<Map<String, dynamic>>
      getTypeRemote() async {

    final response = await api.request(
      path:
          '/api/typeProcess',

      method: RequestType.get,
    );

    return response;
  }
}
 
