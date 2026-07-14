import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:julia_board/board/presentation/screen/board_screen.dart';
import 'package:julia_board/core/bloc/error_reporter_bloc_observer.dart';
import 'package:julia_board/core/messaging/fcm_background_handler.dart';
import 'package:julia_board/core/messaging/messaging_service.dart';
import 'package:julia_board/core/monitoring/crashalytics_error_reporter.dart';
import 'package:julia_board/get_it.dart';
import 'package:julia_board/notification/data/repository/notification_repository.dart';
import 'package:julia_board/widget/home_widget_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await initializeDependencies();
  await GoogleFonts.pendingFonts([GoogleFonts.outfitTextTheme()]);
  FirebaseMessaging.onBackgroundMessage(fcmBackgroundHandler);
  FirebaseMessaging.onMessage.listen(
    (_) => HomeWidgetService.refresh(),
  );
  if (!kDebugMode) {
    FlutterError.onError = (errorDetails) {
      FlutterError.presentError(errorDetails);
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
    Bloc.observer = const ErrorReporterBlocObserver(
      reporter: CrashalyticsErrorReporter(),
    );
  }
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<NotificationRepository>(
      create: (context) {
        final repo = NotificationRepository(
          dio: get<Dio>(),
          messaging: get<MessagingService>(),
        );
        repo.open();
        return repo;
      },
      lazy: false,
      dispose: (repo) => repo.close(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const BoardScreen(),
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
          colorScheme: ColorScheme.fromSeed(
            brightness: Brightness.dark,
            seedColor: const Color(0xFFB884CC),
          ),
          textTheme: GoogleFonts.outfitTextTheme(),
        ),
      ),
    );
  }
}
