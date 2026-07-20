import 'package:citzenapp/core/resource/api.dart';
import 'package:citzenapp/core/service/apiConsumer.dart';
import 'package:citzenapp/core/service/reqestType.dart';


abstract class LogoutRemoteDataSource {
  Future<bool> logout({required String refreshToken});
}

class LogoutRemoteDataSourceImpl implements LogoutRemoteDataSource {
  final ApiConsumer apiConsumer;

  LogoutRemoteDataSourceImpl(this.apiConsumer);

  @override
  Future<bool> logout({required String refreshToken}) async {
    final response = await apiConsumer.request(
      path: url.logout,
      method: RequestType.post,
      data: {
        'refreshToken': refreshToken,
      },
    );

    // Matches your specific response schema structure: response['success']
    if (response != null && response['success'] == true) {
      return response['data']['revoked'] ?? true;
    }
    return false;
  }
}