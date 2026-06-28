import 'package:citzenapp/core/service/get_it/injection_container.dart';
import 'package:citzenapp/feature/prossesFeature/myprocess/domain/entity/reansaction_entity.dart';
import 'package:citzenapp/feature/prossesFeature/myprocess/domain/entity/status.dart';
import 'package:citzenapp/feature/prossesFeature/myprocess/presentation/bloc/process_state_bloc.dart';
import 'package:citzenapp/feature/prossesFeature/myprocess/presentation/bloc/process_state_event.dart';
import 'package:citzenapp/feature/prossesFeature/myprocess/presentation/bloc/process_state_state.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_stepper/easy_stepper.dart';

import 'package:citzenapp/feature/prossesFeature/myprocess/domain/entity/reansaction_entity.dart';
import 'package:citzenapp/feature/prossesFeature/myprocess/domain/entity/status.dart';

class MyTransactionsPage extends StatefulWidget {
  const MyTransactionsPage({super.key});

  @override
  State<MyTransactionsPage> createState() => _MyTransactionsPageState();
}

class _MyTransactionsPageState extends State<MyTransactionsPage> {
  late final ScrollController _scrollController;

  // 🔥 نخزن نفس الـ instance لتجنب مشاكل GetIt المتكررة
  late final TransactionBloc bloc;

  @override
  void initState() {
    super.initState();

    bloc = sl<TransactionBloc>();

    bloc.add(GetTransactionsEvent());

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;

    final currentScroll = _scrollController.position.pixels;

    if (currentScroll >= maxScroll * 0.9) {
      bloc.add(LoadMoreTransactionsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('معاملاتي'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          _buildFilters(),
          const SizedBox(height: 12),
          Expanded(
            child: BlocBuilder<TransactionBloc, TransactionState>(
              bloc: bloc, // 🔥 مهم جداً
              builder: (context, state) {
                if (state is TransactionLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is TransactionError) {
                  return Center(
                    child: Text(state.message),
                  );
                }

                if (state is TransactionLoaded) {
                  return _buildList(state);
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(TransactionLoaded state) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: state.transactions.length + (state.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == state.transactions.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final transaction = state.transactions[index];

        return TransactionCard(
          transaction: transaction,
        );
      },
    );
  }

  Widget _buildFilters() {
    return BlocBuilder<TransactionBloc, TransactionState>(
      bloc: bloc, // 🔥 نفس الـ instance
      builder: (context, state) {
        TransactionStatus selected = TransactionStatus.all;

        if (state is TransactionLoaded) {
          selected = state.selectedFilter;
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: TransactionStatus.values.map((status) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceChip(
                  label: Text(status.label),
                  selected: selected == status,
                  onSelected: (_) {
                    bloc.add(
                      FilterTransactionsEvent(status: status),
                    );
                  },
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class TransactionCard extends StatelessWidget {
  final TransactionEntity transaction;

  const TransactionCard({
    super.key,
    required this.transaction,
  });

  int _getActiveStep() {
    switch (transaction.status) {
      case 'submitted':
        return 0;
      case 'in_progress':
        return 1;
      case 'completed':
        return 2;
      case 'rejected':
        return 0;
      default:
        return 0;
    }
  }

  bool _isStepFinished(int stepIndex) {
    return stepIndex < _getActiveStep();
  }

  @override
  Widget build(BuildContext context) {
    final activeStep = _getActiveStep();
    final progress = (transaction.progressPercent ?? 0).toDouble();

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ================= TITLE =================
            Text(
              transaction.processDefinitionName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            /// ================= STAGE + STATUS CHIP =================
            Row(
              children: [
                Expanded(
                  child: Text(
                    transaction.stageName ?? '---',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor(transaction.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    transaction.status,
                    style: TextStyle(
                      fontSize: 12,
                      color: _statusColor(transaction.status),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// ================= PROGRESS BAR =================
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "التقدم",
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      "${progress.toStringAsFixed(0)}%",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress / 100,
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _statusColor(transaction.status),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            /// ================= STEPPER =================
            Directionality(
              textDirection: TextDirection.rtl,
              child: EasyStepper(
                activeStep: activeStep,
                stepRadius: 18,
                finishedStepBackgroundColor: Colors.green,
                activeStepBackgroundColor: Colors.white,
                showLoadingAnimation: false,
                steps: [
                  EasyStep(
                    customStep: CircleAvatar(
                      backgroundColor: _isStepFinished(0) || activeStep == 0
                          ? Colors.green
                          : Colors.white,
                      child: _isStepFinished(0)
                          ? const Icon(Icons.check,
                              color: Colors.white, size: 14)
                          : const Text('1'),
                    ),
                    title: 'تم الاستلام',
                  ),
                  EasyStep(
                    customStep: CircleAvatar(
                      backgroundColor: _isStepFinished(1) || activeStep == 1
                          ? Colors.green
                          : Colors.white,
                      child: _isStepFinished(1)
                          ? const Icon(Icons.check,
                              color: Colors.white, size: 14)
                          : const Text('2'),
                    ),
                    title: 'قيد المعالجة',
                  ),
                  EasyStep(
                    customStep: CircleAvatar(
                      backgroundColor:
                          activeStep == 2 ? Colors.green : Colors.white,
                      child: activeStep == 2
                          ? const Icon(Icons.check,
                              color: Colors.white, size: 14)
                          : const Text('3'),
                    ),
                    title: 'تم الرد',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ================= STATUS COLOR =================
  Color _statusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'in_progress':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      case 'submitted':
      default:
        return Colors.blue;
    }
  }
}
