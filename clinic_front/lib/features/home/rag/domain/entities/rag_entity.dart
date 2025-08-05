import 'package:banya_llmops/shared/entities/base_entity.dart';

class RagSummaryEntity extends BaseEntity {
  final String status;

  const RagSummaryEntity({
    required this.status,
    required super.id,
    required super.name,
    required super.description,
    required super.createdAt,
  });

  @override
  List<Object?> get props => [...super.props, status];
}
