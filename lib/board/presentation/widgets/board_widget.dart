import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:julia_board/board/presentation/data/board_artifact.dart';
import 'package:julia_board/board/presentation/bloc/board_bloc.dart';
import 'package:uuid/uuid.dart';

class BoardWidget extends StatefulWidget {
  const BoardWidget({
    super.key,
    this.aspectRatio = 585.0 / 678.0, // android widget aspect ratio
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
              onPanStart: (details) {
                final pos = details.localPosition.scale(
                  1.0 / max,
                  1.0 / max,
                );
                _startComposing(pos, state);
              },
              onPanUpdate: (details) {
                final pos = details.localPosition.scale(
                  1.0 / max,
                  1.0 / max,
                );
                final oob =
                    pos.dx < 0 || pos.dy < 0 || pos.dx >= 1.0 || pos.dy >= 1.0;
                if (oob) {
                  _emitStroke(context);
                  return;
                }
                if (_composing == null) _startComposing(pos, state);
                setState(() => _composing!.points.add(pos));
              },
              onPanEnd: (details) {
                final pos = details.localPosition.scale(
                  1.0 / max,
                  1.0 / max,
                );
                if (_composing != null) _composing!.points.add(pos);
                _emitStroke(context);
              },
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
                    artifacts: state.artifacts,
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
        id: const Uuid().v4(),
        points: [pos],
        color: state.color,
        width: state.width,
      );
    });
  }

  void _emitStroke(BuildContext context) {
    if (_composing == null) return;
    context.read<BoardBloc>().add(
      ArtifactAdded(
        artifact: _composing!.copyWith(
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
    required this.artifacts,
    this.composing,
  });

  final List<BoardArtifact> artifacts;
  final BoardArtifact? composing;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width);
    for (final artifact in [...artifacts, ?composing]) {
      switch (artifact) {
        case BoardStroke(:final color, :final width, :final points):
          final paint = Paint()
            ..color = color
            ..strokeJoin = StrokeJoin.round
            ..strokeCap = StrokeCap.round
            ..strokeWidth = width / size.width;
          canvas.drawPoints(
            points.length == 1 ? PointMode.points : PointMode.polygon,
            points,
            paint,
          );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _BoardPainter oldDelegate) {
    return composing != oldDelegate.composing ||
        artifacts.length == oldDelegate.artifacts.length;
  }
}
