import 'package:citzenapp/feature/prossesFeature/stage_config/domain/entities/template_entity.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/usecase/get_document_template_usecase.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/domain/usecase/get_stage_config_usecase.dart';

import 'package:citzenapp/feature/prossesFeature/stage_config/presentation/bloc/stage_config_event.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/presentation/bloc/stage_config_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StageConfigBloc extends Bloc<StageConfigEvent, StageConfigState> {
  
  final GetStageConfigUseCase getStageConfigUseCase;
  final GetDocumentTemplateUseCase getDocumentTemplateUseCase; // ← جديد

  StageConfigBloc({
    required this.getStageConfigUseCase,
    required this.getDocumentTemplateUseCase,
  }) : super(const StageConfigInitial()) {
    on<GetStageConfigEvent>(_onGetStageConfig);
  }

  Future<void> _onGetStageConfig(
    GetStageConfigEvent event,
    Emitter<StageConfigState> emit,
  ) async {
    emit(const StageConfigLoading());

    // 1. نجلب الـ config
    final configResult = await getStageConfigUseCase(event.id);

    await configResult.fold(
      (failure) async => emit(StageConfigError(failure.message)),
      (formConfig) async {
        // 2. نعرض الـ config فوراً حتى لو الـ templates لسه بتتحمل
        emit(StageConfigLoaded(formConfig));

        // 3. إذا ما في template ids نوقف هنا
        if (formConfig.templateIds.isEmpty) return;

        // 4. نجلب كل template بالتوازي
        final futures = formConfig.templateIds
            .map((id) => getDocumentTemplateUseCase(id))
            .toList();

        final results = await Future.wait(futures);

        // 5. نجمع الناجحة فقط
        final fetchedTemplates = <TemplateEntity>[];
        for (final result in results) {
          result.fold(
            (_) {}, // نتجاهل الفاشلة بصمت
            (template) => fetchedTemplates.add(template),
          );
        }

        // 6. نحدث الـ state مع الـ templates
        emit(StageConfigLoaded(
          formConfig.copyWith(templates: fetchedTemplates),
        ));
      },
    );
  }
}