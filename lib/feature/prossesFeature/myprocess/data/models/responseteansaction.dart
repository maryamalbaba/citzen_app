
import 'package:citzenapp/feature/prossesFeature/myprocess/data/models/pagenation2.dart';
import 'package:citzenapp/feature/prossesFeature/myprocess/domain/entity/transactions_response_entity.dart';

import 'transaction_model.dart';

class TransactionsResponseModel
    extends TransactionsResponseEntity {

  const TransactionsResponseModel({
    required super.items,
    required super.pagination,
  });

  factory TransactionsResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TransactionsResponseModel(
      items: (json['items'] as List)
          .map(
            (e) => TransactionModel.fromJson(e),
          )
          .toList(),
      pagination: PaginationModel2.fromJson(
        json['pagination'],
      ),
    );
  }
}