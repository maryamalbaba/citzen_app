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
  }

  /// القيمة كما تُرسل/تُستقبل من الـ API (وليست اسم الـ enum في Dart)
  String get apiValue {
    switch (this) {
      case TransactionStatus.all:
        return 'all';

      case TransactionStatus.submitted:
        return 'submitted';

      case TransactionStatus.inProgress:
        return 'in_progress';

      case TransactionStatus.completed:
        return 'completed';

      case TransactionStatus.rejected:
        return 'rejected';
    }
  }
}