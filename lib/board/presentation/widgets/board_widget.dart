import 'dart:math';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:julia_board/board/presentation/bloc/board_bloc.dart';
import 'package:julia_board/board/presentation/data/board_stroke.dart';

class BoardWidget extends StatefulWidget {
  const BoardWidget({
    super.key,
    this.aspectRatio = 1.0,
  });

  final double aspectRatio;

  @override
  State<BoardWidget> createState() => _BoardWidgetState();
}

class _BoardWidgetState extends State<BoardWidget> {
  BoardStroke? _composing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: BlocBuilder<BoardBloc, BoardState>(
        builder: (context, state) => LayoutBuilder(
          builder: (context, constraints) {
            final max = constraints.maxWidth;
            return GestureDetector(
              onPanStart: state.status != BoardStatus.loading
                  ? (details) {
                      final pos = details.localPosition.scale(
                        1.0 / max,
                        1.0 / max,
                      );
                      _startComposing(pos, state);
                    }
                  : null,
              onPanUpdate: state.status != BoardStatus.loading
                  ? (details) {
                      final pos = details.localPosition.scale(
                        1.0 / max,
                        1.0 / max,
                      );
                      final oob =
                          pos.dx < 0 ||
                          pos.dy < 0 ||
                          pos.dx >= 1.0 ||
                          pos.dy >= 1.0;
                      if (oob) {
                        _emitStroke(context);
                        return;
                      }
                      if (_composing == null) _startComposing(pos, state);
                      setState(() => _composing!.points.add(pos));
                    }
                  : null,
              onPanEnd: state.status != BoardStatus.loading
                  ? (details) {
                      final pos = details.localPosition.scale(
                        1.0 / max,
                        1.0 / max,
                      );
                      if (_composing != null) _composing!.points.add(pos);
                      _emitStroke(context);
                    }
                  : null,
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: theme.colorScheme.surfaceContainer,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),
                  shadows: [
                    BoxShadow(
                      blurRadius: 12,
                      color: theme.colorScheme.shadow.withAlpha(32),
                    ),
                  ],
                ),
                child: CustomPaint(
                  painter: _BoardPainter(
                    composing: _composing,
                    strokes: state.strokes,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _startComposing(Offset pos, BoardState state) {
    setState(() {
      _composing = BoardStroke(
        points: [pos],
        color: state.color,
        width: state.width,
      );
    });
  }

  void _emitStroke(BuildContext context) {
    if (_composing == null) return;
    context.read<BoardBloc>().add(
      StrokeAdded(
        stroke: _composing!.copyWith(
          points: _douglasPecker(_composing!.points),
        ),
      ),
    );
    _composing = null;
  }

  List<Offset> _douglasPecker(List<Offset> points, [double epsilon = 0.0035]) {
    if (points.length < 3) return points;

    var maxDistance = 0.0;
    var index = 0;
    for (var i = 1; i < points.length - 1; i++) {
      final distance = _perpendicularDistance(
        points.first,
        points.last,
        points[i],
      );
      if (distance > maxDistance) {
        maxDistance = distance;
        index = i;
      }
    }

    if (maxDistance <= epsilon) {
      return [points.first, points.last];
    }

    final left = _douglasPecker(points.sublist(0, index + 1), epsilon);
    final right = _douglasPecker(points.sublist(index), epsilon);
    return [...left.sublist(0, left.length - 1), ...right];
  }

  double _perpendicularDistance(Offset a, Offset b, Offset p) {
    final dx = b.dx - a.dx;
    final dy = b.dy - a.dy;
    final lengthSquared = dx * dx + dy * dy;

    if (lengthSquared == 0) return (p - a).distance;

    final numerator = (dy * p.dx - dx * p.dy + b.dx * a.dy - b.dy * a.dx).abs();
    return numerator / sqrt(lengthSquared);
  }
}

class _BoardPainter extends CustomPainter {
  const _BoardPainter({
    required this.strokes,
    this.composing,
  });

  final List<BoardStroke> strokes;
  final BoardStroke? composing;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width);
    for (final stroke in [...strokes, ?composing]) {
      final paint = Paint()
        ..color = stroke.color
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round
        ..strokeWidth = stroke.width / size.width;
      canvas.drawPoints(
        stroke.points.length == 1 ? PointMode.points : PointMode.polygon,
        stroke.points,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BoardPainter oldDelegate) {
    return composing != oldDelegate.composing ||
        strokes.length == oldDelegate.strokes.length;
  }
}
