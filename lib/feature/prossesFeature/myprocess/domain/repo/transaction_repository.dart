import 'package:citzenapp/feature/prossesFeature/myprocess/domain/entity/reansaction_entity.dart';
import 'package:citzenapp/feature/prossesFeature/myprocess/domain/entity/transactions_response_entity.dart';


abstract class TransactionRepository {
  Future<TransactionsResponseEntity>
      getTransactions({
    required int page,
    required int limit,
  });
}