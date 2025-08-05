import 'package:banya_llmops/features/home/rag/domain/entities/rag_create_entity.dart';
import 'package:banya_llmops/features/home/rag/domain/entities/rag_entity.dart';
import 'package:banya_llmops/features/home/rag/domain/repositories/rag_repository.dart';

class CreateRagUsecase {
  final RagRepository repository;

  CreateRagUsecase(this.repository);

  Future<RagSummaryEntity> call(RagCreateEntity ragEntity) async {
    return await repository.createRag(ragEntity);
  }
}
