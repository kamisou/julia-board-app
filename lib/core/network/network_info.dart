import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

final class NetworkInfo {
  final _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  Future<void> init() async {
    final result = await _connectivity.checkConnectivity();
    _hasConnection = _isConnected(result);
    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      _hasConnection = _isConnected(result);
    });
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
  }

  bool _isConnected(List<ConnectivityResult> result) {
    return result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi);
  }

  bool _hasConnection = false;
  bool get hasConnection => _hasConnection;
}
