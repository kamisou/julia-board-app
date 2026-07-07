package br.com.kamis.julia_board

import es.antonborri.home_widget.HomeWidgetGlanceWidgetReceiver

/**
 * Receiver that binds [BoardGlanceWidget] to the launcher and forwards
 * `home_widget` update broadcasts (foreground or FCM background isolate) to it.
 */
class BoardWidgetReceiver : HomeWidgetGlanceWidgetReceiver<BoardGlanceWidget>() {
    override val glanceAppWidget = BoardGlanceWidget()
}
