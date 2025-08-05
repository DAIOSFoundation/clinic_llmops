import 'package:banya_llmops/core/entities/file_entity.dart';
import 'package:banya_llmops/core/entities/upload_entity.dart';
import 'package:banya_llmops/features/home/rag/domain/repositories/rag_repository.dart';

class UploadRagFileUsecase {
  final RagRepository repository;

  UploadRagFileUsecase(this.repository);

  Future<FileEntity> call(
    UploadEntity uploadEntity,
    Function(double progress) onProgressUpdate,
  ) async {
    return await repository.uploadRagFile(uploadEntity, onProgressUpdate);
  }
}
