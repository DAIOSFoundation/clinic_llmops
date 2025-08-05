import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rag_edit_model.g.dart';

@JsonSerializable()
class RagEditModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final List<String> ragFileIds;
  const RagEditModel({
    required this.id,
    required this.name,
    required this.description,
    required this.ragFileIds,
  });

  factory RagEditModel.fromJson(Map<String, dynamic> json) =>
      _$RagEditModelFromJson(json);

  Map<String, dynamic> toJson() => _$RagEditModelToJson(this);

  @override
  List<Object?> get props => [id, name, description, ragFileIds];
}
