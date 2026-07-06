import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:julia_board/core/messaging/messaging_service.dart';

final get = GetIt.instance;

Future<void> initializeDependencies() {
  get.registerSingletonAsync<MessagingService>(() async {
    final messaging = MessagingService();
    await messaging.init();
    return messaging;
  });
  get.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        headers: {'X-App-User': const String.fromEnvironment('APP_USER')},
        // ignore: avoid_redundant_argument_values
        baseUrl: const String.fromEnvironment('API_BASE_URL'),
      ),
    ),
  );
  return get.allReady();
}
