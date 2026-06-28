import 'package:citzenapp/feature/prossesFeature/myprocess/domain/entity/reansaction_entity.dart';
import 'package:citzenapp/feature/prossesFeature/myprocess/domain/entity/status.dart';
import 'package:citzenapp/feature/prossesFeature/myprocess/domain/usecase/get_transactions_usecase.dart';
import 'package:citzenapp/feature/prossesFeature/myprocess/presentation/bloc/process_state_event.dart';
import 'package:citzenapp/feature/prossesFeature/myprocess/presentation/bloc/process_state_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final GetTransactionsUseCase getTransactionsUseCase;

  TransactionBloc(
    this.getTransactionsUseCase,
  ) : super(TransactionInitial()) {
    on<GetTransactionsEvent>(
      _onGetTransactions,
    );

    on<LoadMoreTransactionsEvent>(
      _onLoadMoreTransactions,
    );

    on<FilterTransactionsEvent>(
      _onFilterTransactions,
    );
  }

  final List<TransactionEntity> _allTransactions = [];

  TransactionStatus _currentFilter = TransactionStatus.all;

  int _currentPage = 1;

  final int _limit = 10;

  bool _hasNextPage = true;

  bool _isLoadingMore = false;

  //! Handle GetTransactionsEvent

  Future<void> _onGetTransactions(
    GetTransactionsEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());

    try {
      _currentPage = 1;

      _allTransactions.clear();

      final result = await getTransactionsUseCase(
        page: _currentPage,
        limit: _limit,
      );

      _allTransactions.addAll(
        result.items,
      );

      _hasNextPage = result.pagination.hasNext;
      _currentFilter = TransactionStatus.all;
      emit(
        TransactionLoaded(
          transactions: _applyFilter(),
          selectedFilter: _currentFilter,
          hasReachedMax: !_hasNextPage,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      emit(
        TransactionError(
          message: e.toString(),
        ),
      );
    }
  }
//!

  List<TransactionEntity> _applyFilter() {
    if (_currentFilter == TransactionStatus.all) {
      return _allTransactions;
    }

    return _allTransactions
        .where(
         (t) => t.status == _currentFilter.name
        )
        .toList();
  }
//!

  Future<void> _onLoadMoreTransactions(
    LoadMoreTransactionsEvent event,
    Emitter<TransactionState> emit,
  ) async {
    if (!_hasNextPage || _isLoadingMore) return;

    _isLoadingMore = true;

    final currentState = state;

    if (currentState is TransactionLoaded) {
      emit(
        currentState.copyWith(
          isLoadingMore: true,
        ),
      );
    }

    try {
      _currentPage++;

      final result = await getTransactionsUseCase(
        page: _currentPage,
        limit: _limit,
      );

      _allTransactions.addAll(
        result.items,
      );

      _hasNextPage = result.pagination.hasNext;

      _isLoadingMore = false;

      emit(
        TransactionLoaded(
          transactions: _applyFilter(),
          selectedFilter: _currentFilter,
          hasReachedMax: !_hasNextPage,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      _isLoadingMore = false;

      emit(
        TransactionError(
          message: e.toString(),
        ),
      );
    }
  }

//!
Future<void> _onFilterTransactions(
  FilterTransactionsEvent event,
  Emitter<TransactionState> emit,
) async {
  _currentFilter = event.status;

  emit(TransactionLoading());

  _currentPage = 1;
  _allTransactions.clear();

  final result = await getTransactionsUseCase(
    page: _currentPage,
    limit: 100, // أو كبير
  );

  _allTransactions.addAll(result.items);

  _hasNextPage = result.pagination.hasNext;

  emit(
    TransactionLoaded(
      transactions: _applyFilter(),
      selectedFilter: _currentFilter,
      hasReachedMax: !_hasNextPage,
      isLoadingMore: false,
    ),
  );
}
}
