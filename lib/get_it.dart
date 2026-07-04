import 'package:get_it/get_it.dart';
import 'package:julia_board/core/network/api_client.dart';
import 'package:julia_board/core/network/network_info.dart';

final get = GetIt.instance;

Future<void> initializeDependencies() async {
  get.registerSingleton<ApiClient>(ApiClient(baseUrl: ''));
  get.registerSingletonAsync<NetworkInfo>(() async {
    final info = NetworkInfo();
    await info.init();
    return info;
  }, dispose: (info) => info.dispose());
  await get.isReady<NetworkInfo>();
}
