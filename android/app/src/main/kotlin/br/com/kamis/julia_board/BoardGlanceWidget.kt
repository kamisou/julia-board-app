package br.com.kamis.julia_board

import android.content.Context
import android.graphics.Bitmap
import androidx.compose.runtime.Composable
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Canvas
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.ImageBitmap
import androidx.compose.ui.graphics.Paint
import androidx.compose.ui.graphics.PaintingStyle
import androidx.compose.ui.graphics.PointMode
import androidx.compose.ui.graphics.StrokeCap
import androidx.compose.ui.graphics.StrokeJoin
import androidx.compose.ui.graphics.asAndroidBitmap
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
import androidx.glance.layout.Alignment
import androidx.glance.layout.Box
import androidx.glance.layout.ContentScale
import androidx.glance.layout.fillMaxSize
import androidx.glance.layout.padding
import androidx.glance.text.Text
import androidx.glance.text.TextStyle
import androidx.glance.unit.ColorProvider
import es.antonborri.home_widget.actionStartActivity
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import org.json.JSONArray
import org.json.JSONObject
import org.json.JSONTokener
import java.net.HttpURLConnection
import java.net.URL

/**
 * Jetpack Glance widget that mirrors the drawing board on the home screen.
 *
 * Unlike the previous design, all board work now lives natively: whenever the
 * launcher asks for content (the widget being added, resized, or an update
 * broadcast forwarded by [BoardWidgetReceiver]), [provideGlance] fetches the
 * latest board from `GET /board/:id`, rasterises it with
 * [androidx.compose.ui.graphics.Canvas] and hands the bitmap to Glance. The
 * Flutter side only nudges the widget to refresh; it no longer renders anything.
 * Tapping the widget opens the app.
 */
class BoardGlanceWidget : GlanceAppWidget() {

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        val bitmap = runCatching { fetchAndRasterise() }.getOrNull()
        provideContent { BoardContent(context, bitmap) }
    }

    @Composable
    private fun BoardContent(context: Context, bitmap: Bitmap?) {
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

    /** Fetches the board and rasterises it, off the main thread. */
    private suspend fun fetchAndRasterise(): Bitmap? = withContext(Dispatchers.IO) {
        val strokes = fetchBoard() ?: return@withContext null
        rasterise(strokes)
    }

    /**
     * Downloads the board from the backend and parses its strokes. Returns
     * `null` on any failure (missing config, network error, non-200 response).
     */
    private fun fetchBoard(): List<Stroke>? {
        val baseUrl = BuildConfig.API_BASE_URL
        val user = BuildConfig.APP_USER
        if (baseUrl.isEmpty() || user.isEmpty()) return null

        val connection = (URL("$baseUrl/board/$user").openConnection() as HttpURLConnection).apply {
            requestMethod = "GET"
            setRequestProperty("X-App-User", user)
            connectTimeout = 10_000
            readTimeout = 10_000
        }
        return try {
            if (connection.responseCode != HttpURLConnection.HTTP_OK) return null
            val body = connection.inputStream.bufferedReader().use { it.readText() }
            parseStrokes(body)
        } catch (error: Exception) {
            null
        } finally {
            connection.disconnect()
        }
    }

    /**
     * Reproduces `_BoardPainter` off-screen so the widget matches the in-app
     * rendering exactly: normalised `0..1` points, stroke width scaled by the
     * canvas size, drawn on a [Canvas] over an [ImageBitmap].
     */
    private fun rasterise(strokes: List<Stroke>): Bitmap {
        val size = CANVAS_SIZE.toFloat()
        val image = ImageBitmap(CANVAS_SIZE, CANVAS_SIZE)
        val canvas = Canvas(image)

        canvas.drawRect(0f, 0f, size, size, Paint().apply { color = BACKGROUND })

        canvas.scale(size, size)
        for (stroke in strokes) {
            val paint = Paint().apply {
                color = stroke.color
                style = PaintingStyle.Stroke
                strokeJoin = StrokeJoin.Round
                strokeCap = StrokeCap.Round
                strokeWidth = stroke.width / size
            }
            canvas.drawPoints(
                pointMode = if (stroke.points.size == 1) PointMode.Points else PointMode.Polygon,
                points = stroke.points,
                paint = paint,
            )
        }
        return image.asAndroidBitmap()
    }

    private fun parseStrokes(body: String): List<Stroke> {
        val array = when (val root = JSONTokener(body).nextValue()) {
            is JSONArray -> root
            is JSONObject -> root.optJSONArray("artifacts") ?: JSONArray()
            else -> JSONArray()
        }
        val strokes = mutableListOf<Stroke>()
        for (i in 0 until array.length()) {
            val obj = array.optJSONObject(i) ?: continue
            if (obj.optString("type") != "stroke") continue
            runCatching { obj.toStroke() }.getOrNull()?.let(strokes::add)
        }
        return strokes
    }

    private fun JSONObject.toStroke(): Stroke {
        val color = Color(getString("color").toLong(16).toInt())
        val width = getDouble("width").toFloat()
        val pointsJson = getJSONArray("points")
        val points = ArrayList<Offset>(pointsJson.length())
        for (j in 0 until pointsJson.length()) {
            val point = pointsJson.getJSONObject(j)
            points.add(Offset(point.getDouble("x").toFloat(), point.getDouble("y").toFloat()))
        }
        return Stroke(color = color, width = width, points = points)
    }

    private data class Stroke(val color: Color, val width: Float, val points: List<Offset>)

    companion object {
        /**
         * Size, in pixels, of the rasterised board. The board is square and drawn
         * in a normalised `0..1` space, so a single dimension is enough.
         */
        private const val CANVAS_SIZE = 1024

        /** Dark surface behind the strokes, matching the in-app board. */
        private val BACKGROUND = Color(0xFF211F26)
    }
}
