import 'package:banya_llmops/core/entities/file_entity.dart';
import 'package:equatable/equatable.dart';

class RagDetailEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String status;
  final String vectorStore;
  final DateTime? lastIndexedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<FileEntity>? files;

  const RagDetailEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.vectorStore,
    this.lastIndexedAt,
    required this.createdAt,
    required this.updatedAt,
    this.files,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    status,
    vectorStore,
    lastIndexedAt,
    createdAt,
    updatedAt,
    files,
  ];
}
