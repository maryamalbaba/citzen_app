import 'package:citzenapp/feature/prossesFeature/myprocess/data/source/transaction_remote_datasource.dart';
import 'package:citzenapp/feature/prossesFeature/myprocess/domain/entity/reansaction_entity.dart';
import 'package:citzenapp/feature/prossesFeature/myprocess/domain/entity/transactions_response_entity.dart';
import 'package:citzenapp/feature/prossesFeature/myprocess/domain/repo/transaction_repository.dart';


class TransactionRepositoryImpl
    implements TransactionRepository {

  final TransactionRemoteDataSource remote;

  TransactionRepositoryImpl({
    required this.remote,
  });

  @override
  Future<TransactionsResponseEntity>
      getTransactions({
    required int page,
    required int limit,
  }) {

    return remote.getTransactions(
      page: page,
      limit: limit,
    );
  }
}