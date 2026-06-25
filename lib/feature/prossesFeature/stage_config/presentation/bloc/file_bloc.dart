import 'package:citzenapp/feature/prossesFeature/stage_config/domain/usecase/upload_file_usecase.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/presentation/bloc/file_event.dart';
import 'package:citzenapp/feature/prossesFeature/stage_config/presentation/bloc/file_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FileUploadBloc extends Bloc<FileUploadEvent, FileUploadState> {
  final UploadFileUseCase uploadFileUseCase;

  FileUploadBloc(this.uploadFileUseCase) : super(const FileUploadState()) {
    on<UploadFileEvent>(_onUploadFile);
    on<RemoveUploadedFileEvent>(_onRemoveFile);
  }

  Future<void> _onUploadFile(
    UploadFileEvent event,
    Emitter<FileUploadState> emit,
  ) async {
    // 1. نضيف الملف بحالة uploading
    final currentList = List<SingleFileState>.from(
      state.filesPerField[event.key] ?? [],
    );

    currentList.add(
      SingleFileState(
        fileName: event.file.name,
        status: FileUploadStatus.uploading,
      ),
    );

    final indexBeingUploaded = currentList.length - 1;

    emit(state.copyWith(
      filesPerField: {
        ...state.filesPerField,
        event.key: currentList,
      },
    ));

    // 2. نرسل للـ API
    final result = await uploadFileUseCase(
      filePath: event.file.path!,
      fileName: event.file.name,
      typeDocId: event.typeDocId,
      key: event.key,
    );

    // 3. نحدث حالة هذا الملف بالتحديد
    final updatedList = List<SingleFileState>.from(
      state.filesPerField[event.key] ?? [],
    );

    result.fold(
      (failure) {
        updatedList[indexBeingUploaded] = updatedList[indexBeingUploaded]
            .copyWith(
          status: FileUploadStatus.failure,
          errorMessage: failure.message,
        );
      },
      (entity) {
        updatedList[indexBeingUploaded] = updatedList[indexBeingUploaded]
            .copyWith(
          status: FileUploadStatus.success,
          uploadedEntity: entity,
        );
      },
    );

    emit(state.copyWith(
      filesPerField: {
        ...state.filesPerField,
        event.key: updatedList,
      },
    ));
  }

  void _onRemoveFile(
    RemoveUploadedFileEvent event,
    Emitter<FileUploadState> emit,
  ) {
    final updatedList = List<SingleFileState>.from(
      state.filesPerField[event.key] ?? [],
    );

    if (event.fileIndex < updatedList.length) {
      updatedList.removeAt(event.fileIndex);
    }

    emit(state.copyWith(
      filesPerField: {
        ...state.filesPerField,
        event.key: updatedList,
      },
    ));
  }
}