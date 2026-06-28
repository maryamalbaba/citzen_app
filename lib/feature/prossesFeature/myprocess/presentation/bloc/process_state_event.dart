import 'package:citzenapp/feature/prossesFeature/myprocess/domain/entity/status.dart';

abstract class TransactionEvent {}

/// أول تحميل
class GetTransactionsEvent extends TransactionEvent {}

/// تحميل صفحة جديدة عند الوصول لآخر القائمة
class LoadMoreTransactionsEvent extends TransactionEvent {}

/// فلترة محلية
class FilterTransactionsEvent extends TransactionEvent {
  final TransactionStatus status;

  FilterTransactionsEvent({
    required this.status,
  });
}