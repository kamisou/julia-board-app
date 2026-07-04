import 'package:flutter_udid/flutter_udid.dart';

final class DeviceInfo {
  Future<String> getUniqueId() {
    return FlutterUdid.consistentUdid;
  }
}