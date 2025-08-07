import 'package:banya_llmops/data/models/file_model.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rag_detail_model.g.dart';

@JsonSerializable()
class RagDetailModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final String status;
  final String vectorStore;
  final DateTime? lastIndexedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<FileModel>? files;
  @JsonKey(name: 'document_count')
  final int? documentCount;
  @JsonKey(name: 'total_size_mb')
  final double? totalSizeMb;

  const RagDetailModel({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.vectorStore,
    this.lastIndexedAt,
    required this.createdAt,
    required this.updatedAt,
    this.files,
    this.documentCount,
    this.totalSizeMb,
  });

  factory RagDetailModel.fromJson(Map<String, dynamic> json) =>
      _$RagDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$RagDetailModelToJson(this);

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
    documentCount,
    totalSizeMb,
  ];
}
