import 'package:equatable/equatable.dart';

class RagEditEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final List<String> ragFileIds;

  const RagEditEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.ragFileIds,
  });

  @override
  List<Object?> get props => [id, name, description, ragFileIds];
}
