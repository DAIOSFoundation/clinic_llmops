import 'package:banya_llmops/features/home/rag/data/models/rag_summary_model.dart';
import 'package:banya_llmops/features/home/rag/domain/entities/rag_entity.dart';

extension RagSummaryModelToEntityMapper on RagSummaryModel {
  RagSummaryEntity toEntity() => RagSummaryEntity(
    id: id,
    name: name,
    description: description,
    status: status,
    createdAt: createdAt,
  );
}

extension RagSummaryEntityToModelMapper on RagSummaryEntity {
  RagSummaryModel toModel() => RagSummaryModel(
    id: id,
    name: name,
    description: description,
    status: status,
    createdAt: createdAt,
  );
}
