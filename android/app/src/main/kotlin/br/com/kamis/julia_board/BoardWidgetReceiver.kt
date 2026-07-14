package br.com.kamis.julia_board

import es.antonborri.home_widget.HomeWidgetGlanceWidgetReceiver

/**
 * Receiver that binds [BoardGlanceWidget] to the launcher and forwards
 * `home_widget` update broadcasts to it. The Flutter side calls
 * `HomeWidget.updateWidget` (foreground or FCM background isolate) purely to
 * wake the widget; the widget then fetches and rasterises the board itself.
 */
class BoardWidgetReceiver : HomeWidgetGlanceWidgetReceiver<BoardGlanceWidget>() {
    override val glanceAppWidget = BoardGlanceWidget()
}
