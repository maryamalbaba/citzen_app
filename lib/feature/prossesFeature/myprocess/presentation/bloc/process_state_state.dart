import 'package:citzenapp/feature/prossesFeature/myprocess/domain/entity/reansaction_entity.dart';
import 'package:citzenapp/feature/prossesFeature/myprocess/domain/entity/status.dart';
import 'package:equatable/equatable.dart';




abstract class TransactionState {}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionError extends TransactionState {
  final String message;

  TransactionError({
    required this.message,
  });
}

class TransactionLoaded extends TransactionState {
  final List<TransactionEntity> transactions;

  final TransactionStatus selectedFilter;

  final bool hasReachedMax;

  final bool isLoadingMore;

  TransactionLoaded({
    required this.transactions,
    required this.selectedFilter,
    required this.hasReachedMax,
    required this.isLoadingMore,
  });

  TransactionLoaded copyWith({
    List<TransactionEntity>? transactions,
    TransactionStatus? selectedFilter,
    bool? hasReachedMax,
    bool? isLoadingMore,
  }) {
    return TransactionLoaded(
      transactions:
          transactions ?? this.transactions,
      selectedFilter:
          selectedFilter ??
              this.selectedFilter,
      hasReachedMax:
          hasReachedMax ??
              this.hasReachedMax,
      isLoadingMore:
          isLoadingMore ??
              this.isLoadingMore,
    );
  }
}