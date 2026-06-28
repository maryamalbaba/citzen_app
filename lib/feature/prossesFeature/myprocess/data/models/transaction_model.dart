
import 'package:citzenapp/feature/prossesFeature/myprocess/domain/entity/reansaction_entity.dart';

class TransactionModel extends TransactionEntity {
  const TransactionModel({
    required super.transactionId,
    required super.idProcess,
    required super.processDefinitionName,
    required super.stageName,
    required super.progressPercent,
    required super.priority,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
  });

  factory TransactionModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TransactionModel(
      transactionId: json['transaction_id'],
      idProcess: json['id_process'],
      processDefinitionName:
          json['process_definition_name'],
      stageName: json['stage_name'],
      progressPercent:
          json['progress_percent'],
      priority: json['priority'],
      status: json['status'],
      createdAt:
          DateTime.parse(json['created_at']),
      updatedAt:
          DateTime.parse(json['updated_at']),
    );
  }
}