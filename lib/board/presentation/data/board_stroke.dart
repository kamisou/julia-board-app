import 'dart:ui';

import 'package:julia_board/board/presentation/data/board_artifact.dart';

final class BoardStroke extends BoardArtifact {
  const BoardStroke({
    required super.id,
    required this.color,
    required this.width,
    required this.points,
  });

  final Color color;
  final double width;
  final List<Offset> points;

  BoardStroke copyWith({
    String? id,
    Color? color,
    double? width,
    List<Offset>? points,
  }) => BoardStroke(
    id: id ?? this.id,
    color: color ?? this.color,
    width: width ?? this.width,
    points: points ?? this.points,
  );

  @override
  List<Object?> get props => [id, color, width, ...points];
}
