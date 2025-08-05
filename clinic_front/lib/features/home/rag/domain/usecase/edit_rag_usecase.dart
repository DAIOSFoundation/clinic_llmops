import 'package:banya_llmops/features/home/rag/domain/entities/rag_entity.dart';
import 'package:banya_llmops/features/home/rag/domain/entities/rag_update_entity.dart';
import 'package:banya_llmops/features/home/rag/domain/repositories/rag_repository.dart';

class EditRagUsecase {
  final RagRepository repository;

  EditRagUsecase(this.repository);

  Future<RagSummaryEntity> call(RagEditEntity ragEntity) async {
    return await repository.editRag(ragEntity);
  }
}
