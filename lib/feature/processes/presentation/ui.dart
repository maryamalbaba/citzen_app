import 'package:citzenapp/core/service/get_it/injection_container.dart';
import 'package:citzenapp/feature/processes/data/models/auth_process_model.dart';
import 'package:citzenapp/feature/processes/presentation/bloc/process_bloc.dart';
import 'package:citzenapp/feature/processes/presentation/bloc/process_event.dart';
import 'package:citzenapp/feature/processes/presentation/bloc/process_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthProcessesPage extends StatefulWidget {
  final num processTypeId;
  final String title;

  const AuthProcessesPage({
    Key? key,
    required this.processTypeId,
    required this.title,
  }) : super(key: key);

  @override
  State<AuthProcessesPage> createState() => _AuthProcessesPageState();
}

class _AuthProcessesPageState extends State<AuthProcessesPage> {
  final ScrollController _scrollController = ScrollController();
  late AuthProcessBloc _bloc;

  @override
  void initState() {
    super.initState();
    // إنشاء الـ Bloc وحقنه عبر الـ Service Locator
    _bloc = sl<AuthProcessBloc>()..add(FetchAuthProcessesEvent(id: widget.processTypeId));
    
    // ربط مستمع الـ Scroll لمراقبة الوصول لنهاية الصفحة
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      
      // إذا اقترب المستخدم من نهاية القائمة بـ 200 بكسل، اطلب الصفحة التالية
      if (maxScroll - currentScroll <= 200) {
        _bloc.add(const LoadMoreAuthProcessesEvent());
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthProcessBloc>(
      create: (context) => _bloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
          // تفعيل سهم العودة لكوننا خرجنا من نطاق الـ MainWrapper
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocBuilder<AuthProcessBloc, AuthProcessState>(
          builder: (context, state) {
            switch (state.status) {
              case AuthProcessStatus.initial:
              case AuthProcessStatus.loading:
                return const Center(child: CircularProgressIndicator());
                
              case AuthProcessStatus.failure:
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.errorMessage,
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          _bloc.add(FetchAuthProcessesEvent(id: widget.processTypeId));
                        },
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                );

              case AuthProcessStatus.success:
                if (state.processes.isEmpty) {
                  return const Center(
                    child: Text('لا توجد عمليات متاحة حالياً ضمن هذه المرحلة.'),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    _bloc.add(FetchAuthProcessesEvent(id: widget.processTypeId));
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16.0),
                    itemCount: state.hasNextPage 
                        ? state.processes.length + 1 
                        : state.processes.length,
                    itemBuilder: (context, index) {
                      // إذا وصلنا للعنصر الإضافي وكان هناك صفحة تالية، نعرض مؤشر التحميل السفلي
                      if (index >= state.processes.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                        );
                      }

                      final process = state.processes[index];
                      return _buildProcessCard(process);
                    },
                  ),
                );
            }
          },
        ),
      ),
    );
  }

  // بطاقة عرض المعاملة (يمكنكِ تعديل الـ UI الخاص بها ليطابق ستايل تطبيقك العام بدقة)
  Widget _buildProcessCard(AuthProcessModel process) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          process.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'كود: ${process.code}',
                  style: TextStyle(color: Colors.blue.shade700, fontSize: 12),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'الأولوية: ${process.priority}',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // هنا سيتم الانتقال لتفاصيل المعاملة المحددة لاحقاً عند الضغط عليها
        },
      ),
    );
  }
}