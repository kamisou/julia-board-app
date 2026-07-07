import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:julia_board/core/monitoring/error_reporter.dart';

final class ErrorReporterBlocObserver extends BlocObserver {
  const ErrorReporterBlocObserver({
    required this.reporter,
  });

  final ErrorReporter reporter;

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    reporter.log(error, stackTrace);
    super.onError(bloc, error, stackTrace);
  }
}
