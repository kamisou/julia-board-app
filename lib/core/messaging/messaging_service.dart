import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';

final class MessagingService {
  final messaging = FirebaseMessaging.instance;

  StreamSubscription? _subscription;

  final _controller = StreamController<String>.broadcast();
  Stream<String> tokenStream() => _controller.stream;

  Future<String> get currentToken => _controller.stream.last;

  Future<void> init() async {
    await messaging.requestPermission();

    _subscription = messaging.onTokenRefresh.listen(_controller.add);

    final token = await messaging.getToken();
    if (token != null) _controller.add(token);
  }

  Future<void> dispose() async {
    await _controller.close();
    return _subscription?.cancel();
  }
}
