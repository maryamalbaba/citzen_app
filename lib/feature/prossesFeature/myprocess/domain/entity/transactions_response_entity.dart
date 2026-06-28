import 'package:citzenapp/feature/prossesFeature/myprocess/domain/entity/pagenationEntity.dart';
import 'package:citzenapp/feature/prossesFeature/myprocess/domain/entity/reansaction_entity.dart';


class TransactionsResponseEntity {
  final List<TransactionEntity> items;
  final PaginationEntity pagination;

  const TransactionsResponseEntity({
    required this.items,
    required this.pagination,
  });
}