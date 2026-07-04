import 'package:get_it/get_it.dart';
import 'package:julia_board/core/network/network_info.dart';

final get = GetIt.instance;

void initializeDependencies() {
  get.registerSingletonAsync<NetworkInfo>(() async {
    final info = NetworkInfo();
    await info.init();
    return info;
  }, dispose: (info) => info.dispose());
  get.isReadySync<NetworkInfo>();
}
