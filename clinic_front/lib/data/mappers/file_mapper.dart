import 'package:banya_llmops/core/entities/file_entity.dart';
import 'package:banya_llmops/data/models/file_model.dart';

extension FileModelToEntityMapper on FileModel {
  FileEntity toEntity() => FileEntity(
    id: id,
    name: name,
    publicUrl: publicUrl,
    hash: hash,
    createdAt: createdAt,
  );
}

extension FileEntityToModelMapper on FileEntity {
  FileModel toModel() => FileModel(
    id: id,
    name: name,
    publicUrl: publicUrl,
    hash: hash,
    createdAt: createdAt,
  );
}
