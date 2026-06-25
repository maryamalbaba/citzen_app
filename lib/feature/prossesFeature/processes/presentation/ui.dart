import 'package:citzenapp/core/resource/color_manager.dart';
import 'package:citzenapp/core/service/get_it/injection_container.dart';
import 'package:citzenapp/feature/prossesFeature/processes/data/models/auth_process_model.dart';
import 'package:citzenapp/feature/prossesFeature/processes/presentation/bloc/process_bloc.dart';
import 'package:citzenapp/feature/prossesFeature/processes/presentation/bloc/process_event.dart';
import 'package:citzenapp/feature/prossesFeature/processes/presentation/bloc/process_state.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/presentation/pages/stage_config_page.dart';
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
    _bloc = sl<AuthProcessBloc>()
      ..add(FetchAuthProcessesEvent(id: widget.processTypeId));

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
    // الألوان المستوحاة من التصميم المرفق
    // الأخضر الغامق للـ AppBar
    const scaffoldBg = Colors.white;

    return BlocProvider<AuthProcessBloc>(
      create: (context) => _bloc,
      child: Scaffold(
        backgroundColor: scaffoldBg,
        appBar: AppBar(
          backgroundColor: ColorManager.primaryGreen,
          elevation: 0,
          title: Text(
            "  المعاملات المتاحة",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          // تصميم زر العودة المتناسق مع الصورة المرفقة
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ),
        body: BlocBuilder<AuthProcessBloc, AuthProcessState>(
          builder: (context, state) {
            switch (state.status) {
              case AuthProcessStatus.initial:
              case AuthProcessStatus.loading:
                return const Center(
                  child: CircularProgressIndicator(color: ColorManager.primaryGreen),
                );

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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorManager.primaryGreen,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          _bloc.add(FetchAuthProcessesEvent(
                              id: widget.processTypeId));
                        },
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                );

              case AuthProcessStatus.success:
                if (state.processes.isEmpty) {
                  return const Center(
                    child: Text(
                      'لا توجد عمليات متاحة حالياً ضمن هذه المرحلة.',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  );
                }

                return RefreshIndicator(
                  color: ColorManager.primaryGreen,
                  onRefresh: () async {
                    _bloc.add(FetchAuthProcessesEvent(id: widget.processTypeId));
                  },
                  child: Directionality(
                    textDirection: TextDirection.rtl, // لضمان التناسق العربي كالصورة
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // القائمة المحدثة
                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                            itemCount: state.hasNextPage
                                ? state.processes.length + 1
                                : state.processes.length,
                            itemBuilder: (context, index) {
                              if (index >= state.processes.length) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                  child: Center(
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2, color: ColorManager.primaryGreen)),
                                );
                              }

                              final process = state.processes[index];
                              
                              // تم تمرير الـ Card مباشرة واستدعاء الـ onTap بداخله لحل مشكلة المساحة الزائدة
                              return buildProcessCard(
                                title: process.name,
                                onTap: () {
                                  print('تم الضغط على المعاملة: ${process.name} (ID: ${process.processId})');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => StageConfigPage(
                                          stageId: state.processes[index].processId),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
            }
          },
        ),
      ),
    );
  }

}

  // بطاقة عرض المعاملة المحدثة مع تحديد منطقة الضغط بدقة بالبكسل
  Widget buildProcessCard({required String title, required VoidCallback onTap}) {
    const cardBg = Color(0xFFFBF8F3); // لون البيج الكريمي الفاتح من الصورة
    const textGray = Color.fromARGB(255, 148, 133, 109); // اللون البني الرمادي للنصوص داخل الكارد

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18), // حواف دائرية ناعمة كالصورة
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18), // هذا يمنع تأثير الضغط من الخروج خارج حواف الكارد
        child: ListTile(
          onTap: onTap, // تم تفعيل الضغط على الـ ListTile مباشرة هنا
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          
          // الدائرة البيضاء وبداخلها الشعار (النسر الذهبي) في الجهة اليمنى
          leading: Container(
            width: 55,
            height: 55,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/images/logo.png', 
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.account_balance, 
                    color: Color(0xFFC5A880),
                    size: 28,
                  ),
                  color: const Color(0xFFC5A880), // اللون الذهبي البرونزي للشعار
                ),
              ),
            ),
          ),

          // العنوان بجانب الدائرة مباشرة
          title: Text(
            title, // يعرض هنا اسم المعاملة تلقائياً
            style: const TextStyle(
              color: textGray,
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }