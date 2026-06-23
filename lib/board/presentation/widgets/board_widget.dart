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
          builder: (context, constraints) => GestureDetector(
            onPanStart: (details) {
              final pos = details.localPosition;
              _startComposing(pos, state);
            },
            onPanUpdate: (details) {
              final pos = details.localPosition;
              final oob =
                  pos.dx < 0 ||
                  pos.dy < 0 ||
                  pos.dx >= constraints.maxWidth ||
                  pos.dy >= constraints.maxHeight;
              if (oob) {
                _emitStroke(context);
                return;
              }
              if (_composing == null) _startComposing(pos, state);
              final far =
                  _composing!.points.length == 1 ||
                  (pos - _composing!.points.last).distanceSquared > 5;
              if (far) setState(() => _composing!.points.add(pos));
            },
            onPanEnd: (details) {
              final pos = details.localPosition;
              if (_composing != null) {
                setState(() => _composing!.points.add(pos));
              }
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
                  strokes: [...state.strokes, ?_composing],
                ),
              ),
            ),
          ),
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
    context.read<BoardBloc>().add(StrokeAdded(stroke: _composing!));
    _composing = null;
  }
}

class _BoardPainter extends CustomPainter {
  const _BoardPainter({
    required this.strokes,
  });

  final List<BoardStroke> strokes;

  @override
  void paint(Canvas canvas, Size size) {
    for (final stroke in strokes) {
      final paint = Paint()
        ..color = stroke.color
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round
        ..strokeWidth = stroke.width;
      if (stroke.points.length == 1) {
        canvas.drawPoints(PointMode.points, stroke.points, paint);
      } else {
        final segments = IterableZip([stroke.points, stroke.points.skip(1)]);
        for (final segment in segments) {
          canvas.drawLine(segment.first, segment.last, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _BoardPainter oldDelegate) {
    return listEquals(strokes, oldDelegate.strokes);
  }
}
