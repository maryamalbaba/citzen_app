import 'package:citzenapp/core/resource/api.dart';
import 'package:citzenapp/core/service/apiConsumer.dart';
import 'package:citzenapp/core/service/reqestType.dart';
import 'package:citzenapp/feature/prossesFeature/myprocess/data/models/responseteansaction.dart';

import '../models/transaction_model.dart';

abstract class TransactionRemoteDataSource {
  Future<TransactionsResponseModel> getTransactions({
    required int page,
    required int limit,
  });
}


class TransactionRemoteDataSourceImpl
    implements TransactionRemoteDataSource {

  final ApiConsumer api;

  TransactionRemoteDataSourceImpl( {
    required this.api,
  });

  @override
  Future<TransactionsResponseModel> getTransactions({
    required int page,
    required int limit,
  }) async {

    final response = await api.request(
      path: url.myTransactions,
      method: RequestType.get,
      queryParameters: {
        'page': page,
        'limit': limit,
      },
    );

    return TransactionsResponseModel.fromJson(
  response['data'],
);}
}