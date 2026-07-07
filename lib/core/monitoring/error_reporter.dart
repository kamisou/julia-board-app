import 'dart:async';

abstract interface class ErrorReporter {
  FutureOr<void> log(Object error, StackTrace stackTrace);
}
