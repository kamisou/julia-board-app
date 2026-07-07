import 'dart:io';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:julia_board/board/data/mapper/board_artifact_mapper.dart';
import 'package:julia_board/board/presentation/data/board_artifact.dart';
import 'package:path_provider/path_provider.dart';

/// Bridges the drawing board with the native Android home screen widget.
///
/// The flow is: an FCM message wakes the app (foreground listener or the
/// background isolate) which calls [refreshFromRemote]. That fetches the latest
/// board from `GET /board/:id`, rasterises it to a PNG and hands the file path
/// to the native [BoardWidgetProvider] through [HomeWidget].
final class HomeWidgetService {
  const HomeWidgetService._();

  static const _appUser = String.fromEnvironment('APP_USER');
  static const _baseUrl = String.fromEnvironment('API_BASE_URL');

  /// Fully qualified name of the native Glance widget receiver.
  static const _androidProvider =
      'br.com.kamis.julia_board.BoardWidgetReceiver';

  /// Keys shared with the native side through [HomeWidget]'s [SharedPreferences].
  static const imageKey = 'board_image';
  static const updatedAtKey = 'board_updated_at';

  /// Size, in pixels, of the rasterised board. The board is square and drawn in
  /// a normalised `0..1` coordinate space, so a single dimension is enough.
  static const _canvasSize = 1024;

  /// Background used behind the strokes. Mirrors the app's dark surface so the
  /// widget blends with the in-app board.
  static const _background = Color(0xFF211F26);

  /// Fetches the board from the backend and republishes it to the widget.
  ///
  /// Safe to call from a background isolate: it builds its own [Dio] instance
  /// (the app's DI container is not available off the main isolate) and swallows
  /// failures so a transient network error never crashes the FCM handler.
  static Future<void> refreshFromRemote() async {
    try {
      final artifacts = await _fetchBoard();
      await publish(artifacts);
    } catch (error, stackTrace) {
      debugPrint('HomeWidgetService.refreshFromRemote failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  /// Renders [artifacts] and pushes them to the native widget.
  static Future<void> publish(List<BoardArtifact> artifacts) async {
    final png = await _rasterise(artifacts);
    final directory = await getApplicationSupportDirectory();
    final file = File('${directory.path}/board_widget.png');
    await file.writeAsBytes(png, flush: true);

    await HomeWidget.saveWidgetData<String>(imageKey, file.path);
    await HomeWidget.saveWidgetData<int>(
      updatedAtKey,
      DateTime.now().millisecondsSinceEpoch,
    );
    await HomeWidget.updateWidget(qualifiedAndroidName: _androidProvider);
  }

  static Future<List<BoardArtifact>> _fetchBoard() async {
    final dio = Dio(
      BaseOptions(
        // ignore: avoid_redundant_argument_values
        baseUrl: _baseUrl,
        headers: {'X-App-User': _appUser},
      ),
    );
    final response = await dio.get<Object?>('/board/$_appUser');
    final data = response.data;
    final rawArtifacts = switch (data) {
      {'artifacts': final List<Object?> list} => list,
      final List<Object?> list => list,
      _ => const <Object?>[],
    };
    return rawArtifacts
        .map((e) => BoardArtifactMapper.fromMap((e as Map).cast<String, Object?>()))
        .toList();
  }

  /// Reproduces `_BoardPainter` off-screen so the widget matches the in-app
  /// rendering exactly (normalised points, width scaled by canvas size).
  static Future<Uint8List> _rasterise(List<BoardArtifact> artifacts) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final size = _canvasSize.toDouble();

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size, size),
      Paint()..color = _background,
    );

    canvas.scale(size);
    for (final artifact in artifacts) {
      switch (artifact) {
        case BoardStroke(:final color, :final width, :final points):
          final paint = Paint()
            ..color = color
            ..strokeJoin = StrokeJoin.round
            ..strokeCap = StrokeCap.round
            ..strokeWidth = width / size;
          canvas.drawPoints(
            points.length == 1 ? ui.PointMode.points : ui.PointMode.polygon,
            points,
            paint,
          );
      }
    }

    final picture = recorder.endRecording();
    final image = await picture.toImage(_canvasSize, _canvasSize);
    try {
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      return bytes!.buffer.asUint8List();
    } finally {
      image.dispose();
      picture.dispose();
    }
  }
}
