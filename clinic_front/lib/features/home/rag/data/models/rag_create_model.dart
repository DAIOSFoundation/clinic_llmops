import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rag_create_model.g.dart';

@JsonSerializable()
class RagCreateModel extends Equatable {
  final String name;
  final String description;
  final List<String> ragFileIds;
  const RagCreateModel({
    required this.name,
    required this.description,
    required this.ragFileIds,
  });

  factory RagCreateModel.fromJson(Map<String, dynamic> json) =>
      _$RagCreateModelFromJson(json);

  Map<String, dynamic> toJson() => _$RagCreateModelToJson(this);

  @override
  List<Object?> get props => [name, description, ragFileIds];
}
