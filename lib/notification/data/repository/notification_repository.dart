import 'dart:async';

import 'package:dio/dio.dart';
import 'package:julia_board/core/messaging/messaging_service.dart';

final class NotificationRepository {
  NotificationRepository({
    required this.dio,
    required this.messaging,
  });

  final Dio dio;
  final MessagingService messaging;

  StreamSubscription<String>? _subscription;

  Future<void> open() async {
    _subscription = messaging.tokenStream().listen((token) async {
      await dio.post('/users/token', data: {'token': token});
    });
    await messaging.init();
  }

  Future<void> close() async {
    await _subscription?.cancel();
    return messaging.dispose();
  }
}
