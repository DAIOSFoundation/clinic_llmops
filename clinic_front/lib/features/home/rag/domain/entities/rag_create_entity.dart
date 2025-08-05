import 'package:equatable/equatable.dart';

class RagCreateEntity extends Equatable {
  final String name;
  final String description;
  final List<String> ragFileIds;

  const RagCreateEntity({
    required this.name,
    required this.description,
    required this.ragFileIds,
  });

  @override
  List<Object?> get props => [name, description, ragFileIds];
}
