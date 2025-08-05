import 'package:banya_llmops/features/home/rag/domain/repositories/rag_repository.dart';

class DeleteRagUsecase {
  final RagRepository repository;

  DeleteRagUsecase(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteRag(id);
  }
}
