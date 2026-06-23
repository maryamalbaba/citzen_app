import 'package:citzenapp/core/resource/api.dart';
import 'package:citzenapp/core/service/apiConsumer.dart';
import 'package:citzenapp/core/service/reqestType.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> getTypeRemote();
}

class GetTypeProcSourceImpl implements AuthRemoteDataSource {
  final ApiConsumer api;

  GetTypeProcSourceImpl(this.api);

  @override
  Future<Map<String, dynamic>> getTypeRemote() async {
    final response = await api.request(
      path:
          url.getTypeProcess, // تأكدي من تحديث هذا المسار حسب الـ API الخاص بكِ

      method: RequestType.get,
    );

    return response;
  }
}
