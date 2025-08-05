import 'package:banya_llmops/features/home/rag/data/models/rag_edit_model.dart';
import 'package:banya_llmops/features/home/rag/domain/entities/rag_update_entity.dart';

extension EditRagModelToEntityMapper on RagEditModel {
  RagEditEntity toEntity() => RagEditEntity(
    id: id,
    name: name,
    description: description,
    ragFileIds: ragFileIds,
  );
}

extension EditRagEntityToModelMapper on RagEditEntity {
  RagEditModel toModel() => RagEditModel(
    id: id,
    name: name,
    description: description,
    ragFileIds: ragFileIds,
  );
}
