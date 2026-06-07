// login_remote_data_source.dart
import 'package:citzenapp/core/resource/baseurl.dart';
import 'package:citzenapp/core/service/apiConsumer.dart';
import 'package:citzenapp/core/service/reqestType.dart';

abstract class LoginRemoteDataSource {
  Future<Map<String, dynamic>> login({required String userName, required String password});
}

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  final ApiConsumer apiConsumer;

  LoginRemoteDataSourceImpl(this.apiConsumer);

  @override
  Future<Map<String, dynamic>> login({required String userName, required String password}) async {
    // إرسال الطلب بحسب مسار الـ API الخاص بالـ Login لديكِ (مثلاً: /api/auth/login)
    final response = await apiConsumer.request(
      path:url.login , 
      method: RequestType.post,
      data: {
        "userName": userName,
        "password": password,
      },
    );
    return response;
  }
}