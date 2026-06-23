import 'package:citzenapp/core/service/apiConsumer.dart';
import 'package:citzenapp/core/service/reqestType.dart';
import 'package:citzenapp/feature/prossesFeature/processes/data/models/auth_process_model.dart';

abstract class AuthProcessRemoteDataSource {
  Future<ProcessAuthResponse> getAuthProcesses({
    required num id,
    required int page,
    required int limit,
  });
}

class AuthProcessRemoteDataSourceImpl implements AuthProcessRemoteDataSource {
  final ApiConsumer api;

  AuthProcessRemoteDataSourceImpl({required this.api});

  @override
  Future<ProcessAuthResponse> getAuthProcesses({
    required num id,
    required int page,
    required int limit,
  }) async {
    // بناء المسار الديناميكي بدمج الـ ID
    final path = '/api/process_definitions/auth/$id';

    final response = await api.request(
      path: path,
      method: RequestType.get,
      queryParameters: {
        'page': page,
        'limit': limit,
      },
    );

    // الـ DioConsumer يرجع الـ response.data مباشرة (وهو عبارة عن Map)
    return ProcessAuthResponse.fromJson(response);
  }
}