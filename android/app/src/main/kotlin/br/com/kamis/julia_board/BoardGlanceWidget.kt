package br.com.kamis.julia_board

import android.content.Context
import android.graphics.BitmapFactory
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.Image
import androidx.glance.ImageProvider
import androidx.glance.action.clickable
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.cornerRadius
import androidx.glance.appwidget.provideContent
import androidx.glance.background
import androidx.glance.currentState
import androidx.glance.layout.Alignment
import androidx.glance.layout.Box
import androidx.glance.layout.ContentScale
import androidx.glance.layout.fillMaxSize
import androidx.glance.layout.padding
import androidx.glance.text.Text
import androidx.glance.text.TextStyle
import androidx.glance.unit.ColorProvider
import es.antonborri.home_widget.HomeWidgetGlanceState
import es.antonborri.home_widget.HomeWidgetGlanceStateDefinition
import es.antonborri.home_widget.actionStartActivity

/**
 * Jetpack Glance widget that mirrors the drawing board on the home screen.
 *
 * The Flutter side rasterises the board to a PNG and stores its path under
 * [IMAGE_KEY] through the `home_widget` plugin. That plugin's
 * [HomeWidgetGlanceStateDefinition] exposes the same [android.content.SharedPreferences]
 * here as Glance state, so a refresh from Dart recomposes this widget. Tapping
 * it opens the app.
 */
class BoardGlanceWidget : GlanceAppWidget() {

    /** Wires Glance state to the preferences written by `home_widget`. */
    override val stateDefinition = HomeWidgetGlanceStateDefinition()

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        provideContent { BoardContent(context, currentState()) }
    }

    @Composable
    private fun BoardContent(context: Context, state: HomeWidgetGlanceState) {
        val imagePath = state.preferences.getString(IMAGE_KEY, null)
        val bitmap = imagePath?.let { BitmapFactory.decodeFile(it) }

        Box(
            modifier = GlanceModifier
                .fillMaxSize()
                .background(BACKGROUND)
                .cornerRadius(16.dp)
                .padding(4.dp)
                .clickable(actionStartActivity<MainActivity>(context)),
            contentAlignment = Alignment.Center,
        ) {
            if (bitmap != null) {
                Image(
                    provider = ImageProvider(bitmap),
                    contentDescription = "Julia Board",
                    modifier = GlanceModifier.fillMaxSize(),
                    contentScale = ContentScale.Fit,
                )
            } else {
                Text(
                    text = "Nenhum Desenho!",
                    style = TextStyle(
                        color = ColorProvider(Color.White),
                        fontSize = 14.sp,
                    ),
                )
            }
        }
    }

    companion object {
        private const val IMAGE_KEY = "board_image"
        private val BACKGROUND = Color(0xFF211F26)
    }
}
