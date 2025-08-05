import 'dart:async';

import 'package:banya_llmops/core/entities/file_entity.dart';
import 'package:banya_llmops/core/entities/upload_entity.dart';
import 'package:banya_llmops/features/home/rag/domain/entities/rag_create_entity.dart';
import 'package:banya_llmops/features/home/rag/domain/entities/rag_entity.dart';
import 'package:banya_llmops/features/home/rag/domain/entities/rag_update_entity.dart';
import 'package:banya_llmops/features/home/rag/domain/usecase/create_rag_usecase.dart';
import 'package:banya_llmops/features/home/rag/domain/usecase/delete_rag_usecase.dart';
import 'package:banya_llmops/features/home/rag/domain/usecase/edit_rag_usecase.dart';
import 'package:banya_llmops/features/home/rag/domain/usecase/fetch_rag_detail_usecase.dart';
import 'package:banya_llmops/features/home/rag/domain/usecase/fetch_rags_usecase.dart';
import 'package:banya_llmops/features/home/rag/domain/usecase/upload_rag_file_usecase.dart';
import 'package:banya_llmops/features/home/rag/presentation/blocs/rag_event.dart';
import 'package:banya_llmops/features/home/rag/presentation/blocs/rag_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RagBloc extends Bloc<RagEvent, RagState> {
  final FetchRagsUsecase fetchRagsUsecase;
  final FetchRagDetailUsecase fetchRagDetailUsecase;
  final CreateRagUsecase createRagUsecase;
  final UploadRagFileUsecase uploadRagFileUsecase;
  final EditRagUsecase editRagUsecase;
  final DeleteRagUsecase deleteRagUsecase;

  RagBloc({
    required this.fetchRagsUsecase,
    required this.fetchRagDetailUsecase,
    required this.createRagUsecase,
    required this.uploadRagFileUsecase,
    required this.editRagUsecase,
    required this.deleteRagUsecase,
  }) : super(const RagInitial()) {
    on<FetchRags>(_onFetchRags);
    on<FetchRagDetail>(_onFetchRagDetail);
    on<InvalidRagIdEvent>(_onInvalidRagId);
    on<UploadRagFile>(_onUploadRagFile);
    on<CreateRag>(_onCreateRag);
    on<EditRag>(_onEditRag);
    on<DeleteRag>(_onDeleteRag);
    on<ResetRagState>(_onResetRagCreateState);
    on<SetUploadedFiles>((event, emit) {
      emit(
        RagUploadedFiles(
          uploadedFiles: event.files,
          uploadStatus: RagUploadStatus.initial,
        ),
      );
    });
  }

  Future<void> _onFetchRags(FetchRags event, Emitter<RagState> emit) async {
    emit(RagLoading(uploadedFiles: state.uploadedFiles));
    try {
      final result = await fetchRagsUsecase();
      emit(RagsLoaded(rags: result, uploadedFiles: state.uploadedFiles));
    } catch (e) {
      emit(RagError(e.toString(), uploadedFiles: state.uploadedFiles));
    }
  }

  Future<void> _onFetchRagDetail(
    FetchRagDetail event,
    Emitter<RagState> emit,
  ) async {
    emit(RagLoading(uploadedFiles: state.uploadedFiles));
    try {
      final result = await fetchRagDetailUsecase(event.id);
      emit(RagDetailLoaded(rag: result, uploadedFiles: state.uploadedFiles));
    } catch (e) {
      emit(RagError(e.toString(), uploadedFiles: state.uploadedFiles));
    }
  }

  void _onInvalidRagId(InvalidRagIdEvent event, Emitter<RagState> emit) {
    emit(RagError(event.message, uploadedFiles: state.uploadedFiles));
  }

  void _onResetRagCreateState(ResetRagState event, Emitter<RagState> emit) {
    emit(RagUploadedFiles(uploadedFiles: const []));
  }

  Future<void> _onUploadRagFile(
    UploadRagFile event,
    Emitter<RagState> emit,
  ) async {
    if (state is! RagUploadedFiles) return;
    final currentState = state as RagUploadedFiles;

    emit(
      currentState.copyWith(
        uploadStatus: RagUploadStatus.uploading,
        uploadProgress: 0.0,
        uploadingFileName: event.fileName,
      ),
    );

    try {
      final uploadEntity = UploadEntity(
        fileName: event.fileName,
        fileBytes: event.fileBytes,
        fileType: event.fileType,
      );

      final uploadedFile = await uploadRagFileUsecase.call(uploadEntity, (
        progress,
      ) {
        if (state is RagUploadedFiles) {
          emit((state as RagUploadedFiles).copyWith(uploadProgress: progress));
        }
      });

      if (state is RagUploadedFiles) {
        final currentFiles = (state as RagUploadedFiles).uploadedFiles;
        final updatedFiles = List<FileEntity>.from(currentFiles)
          ..add(uploadedFile);

        emit(
          (state as RagUploadedFiles).copyWith(
            uploadedFiles: updatedFiles,
            uploadStatus: RagUploadStatus.success,
            uploadProgress: 1.0,
            clearUploadingFileName: true,
            errorMessage: null,
          ),
        );
      }
    } catch (e) {
      if (state is RagUploadedFiles) {
        emit(
          (state as RagUploadedFiles).copyWith(
            uploadStatus: RagUploadStatus.error,
            errorMessage: '파일 업로드 실패: ${e.toString()}',
            uploadProgress: 0.0,
            clearUploadingFileName: true,
          ),
        );
      } else {
        emit(
          RagError(
            '파일 업로드 처리 중 오류 발생: ${e.toString()}',
            uploadedFiles: state.uploadedFiles,
          ),
        );
      }
    }
  }

  Future<void> _onCreateRag(CreateRag event, Emitter<RagState> emit) async {
    emit(RagLoading(uploadedFiles: state.uploadedFiles));

    final List<RagSummaryEntity> previousRags;
    if (state is RagsLoaded) {
      previousRags = (state as RagsLoaded).rags?.toList() ?? [];
    } else {
      previousRags = [];
    }

    try {
      final ragCreateEntity = RagCreateEntity(
        name: event.name,
        description: event.description,
        ragFileIds: event.ragFileIds,
      );
      final result = await createRagUsecase(ragCreateEntity);

      final List<RagSummaryEntity> updateRags = List.from(previousRags)
        ..add(result);
      emit(RagsLoaded(rags: updateRags, uploadedFiles: state.uploadedFiles));
      emit(RagCreated(result, uploadedFiles: state.uploadedFiles));
    } catch (e) {
      emit(RagError(e.toString(), uploadedFiles: state.uploadedFiles));
    }
  }

  Future<void> _onEditRag(EditRag event, Emitter<RagState> emit) async {
    emit(RagLoading(uploadedFiles: state.uploadedFiles));

    final List<RagSummaryEntity> previousRags;
    if (state is RagsLoaded) {
      previousRags = (state as RagsLoaded).rags?.toList() ?? [];
    } else {
      previousRags = [];
    }

    try {
      final ragEditEntity = RagEditEntity(
        id: event.id,
        name: event.name,
        description: event.description,
        ragFileIds: event.ragFileIds,
      );
      final result = await editRagUsecase(ragEditEntity);

      final List<RagSummaryEntity> updateRags = List.from(previousRags)
        ..add(result);
      emit(RagsLoaded(rags: updateRags, uploadedFiles: state.uploadedFiles));
      emit(RagEdited(result, uploadedFiles: state.uploadedFiles));
    } catch (e) {
      emit(RagError(e.toString(), uploadedFiles: state.uploadedFiles));
    }
  }

  Future<void> _onDeleteRag(DeleteRag event, Emitter<RagState> emit) async {
    emit(RagLoading(uploadedFiles: state.uploadedFiles));
    try {
      await deleteRagUsecase(event.id);
      if (state is RagsLoaded) {
        final prevList = (state as RagsLoaded).rags ?? [];
        final updatedList = prevList.where((e) => e.id != event.id).toList();
        emit(RagsLoaded(rags: updatedList, uploadedFiles: state.uploadedFiles));
      } else {
        final result = await fetchRagsUsecase();
        emit(RagsLoaded(rags: result, uploadedFiles: state.uploadedFiles));
      }
    } catch (e) {
      emit(RagError(e.toString(), uploadedFiles: state.uploadedFiles));
    }
  }
}
