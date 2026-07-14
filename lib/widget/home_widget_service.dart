import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';

/// Wakes the native Android home screen widget so it refreshes itself.
///
/// Fetching the board and rasterising it now happens entirely on the native
/// side ([BoardGlanceWidget]); this service's only job is to nudge the widget
/// to re-render. An FCM message (foreground listener or the background isolate)
/// triggers [refresh], which broadcasts an update to the widget receiver. Safe
/// to call from a background isolate and swallows failures so a transient error
/// never crashes the FCM handler.
final class HomeWidgetService {
  const HomeWidgetService._();

  /// Fully qualified name of the native Glance widget receiver.
  static const _androidProvider =
      'br.com.kamis.julia_board.BoardWidgetReceiver';

  /// Broadcasts an update so the native widget re-fetches and re-renders.
  static Future<void> refresh() async {
    try {
      await HomeWidget.updateWidget(qualifiedAndroidName: _androidProvider);
    } catch (error, stackTrace) {
      debugPrint('HomeWidgetService.refresh failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }
}
