import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_stepper/easy_stepper.dart';

import 'package:citzenapp/core/service/get_it/injection_container.dart';
import 'package:citzenapp/feature/prossesFeature/myprocess/domain/entity/reansaction_entity.dart';
import 'package:citzenapp/feature/prossesFeature/myprocess/domain/entity/status.dart';
import 'package:citzenapp/feature/prossesFeature/myprocess/presentation/bloc/process_state_bloc.dart';
import 'package:citzenapp/feature/prossesFeature/myprocess/presentation/bloc/process_state_event.dart';
import 'package:citzenapp/feature/prossesFeature/myprocess/presentation/bloc/process_state_state.dart';

/// لوحة الألوان الخاصة بالمشروع
abstract class AppColors {
  static const Color brown = Color(0xffB8A47C);
  static const Color gray = Color(0xff817D7D);
  static const Color red = Color(0xffEB2222);
  static const Color lightBrown = Color(0xffB8A57B);
  static const Color extraLightBaieg = Color(0xffF9F6EB);
  static const Color oldBrown = Color(0xffA39A5C);
  static const Color primaryGreen = Color(0xFF0D4633);
  static const Color darkGreen = Color(0xff1B4332);
  static const Color goldenBrown = Color(0xffB3A45F);
  static const Color textGrey = Color(0xff707070);
  static const Color backgroundLight = Color(0xffF7F7F5);
}

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
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text(
          'معاملاتي',
          style: TextStyle(
            color: AppColors.darkGreen,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.darkGreen),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          
          /// ================= FILTERS =================
          _buildFilters(),

          const SizedBox(height: 12),

          /// ================= TRANSACTIONS LIST =================
          Expanded(
            child: BlocBuilder<TransactionBloc, TransactionState>(
              bloc: bloc, // 🔥 مهم جداً
              builder: (context, state) {
                if (state is TransactionLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryGreen,
                    ),
                  );
                }

                if (state is TransactionError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.red.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.error_outline_rounded,
                              size: 48,
                              color: AppColors.red,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.textGrey,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: () => bloc.add(GetTransactionsEvent()),
                            icon: const Icon(Icons.refresh_rounded, size: 18),
                            label: const Text('إعادة المحاولة'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryGreen,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (state is TransactionLoaded) {
                  if (state.transactions.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: const BoxDecoration(
                              color: AppColors.extraLightBaieg,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.assignment_outlined,
                              size: 56,
                              color: AppColors.goldenBrown,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'لا توجد معاملات حالياً',
                            style: TextStyle(
                              color: AppColors.darkGreen,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return _buildList(state);
                }

                return const SizedBox.shrink();
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
      padding: const EdgeInsets.only(bottom: 24, top: 4),
      itemCount: state.transactions.length + (state.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == state.transactions.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.primaryGreen,
              ),
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

        return Container(
          height: 44,
          margin: const EdgeInsets.symmetric(horizontal: 12),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: TransactionStatus.values.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final status = TransactionStatus.values[index];
              final isSelected = selected == status;

              return InkWell(
                onTap: () {
                  bloc.add(
                    FilterTransactionsEvent(status: status),
                  );
                },
                borderRadius: BorderRadius.circular(22),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryGreen : Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryGreen
                          : Colors.grey.shade300,
                      width: 1,
                    ),
                    boxShadow: [
                      if (isSelected)
                        BoxShadow(
                          color: AppColors.primaryGreen.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      status.label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? Colors.white : AppColors.textGrey,
                      ),
                    ),
                  ),
                ),
              );
            },
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
    final statusColor = _statusColor(transaction.status);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.lightBrown.withOpacity(0.25),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ================= TITLE & STATUS CHIP =================
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    transaction.processDefinitionName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGreen,
                      height: 1.3,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: statusColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    _getStatusLabel(transaction.status),
                    style: TextStyle(
                      fontSize: 12,
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            /// ================= STAGE NAME =================
            Row(
              children: [
                const Icon(
                  Icons.account_tree_outlined,
                  size: 15,
                  color: AppColors.brown,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    transaction.stageName ?? '---',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(height: 1, color: AppColors.extraLightBaieg),
            const SizedBox(height: 16),

            /// ================= PROGRESS BAR =================
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "التقدم",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textGrey,
                      ),
                    ),
                    Text(
                      "${progress.toStringAsFixed(0)}%",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress / 100,
                    minHeight: 7,
                    backgroundColor: AppColors.extraLightBaieg,
                    valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// ================= STEPPER =================
            Directionality(
              textDirection: TextDirection.rtl,
              child: EasyStepper(
                activeStep: activeStep,
                stepRadius: 16,
                showStepBorder: false,
                lineStyle: LineStyle(
                  lineLength: 60,
                  lineType: LineType.normal,
                  defaultLineColor: Colors.grey.shade300,
                  finishedLineColor: AppColors.primaryGreen,
                  activeLineColor: AppColors.goldenBrown,
                  lineThickness: 2,
                ),
                finishedStepBackgroundColor: AppColors.primaryGreen,
                activeStepBackgroundColor: AppColors.goldenBrown,
                unreachedStepBackgroundColor: Colors.grey.shade200,
                showLoadingAnimation: false,
                steps: [
                  EasyStep(
                    customStep: CircleAvatar(
                      radius: 16,
                      backgroundColor: _isStepFinished(0) || activeStep == 0
                          ? (_isStepFinished(0) ? AppColors.primaryGreen : AppColors.goldenBrown)
                          : Colors.grey.shade200,
                      child: _isStepFinished(0)
                          ? const Icon(Icons.check, color: Colors.white, size: 14)
                          : Text(
                              '1',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: activeStep == 0 ? Colors.white : AppColors.gray,
                              ),
                            ),
                    ),
                    title: 'تم الاستلام',
                  ),
                  EasyStep(
                    customStep: CircleAvatar(
                      radius: 16,
                      backgroundColor: _isStepFinished(1) || activeStep == 1
                          ? (_isStepFinished(1) ? AppColors.primaryGreen : AppColors.goldenBrown)
                          : Colors.grey.shade200,
                      child: _isStepFinished(1)
                          ? const Icon(Icons.check, color: Colors.white, size: 14)
                          : Text(
                              '2',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: activeStep == 1 ? Colors.white : AppColors.gray,
                              ),
                            ),
                    ),
                    title: 'قيد المعالجة',
                  ),
                  EasyStep(
                    customStep: CircleAvatar(
                      radius: 16,
                      backgroundColor: activeStep == 2
                          ? AppColors.primaryGreen
                          : Colors.grey.shade200,
                      child: activeStep == 2
                          ? const Icon(Icons.check, color: Colors.white, size: 14)
                          : Text(
                              '3',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: activeStep == 2 ? Colors.white : AppColors.gray,
                              ),
                            ),
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
        return AppColors.primaryGreen;
      case 'in_progress':
        return AppColors.goldenBrown;
      case 'rejected':
        return AppColors.red;
      case 'submitted':
      default:
        return AppColors.darkGreen;
    }
  }

  /// ================= STATUS ARABIC LABEL =================
  String _getStatusLabel(String status) {
    switch (status) {
      case 'completed':
        return 'مكتملة';
      case 'in_progress':
        return 'قيد المعالجة';
      case 'rejected':
        return 'مرفوضة';
      case 'submitted':
        return 'مُقدمة';
      default:
        return status;
    }
  }
}