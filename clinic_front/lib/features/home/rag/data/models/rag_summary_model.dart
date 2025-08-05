import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rag_summary_model.g.dart';

@JsonSerializable()
class RagSummaryModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final String status;
  final DateTime createdAt;

  const RagSummaryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.createdAt,
  });

  factory RagSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$RagSummaryModelFromJson(json);

  Map<String, dynamic> toJson() => _$RagSummaryModelToJson(this);

  @override
  List<Object?> get props => [id, name, description, status, createdAt];
}
