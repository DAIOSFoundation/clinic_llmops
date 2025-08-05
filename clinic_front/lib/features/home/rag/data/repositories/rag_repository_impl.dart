import 'package:banya_llmops/core/entities/file_entity.dart';
import 'package:banya_llmops/core/entities/upload_entity.dart';
import 'package:banya_llmops/data/mappers/file_mapper.dart';
import 'package:banya_llmops/data/mappers/upload_mapper.dart';
import 'package:banya_llmops/features/home/rag/data/datasources/rag_datasource.dart';
import 'package:banya_llmops/features/home/rag/data/mappers/rag_create_mapper.dart';
import 'package:banya_llmops/features/home/rag/data/mappers/rag_detail_mapper.dart';
import 'package:banya_llmops/features/home/rag/data/mappers/rag_edit_mapper.dart';
import 'package:banya_llmops/features/home/rag/data/mappers/rag_summary_mapper.dart';
import 'package:banya_llmops/features/home/rag/domain/entities/rag_create_entity.dart';
import 'package:banya_llmops/features/home/rag/domain/entities/rag_detail_entity.dart';
import 'package:banya_llmops/features/home/rag/domain/entities/rag_entity.dart';
import 'package:banya_llmops/features/home/rag/domain/entities/rag_update_entity.dart';
import 'package:banya_llmops/features/home/rag/domain/repositories/rag_repository.dart';

class RagRepositoryImpl extends RagRepository {
  final RagDataSource ragDataSource;

  RagRepositoryImpl({required this.ragDataSource});

  @override
  Future<RagDetailEntity> fetchRagDetail(String id) async {
    try {
      final result = await ragDataSource.fetchRagDetail(id);
      return result.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<RagSummaryEntity>> fetchRags() async {
    try {
      final result = await ragDataSource.fetchRags();

      return result.map((model) => model.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<FileEntity> uploadRagFile(
    UploadEntity uploadEntity,
    Function(double progress) onProgressUpdate,
  ) async {
    final uploadModel = uploadEntity.toModel();
    final result = await ragDataSource.uploadRagFile(
      uploadModel,
      onProgressUpdate,
    );
    return result.toEntity();
  }

  @override
  Future<RagSummaryEntity> createRag(RagCreateEntity ragEntity) async {
    try {
      final ragModel = ragEntity.toModel();
      final result = await ragDataSource.createRag(ragModel);
      return result.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<RagSummaryEntity> editRag(RagEditEntity ragEntity) async {
    try {
      final ragModel = ragEntity.toModel();
      final result = await ragDataSource.editRag(ragModel);
      return result.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteRag(String id) async {
    try {
      await ragDataSource.deleteRag(id);
      return;
    } catch (e) {
      rethrow;
    }
  }
}
