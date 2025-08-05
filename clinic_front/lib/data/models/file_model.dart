import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'file_model.g.dart';

@JsonSerializable()
class FileModel extends Equatable {
  final String id;
  final String name;
  final String publicUrl;
  final String? hash;
  final DateTime createdAt;

  const FileModel({
    required this.id,
    required this.name,
    required this.publicUrl,
    this.hash,
    required this.createdAt,
  });

  factory FileModel.fromJson(Map<String, dynamic> json) =>
      _$FileModelFromJson(json);

  Map<String, dynamic> toJson() => _$FileModelToJson(this);

  @override
  List<Object?> get props => [id, name, publicUrl, hash, createdAt];
}
