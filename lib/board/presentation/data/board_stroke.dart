import 'dart:ui';

import 'package:equatable/equatable.dart';

final class BoardStroke extends Equatable {
  const BoardStroke({
    required this.color,
    required this.width,
    required this.points,
  });

  final Color color;
  final double width;
  final List<Offset> points;

  @override
  List<Object?> get props => [color, width, ...points];
}
