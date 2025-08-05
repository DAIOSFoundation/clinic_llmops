import 'package:banya_llmops/shared/utils/base64_converter.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';

part 'upload_model.g.dart';

@JsonSerializable()
class UploadModel extends Equatable {
  final String fileName;

  @Uint8ListBase64Converter()
  final Uint8List fileBytes;
  final String fileType;

  const UploadModel({
    required this.fileName,
    required this.fileBytes,
    required this.fileType,
  });

  factory UploadModel.fromJson(Map<String, dynamic> json) =>
      _$UploadModelFromJson(json);

  Map<String, dynamic> toJson() => _$UploadModelToJson(this);
  @override
  List<Object?> get props => [fileName, fileBytes, fileType];
}
