import 'package:banya_llmops/features/home/rag/domain/entities/rag_detail_entity.dart';
import 'package:banya_llmops/features/home/rag/domain/repositories/rag_repository.dart';

class FetchRagDetailUsecase {
  final RagRepository repository;

  FetchRagDetailUsecase(this.repository);

  Future<RagDetailEntity> call(String id) async {
    return await repository.fetchRagDetail(id);
  }
}
