
import 'package:citzenapp/feature/prossesFeature/myprocess/domain/entity/reansaction_entity.dart';
import 'package:citzenapp/feature/prossesFeature/myprocess/domain/entity/transactions_response_entity.dart';
import 'package:citzenapp/feature/prossesFeature/myprocess/domain/repo/transaction_repository.dart';

class GetTransactionsUseCase {
  final TransactionRepository repository;

  GetTransactionsUseCase(
    this.repository,
  );

  Future<TransactionsResponseEntity> call({
    required int page,
    required int limit,
  }) {
    return repository.getTransactions(
      page: page,
      limit: limit,
    );
  }
}