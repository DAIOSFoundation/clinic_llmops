import 'package:banya_llmops/core/entities/upload_entity.dart';
import 'package:banya_llmops/data/models/upload_model.dart';

extension UploadEntityToModelMapper on UploadEntity {
  UploadModel toModel() =>
      UploadModel(fileName: fileName, fileType: fileType, fileBytes: fileBytes);
}

extension UploadModelToEntityMapper on UploadModel {
  UploadEntity toEntity() => UploadEntity(
    fileName: fileName,
    fileType: fileType,
    fileBytes: fileBytes,
  );
}
