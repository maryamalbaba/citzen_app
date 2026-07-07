import 'package:citzenapp/core/resource/color_manager.dart';
import 'package:citzenapp/core/service/get_it/injection_container.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/submit_form_entity.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/widets/base_widget_entity.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/widets/check_list_widget_entity.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/widets/date_picker_widget_entity.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/widets/dropdown_widget_entity.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/widets/file_picker_widget_entity.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/widets/radio_group_widget_entity.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/widets/text_field_widget_entity.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/presentation/bloc/file_bloc.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/presentation/bloc/file_state.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/presentation/bloc/stage_config_bloc.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/presentation/bloc/stage_config_event.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/presentation/bloc/stage_config_state.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/presentation/submitBloc/bloc/submit_bloc.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/presentation/submitBloc/bloc/submit_event.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/presentation/submitBloc/bloc/submit_state.dart';
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

  // map خاص بكل template — key هو id الـ template
  final Map<int, Map<String, dynamic>> _templateFormValues = {};

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _motherNameController = TextEditingController();
  final _nationalIdController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _fatherNameController.dispose();
    _motherNameController.dispose();
    _nationalIdController.dispose();
    super.dispose();
  }

  String _widgetTypeFromEntity(BaseWidgetEntity entity) {
    return switch (entity) {
      TextFieldWidgetEntity _ => 'text_field',
      DropdownWidgetEntity _ => 'dropdown',
      RadioGroupWidgetEntity _ => 'radio_group',
      CheckListWidgetEntity _ => 'check_list',
      DatePickerWidgetEntity _ => 'date_picker',
      FilePickerWidgetEntity _ => 'file_picker',
      _ => 'unknown',
    };
  }

  dynamic _extractValue(BaseWidgetEntity entity, FileUploadState fileState) {
    return switch (entity) {
      FilePickerWidgetEntity _ =>
        fileState.getSuccessfulUploads(entity.id).toList(),
      DatePickerWidgetEntity _ => _formValues[entity.id] as DateTime?,
      CheckListWidgetEntity _ =>
        _formValues[entity.id] as List<String>? ?? [],
      _ => _formValues[entity.id] as String? ?? '',
    };
  }

  // نفس منطق _extractValue لكن تأخذ map معين بدل _formValues
  dynamic _extractValueFromMap(
    BaseWidgetEntity entity,
    Map<String, dynamic> valuesMap,
    FileUploadState fileState,
  ) {
    return switch (entity) {
      FilePickerWidgetEntity _ =>
        fileState.getSuccessfulUploads(entity.id).toList(),
      DatePickerWidgetEntity _ => valuesMap[entity.id] as DateTime?,
      CheckListWidgetEntity _ =>
        valuesMap[entity.id] as List<String>? ?? [],
      _ => valuesMap[entity.id] as String? ?? '',
    };
  }

  void _onSubmit(BuildContext context, StageConfigLoaded state) {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final fileState = context.read<FileUploadBloc>().state;

    // بناء widgets الرئيسية
    final submitWidgets = state.formConfig.widgets.map((entity) {
      return SubmitWidgetEntity(
        widgetType: _widgetTypeFromEntity(entity),
        data: entity.toRawData(),
        value: _extractValue(entity, fileState),
      );
    }).toList();

    // بناء templates مع قيمها
    final submitTemplates = state.formConfig.templates.map((template) {
      final templateValues = _templateFormValues[template.id] ?? {};
      return SubmitTemplateEntity(
        id: template.id,
        widgets: template.widgets.map((entity) {
          return SubmitWidgetEntity(
            widgetType: _widgetTypeFromEntity(entity),
            data: entity.toRawData(),
            value: _extractValueFromMap(entity, templateValues, fileState),
          );
        }).toList(),
      );
    }).toList();

    final submitEntity = SubmitFormEntity(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      fatherName: _fatherNameController.text.trim(),
      motherName: _motherNameController.text.trim(),
      nationalId: _nationalIdController.text.trim(),
      formId: state.formConfig.formId,
      formName: state.formConfig.formName,
      widgets: submitWidgets,
      templates: submitTemplates,
      note: '',
    );

    context.read<SubmitFormBloc>().add(
          SubmitFormSubmitEvent(
            processId: widget.stageId,
            entity: submitEntity,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<StageConfigBloc>()
            ..add(GetStageConfigEvent(widget.stageId)),
        ),
        BlocProvider(create: (_) => sl<FileUploadBloc>()),
        BlocProvider(create: (_) => sl<SubmitFormBloc>()),
      ],
      child: Scaffold(
        backgroundColor: ColorManager.extraLightBaieg,
        body: BlocListener<SubmitFormBloc, SubmitFormState>(
          listener: (context, state) {
            if (state is SubmitFormSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم إرسال المعاملة بنجاح'),
                  backgroundColor: ColorManager.darkGreen,
                ),
              );
              Navigator.pop(context);
            } else if (state is SubmitFormError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: ColorManager.red,
                ),
              );
            }
          },
          child: BlocBuilder<StageConfigBloc, StageConfigState>(
            builder: (context, state) {
              return switch (state) {
                StageConfigLoading() => const Center(
                    child: CircularProgressIndicator(
                        color: ColorManager.primaryGreen),
                  ),
                StageConfigError(:final message) =>
                  _buildError(context, message),
                StageConfigLoaded() =>
                  _buildLoaded(context, state as StageConfigLoaded),
                _ => const SizedBox.shrink(),
              };
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoaded(BuildContext context, StageConfigLoaded state) {
    return Column(
      children: [
        _buildAppBar(state.formConfig.formName),
        Expanded(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProgressBar(),
                  _buildSectionLabel('البيانات الشخصية الثابتة'),
                  _buildFixedFieldsCard(),
                  _buildSectionLabel('بيانات الاستمارة'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: DynamicFormBuilder(
                      widgets: state.formConfig.widgets,
                      formValues: _formValues,
                    ),
                  ),

                  // ===== قسم الـ Templates =====
                  if (state.formConfig.templates.isNotEmpty) ...[
                    _buildSectionLabel('النماذج المرفقة'),
                    ...state.formConfig.templates.map((template) {
                      // نضمن وجود map لكل template
                      _templateFormValues.putIfAbsent(
                          template.id, () => {});
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // رأس الـ template
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: ColorManager.primaryGreen
                                    .withOpacity(0.07),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: ColorManager.primaryGreen
                                      .withOpacity(0.2),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.article_outlined,
                                    color: ColorManager.primaryGreen,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'نموذج ${template.id}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: ColorManager.primaryGreen,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // widgets الـ template
                            DynamicFormBuilder(
                              widgets: template.widgets,
                              formValues: _templateFormValues[template.id]!,
                            ),
                          ],
                        ),
                      );
                    }),
                  ],

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
        _buildSubmitBar(context, state),
      ],
    );
  }

  Widget _buildAppBar(String formName) {
    return Container(
      color: ColorManager.primaryGreen,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_forward_ios_rounded,
                          color: Colors.white, size: 16),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'تعبئة الاستمارة',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(width: 36),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.description_outlined,
                        color: ColorManager.brown, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      formName,
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 24,
              decoration: const BoxDecoration(
                color: ColorManager.extraLightBaieg,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Row(
        children: [
          _buildStep(
              icon: Icons.person_outline_rounded,
              label: 'الشخصية',
              active: true),
          _buildStepLine(done: true),
          _buildStep(
              icon: Icons.dynamic_form_outlined,
              label: 'الاستمارة',
              active: true),
          _buildStepLine(done: false),
          _buildStep(
              icon: Icons.check_circle_outline_rounded,
              label: 'الإرسال',
              active: false),
        ],
      ),
    );
  }

  Widget _buildStep(
      {required IconData icon,
      required String label,
      required bool active}) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: active
                ? ColorManager.primaryGreen
                : ColorManager.brown.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: Icon(icon,
              color: active ? Colors.white : ColorManager.brown, size: 16),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
              fontSize: 10,
              color: active ? ColorManager.darkGreen : ColorManager.gray,
              fontWeight: active ? FontWeight.w600 : FontWeight.normal),
        ),
      ],
    );
  }

  Widget _buildStepLine({required bool done}) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 18),
        decoration: BoxDecoration(
          color: done
              ? ColorManager.primaryGreen
              : ColorManager.brown.withOpacity(0.3),
          borderRadius: BorderRadius.circular(1),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20, top: 16, bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: ColorManager.brown,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildFixedFieldsCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ColorManager.brown.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: _buildFixedTextField(
                        controller: _firstNameController,
                        label: 'الاسم الأول',
                        hint: 'مثال: أحمد')),
                const SizedBox(width: 10),
                Expanded(
                    child: _buildFixedTextField(
                        controller: _lastNameController,
                        label: 'الاسم الأخير',
                        hint: 'مثال: محمد')),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                    child: _buildFixedTextField(
                        controller: _fatherNameController,
                        label: 'اسم الأب',
                        hint: 'مثال: علي')),
                const SizedBox(width: 10),
                Expanded(
                    child: _buildFixedTextField(
                        controller: _motherNameController,
                        label: 'اسم الأم',
                        hint: 'مثال: فاطمة')),
              ],
            ),
            const SizedBox(height: 12),
            _buildFixedTextField(
              controller: _nationalIdController,
              label: 'رقم الهوية الوطنية',
              hint: 'أدخل رقم الهوية',
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFixedTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 13,
                    color: ColorManager.darkGreen,
                    fontWeight: FontWeight.w500)),
            const Text(' *',
                style: TextStyle(color: ColorManager.red, fontSize: 14)),
          ],
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 14, color: Color(0xff1a1a1a)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                const TextStyle(color: ColorManager.gray, fontSize: 13),
            filled: true,
            fillColor: ColorManager.extraLightBaieg,
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 11),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                  color: ColorManager.darkGreen, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: ColorManager.red, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: ColorManager.red, width: 1.5),
            ),
          ),
          validator: (val) {
            if (val == null || val.trim().isEmpty) {
              return '$label مطلوب';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSubmitBar(BuildContext context, StageConfigLoaded state) {
    return BlocBuilder<SubmitFormBloc, SubmitFormState>(
      builder: (context, submitState) {
        final isLoading = submitState is SubmitFormLoading;
        return Container(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 12,
            bottom: MediaQuery.of(context).padding.bottom + 12,
          ),
          decoration: BoxDecoration(
            color: ColorManager.extraLightBaieg,
            border: Border(
              top: BorderSide(color: ColorManager.brown.withOpacity(0.25)),
            ),
          ),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  isLoading ? null : () => _onSubmit(context, state),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.primaryGreen,
                disabledBackgroundColor:
                    ColorManager.primaryGreen.withOpacity(0.6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.send_rounded, size: 18),
                        SizedBox(width: 8),
                        Text('إرسال المعاملة',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline_rounded,
              size: 48, color: ColorManager.red),
          const SizedBox(height: 12),
          Text(message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: ColorManager.gray)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context
                .read<StageConfigBloc>()
                .add(GetStageConfigEvent(widget.stageId)),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorManager.primaryGreen,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }
}