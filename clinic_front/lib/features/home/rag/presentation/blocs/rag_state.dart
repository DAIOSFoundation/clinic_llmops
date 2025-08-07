import 'package:banya_llmops/core/entities/file_entity.dart';
import 'package:banya_llmops/features/home/rag/domain/entities/rag_detail_entity.dart';
import 'package:banya_llmops/features/home/rag/domain/entities/rag_entity.dart';
import 'package:equatable/equatable.dart';

enum RagUploadStatus { initial, uploading, success, error }

abstract class RagState extends Equatable {
  final List<FileEntity> uploadedFiles;

  const RagState({this.uploadedFiles = const []});

  @override
  List<Object?> get props => [uploadedFiles];
}

class RagInitial extends RagState {
  const RagInitial({super.uploadedFiles});
}

class RagLoading extends RagState {
  const RagLoading({super.uploadedFiles});
}

class RagCreated extends RagState {
  final RagSummaryEntity rag;

  const RagCreated(this.rag, {super.uploadedFiles});

  @override
  List<Object?> get props => [rag, uploadedFiles];
}

class RagEdited extends RagState {
  final RagSummaryEntity rag;

  const RagEdited(this.rag, {super.uploadedFiles});

  @override
  List<Object?> get props => [rag, uploadedFiles];
}

class RagDeleted extends RagState {
  final String deletedId;

  const RagDeleted({required this.deletedId, super.uploadedFiles});

  @override
  List<Object?> get props => [deletedId, uploadedFiles];
}

class RagsLoaded extends RagState {
  final List<RagSummaryEntity>? rags;

  const RagsLoaded({this.rags, super.uploadedFiles});

  @override
  List<Object?> get props => [rags, uploadedFiles];
}

class RagDetailLoaded extends RagState {
  final RagDetailEntity rag;

  const RagDetailLoaded({required this.rag, super.uploadedFiles});

  @override
  List<Object?> get props => [rag, uploadedFiles];
}

class RagError extends RagState {
  final String message;

  const RagError(this.message, {super.uploadedFiles});

  @override
  List<Object?> get props => [message, uploadedFiles];
}

class RagUploadedFiles extends RagState {
  final RagUploadStatus uploadStatus;
  final double uploadProgress;
  final String? uploadingFileName;
  final String? errorMessage;

  const RagUploadedFiles({
    this.uploadStatus = RagUploadStatus.initial,
    this.uploadProgress = 0.0,
    this.uploadingFileName,
    super.uploadedFiles,
    this.errorMessage,
  });

  RagUploadedFiles copyWith({
    RagUploadStatus? uploadStatus,
    double? uploadProgress,
    String? uploadingFileName,
    List<FileEntity>? uploadedFiles,
    String? errorMessage,
    bool clearUploadingFileName = false,
  }) {
    return RagUploadedFiles(
      uploadStatus: uploadStatus ?? this.uploadStatus,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      uploadingFileName:
          clearUploadingFileName
              ? null
              : uploadingFileName ?? this.uploadingFileName,
      uploadedFiles: uploadedFiles ?? this.uploadedFiles,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    uploadStatus,
    uploadProgress,
    uploadingFileName,
    uploadedFiles,
    errorMessage,
  ];
}
