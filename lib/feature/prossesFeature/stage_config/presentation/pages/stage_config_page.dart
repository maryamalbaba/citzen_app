import 'package:citzenapp/core/service/get_it/injection_container.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/presentation/bloc/stage_config_bloc.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/presentation/bloc/stage_config_event.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/presentation/bloc/stage_config_state.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/presentation/widgets/dynamic_form_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class StageConfigPage extends StatefulWidget {
  final int stageId;

  const StageConfigPage({super.key, required this.stageId});

  @override
  State<StageConfigPage> createState() => _StageConfigPageState();
}

class _StageConfigPageState extends State<StageConfigPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formValues = {};

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      debugPrint('Form Values: $_formValues');
      // TODO: استدعاء الـ submit use case هنا
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<StageConfigBloc>()..add(GetStageConfigEvent(widget.stageId)),
      child: Scaffold(
        backgroundColor: const Color(0xffF9F6EB), // خلفية الصفحة بالكامل بلون البيج الفاتح الهادئ
        appBar: AppBar(
          title: const Text(
            'تعبئة الاستمارة',
            style: TextStyle(
              color: Color(0xff25624F), // اللون الأخضر الداكن الفخم
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent, // جعل الهيدر يندمج بشكل ناعم مع الخلفية
          elevation: 0,
          iconTheme: const IconThemeData(color: Color(0xff25624F)), // تلوين زر الرجوع الافتراضي
        ),
        body: BlocBuilder<StageConfigBloc, StageConfigState>(
          builder: (context, state) {
            return switch (state) {
              StageConfigLoading() => const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xff25624F), // توحيد لون التحميل مع الثيم
                  ),
                ),
              StageConfigError(:final message) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline_rounded, size: 54, color: Colors.redAccent),
                        const SizedBox(height: 16),
                        Text(
                          message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Color(0xff817D7D), fontSize: 14),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () => context
                              .read<StageConfigBloc>()
                              .add(GetStageConfigEvent(widget.stageId)),
                          icon: const Icon(Icons.refresh_rounded, size: 18),
                          label: const Text('إعادة المحاولة'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffB8A47C), // لون البني للمحاولة
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              StageConfigLoaded(:final formConfig) => Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // عنوان الاستمارة بشكل مميز
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                border: const Border(
                                  right: BorderSide(color: Color(0xff25624F), width: 4), // خط جمالي جانبي للعنوان
                                ),
                              ),
                              child: Text(
                                formConfig.formName,
                                style: const TextStyle(
                                  color: Color(0xff25624F),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            DynamicFormBuilder(
                              widgets: formConfig.widgets,
                              formKey: _formKey,
                              formValues: _formValues,
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // منطقة زر الإرسال الثابت في الأسفل مع حماية الـ SafeArea والتجاوب
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white, // خلفية بيضاء لعزل الزر عن محتوى الاستمارة أثناء السكرول
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xff817D7D).withOpacity(0.08),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: const Offset(0, -3), // ظل خفيف للأعلى لإعطاء عمق بصري للزر
                          ),
                        ],
                      ),
                      child: SafeArea(
                        top: false, // لا نحتاج حماية علوية هنا
                        child: ElevatedButton(
                          onPressed: _onSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff25624F), // لون أخضر فخم للزر الأساسي
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(52), // زيادة الارتفاع لراحة اليد أثناء الضغط
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14), // حواف دائرية ناعمة متناسقة مع الحقول
                            ),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo', // اختياري في حال كنت تستخدم خط مخصص
                            ),
                          ),
                          child: const Text('إرسال الاستمارة'),
                        ),
                      ),
                    ),
                  ],
                ),
              _ => const SizedBox.shrink(),
            };
          },
        ),
      ),
    );
  }
}