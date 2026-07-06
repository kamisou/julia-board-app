import 'dart:ui';

import 'package:julia_board/board/presentation/data/board_artifact.dart';

final class BoardArtifactMapper {
  static BoardArtifact fromMap(Map<String, Object?> map) {
    return switch (map['type']) {
      'stroke' => BoardStroke(
        id: map['id'] as String,
        color: Color(int.parse(map['color'] as String, radix: 16)),
        width: (map['width'] as num).toDouble(),
        points: (map['points'] as List)
            .map(
              (e) => Offset(
                (e['x'] as num).toDouble(),
                (e['y'] as num).toDouble(),
              ),
            )
            .toList(),
      ),
      _ => throw ArgumentError(),
    };
  }

  static Map<String, Object?> toMap(BoardArtifact artifact) => {
    'id': artifact.id,
    if (artifact case BoardStroke(
      :final color,
      :final width,
      :final points,
    )) ...{
      'type': 'stroke',
      'color': color.toARGB32().toRadixString(16),
      'width': width,
      'points': points.map((e) => {'x': e.dx, 'y': e.dy}).toList(),
    },
  };
}
