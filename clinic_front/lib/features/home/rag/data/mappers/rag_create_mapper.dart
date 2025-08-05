import 'package:banya_llmops/features/home/rag/data/models/rag_create_model.dart';
import 'package:banya_llmops/features/home/rag/domain/entities/rag_create_entity.dart';

extension CreateRagModelToEntityMapper on RagCreateModel {
  RagCreateEntity toEntity() => RagCreateEntity(
    name: name,
    description: description,
    ragFileIds: ragFileIds,
  );
}

extension CreateRagEntityToModelMapper on RagCreateEntity {
  RagCreateModel toModel() => RagCreateModel(
    name: name,
    description: description,
    ragFileIds: ragFileIds,
  );
}
