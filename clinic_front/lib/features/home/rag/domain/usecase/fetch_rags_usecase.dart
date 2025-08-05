import 'package:banya_llmops/features/home/rag/domain/entities/rag_entity.dart';
import 'package:banya_llmops/features/home/rag/domain/repositories/rag_repository.dart';

class FetchRagsUsecase {
  final RagRepository repository;

  FetchRagsUsecase(this.repository);

  Future<List<RagSummaryEntity>> call() async {
    return await repository.fetchRags();
  }
}
