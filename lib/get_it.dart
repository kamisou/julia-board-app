import 'package:get_it/get_it.dart';
import 'package:julia_board/core/device/device_id.dart';
import 'package:julia_board/core/network/api_client.dart';
import 'package:julia_board/core/network/network_info.dart';

final get = GetIt.instance;

Future<void> initializeDependencies() async {
  get.registerSingleton<ApiClient>(ApiClient(baseUrl: 'http://localhost:3000'));
  get.registerSingleton<DeviceInfo>(DeviceInfo());
  get.registerSingletonAsync<NetworkInfo>(() async {
    final info = NetworkInfo();
    await info.init();
    return info;
  }, dispose: (info) => info.dispose());
  await get.isReady<NetworkInfo>();
}
