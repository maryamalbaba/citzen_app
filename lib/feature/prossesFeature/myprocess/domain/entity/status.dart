enum TransactionStatus {
  all,
  submitted,
  inProgress,
  completed,
  rejected,
}

extension TransactionStatusExtension on TransactionStatus {
  String get label {
  switch (this) {
    case TransactionStatus.all:
      return 'الكل';

    case TransactionStatus.submitted:
      return 'مقدمة';

    case TransactionStatus.inProgress:
      return 'قيد المعالجة';

    case TransactionStatus.completed:
      return 'مكتملة';

    case TransactionStatus.rejected:
      return 'مرفوضة';
  }
}}