import 'package:citzenapp/core/resource/baseurl.dart';
import 'package:citzenapp/core/service/apiConsumer.dart';
import 'package:citzenapp/core/service/reqestType.dart';
import 'package:citzenapp/feature/auth/register/data/model/requestmodel.dart';
import 'package:citzenapp/feature/auth/register/data/model/user_model.dart';
import 'package:citzenapp/feature/auth/register/data/source/remote_data_source.dart';

class AuthRemoteDataSourceImpl
    implements AuthRemoteDataSource {

  final ApiConsumer api;

  AuthRemoteDataSourceImpl(this.api);

  @override
  Future<Map<String, dynamic>>
      registerCitizen({
     required RegisterRequestModel user
  }) async {

    final response = await api.request(
      path:
          url.rgister, // تأكدي من تحديث هذا المسار حسب الـ API الخاص بكِ

      method: RequestType.post,

    data: user.toMap()
    );

    return response;
  }
}