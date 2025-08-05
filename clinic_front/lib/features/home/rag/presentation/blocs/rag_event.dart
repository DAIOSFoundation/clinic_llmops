import 'dart:typed_data';

import 'package:banya_llmops/core/entities/file_entity.dart';
import 'package:equatable/equatable.dart';

abstract class RagEvent extends Equatable {
  const RagEvent();

  @override
  List<Object?> get props => [];
}

class FetchRags extends RagEvent {}

class FetchRagDetail extends RagEvent {
  final String id;

  const FetchRagDetail(this.id);

  @override
  List<Object?> get props => [id];
}

class InvalidRagIdEvent extends RagEvent {
  final String message;

  const InvalidRagIdEvent(this.message);

  @override
  List<Object?> get props => [message];
}

class UploadRagFile extends RagEvent {
  final String fileName;
  final Uint8List fileBytes;
  final String fileType;

  const UploadRagFile({
    required this.fileName,
    required this.fileBytes,
    required this.fileType,
  });

  @override
  List<Object?> get props => [fileName, fileBytes, fileType];
}

class CreateRag extends RagEvent {
  final String name;
  final String description;
  final List<String> ragFileIds;

  const CreateRag({
    required this.name,
    required this.description,
    required this.ragFileIds,
  });

  @override
  List<Object?> get props => [name, description, ragFileIds];
}

class EditRag extends RagEvent {
  final String id;
  final String name;
  final String description;
  final List<String> ragFileIds;

  const EditRag({
    required this.id,
    required this.name,
    required this.description,
    required this.ragFileIds,
  });

  @override
  List<Object?> get props => [name, description, ragFileIds];
}

class RemoveUploadedFile extends RagEvent {
  final String fileId;
  const RemoveUploadedFile(this.fileId);
  @override
  List<Object?> get props => [fileId];
}

class SetUploadedFiles extends RagEvent {
  final List<FileEntity> files;

  const SetUploadedFiles(this.files);
}

class DeleteRag extends RagEvent {
  final String id;
  const DeleteRag(this.id);
}

class ResetRagState extends RagEvent {}
