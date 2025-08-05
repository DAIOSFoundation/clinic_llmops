import 'package:equatable/equatable.dart';

class FileEntity extends Equatable {
  final String id;
  final String name;
  final String publicUrl;
  final String? hash;
  final DateTime createdAt;

  const FileEntity({
    required this.id,
    required this.name,
    required this.publicUrl,
    this.hash,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, publicUrl, hash, createdAt];
}
