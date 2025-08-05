import 'package:banya_llmops/features/home/rag/data/models/rag_detail_model.dart';
import 'package:banya_llmops/features/home/rag/domain/entities/rag_detail_entity.dart';
import 'package:banya_llmops/data/mappers/file_mapper.dart';

extension RagDetailModelToEntityMapper on RagDetailModel {
  RagDetailEntity toEntity() => RagDetailEntity(
    id: id,
    name: name,
    description: description,
    files: files?.map((fileModel) => fileModel.toEntity()).toList(),
    status: status,
    vectorStore: vectorStore,
    createdAt: createdAt,
    updatedAt: updatedAt,
    lastIndexedAt: lastIndexedAt,
  );
}

extension RagDetailEntityToModelMapper on RagDetailEntity {
  RagDetailModel toModel() => RagDetailModel(
    id: id,
    name: name,
    description: description,
    status: status,
    vectorStore: vectorStore,
    createdAt: createdAt,
    updatedAt: updatedAt,
    lastIndexedAt: lastIndexedAt,
  );
}
