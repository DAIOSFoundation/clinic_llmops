import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

class UploadEntity extends Equatable {
  final String fileName;
  final Uint8List fileBytes;
  final String fileType;

  const UploadEntity({
    required this.fileName,
    required this.fileBytes,
    required this.fileType,
  });

  @override
  List<Object?> get props => [fileName, fileBytes, fileType];
}
