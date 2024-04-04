package com.example.reminder_app

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import android.graphics.BitmapFactory
import android.net.Uri
import android.view.View

/**
 * Implementation of App Widget functionality.
 */
class ReminderAppWidget : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        // There may be multiple widgets active, so update all of them
        for (appWidgetId in appWidgetIds) {
            // Get reference to SharedPreferences
            val widgetData = HomeWidgetPlugin.getData(context)
            val views = RemoteViews(context.packageName, R.layout.reminder_app_widget).apply {
                // Open App on App Widget Click
                val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java)
                setOnClickPendingIntent(R.id.widget_container, pendingIntent)

                // Display Title
                val title = widgetData.getString("title", null)
                setTextViewText(R.id.title, title ?: "No title set")

                // Display Description
                val description = widgetData.getString("description", null)
                setTextViewText(R.id.description, description ?: "No description set")

                // Display images generated using renderFlutterWidget
                val image = widgetData.getString("dashIcon", null)
                if (image != null) {
                    setImageViewBitmap(R.id.dashIcon, BitmapFactory.decodeFile(image))
                    setViewVisibility(R.id.dashIcon, View.VISIBLE)
                } else {
                    setViewVisibility(R.id.dashIcon, View.GONE)
                }

                // Detect App opened via Click inside Flutter
//                val pendingIntentWithData = HomeWidgetLaunchIntent.getActivity(
//                    context,
//                    MainActivity::class.java,
//                    Uri.parse("homeWidgetExample://message?message=$description"))
//                setOnClickPendingIntent(R.id.description, pendingIntentWithData)

            }

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }

    override fun onEnabled(context: Context) {
        // Enter relevant functionality for when the first widget is created
    }

    override fun onDisabled(context: Context) {
        // Enter relevant functionality for when the last widget is disabled
    }
}

//internal fun updateAppWidget(
//    context: Context,
//    appWidgetManager: AppWidgetManager,
//    appWidgetId: Int
//) {
//    val widgetText = context.getString(R.string.appwidget_text)
//    // Construct the RemoteViews object
//    val views = RemoteViews(context.packageName, R.layout.reminder_app_widget)
//    views.setTextViewText(R.id.title, widgetText)
//
//    // Instruct the widget manager to update the widget
//    appWidgetManager.updateAppWidget(appWidgetId, views)
//}