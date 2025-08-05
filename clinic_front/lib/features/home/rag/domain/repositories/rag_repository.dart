import 'package:banya_llmops/core/entities/file_entity.dart';
import 'package:banya_llmops/core/entities/upload_entity.dart';
import 'package:banya_llmops/features/home/rag/domain/entities/rag_create_entity.dart';
import 'package:banya_llmops/features/home/rag/domain/entities/rag_detail_entity.dart';
import 'package:banya_llmops/features/home/rag/domain/entities/rag_entity.dart';
import 'package:banya_llmops/features/home/rag/domain/entities/rag_update_entity.dart';

abstract class RagRepository {
  Future<List<RagSummaryEntity>> fetchRags();
  Future<RagDetailEntity> fetchRagDetail(String id);
  Future<RagSummaryEntity> createRag(RagCreateEntity ragEntity);
  Future<FileEntity> uploadRagFile(
    UploadEntity uploadEntity,
    Function(double progress) onProgressUpdate,
  );
  Future<RagSummaryEntity> editRag(RagEditEntity ragEntity);
  Future<void> deleteRag(String id);
}
