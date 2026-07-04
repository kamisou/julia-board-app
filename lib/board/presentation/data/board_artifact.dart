import 'package:equatable/equatable.dart';

abstract class BoardArtifact extends Equatable {
  const BoardArtifact({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}
