package net.kernys.dietai

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

class StreakWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.streak_widget)

            val widgetData = HomeWidgetPlugin.getData(context)
            val streak = widgetData.getInt("streak", 0)

            views.setTextViewText(R.id.streak_count, streak.toString())

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
