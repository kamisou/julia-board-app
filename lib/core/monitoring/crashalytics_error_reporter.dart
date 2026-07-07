import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:julia_board/core/monitoring/error_reporter.dart';

final class CrashalyticsErrorReporter implements ErrorReporter {
  const CrashalyticsErrorReporter();

  @override
  FutureOr<void> log(Object error, StackTrace stackTrace) {
    return FirebaseCrashlytics.instance.recordError(error, stackTrace);
  }
}
