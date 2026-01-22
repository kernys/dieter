package com.calai.cal_ai

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

class CaloriesWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.calories_widget)

            val widgetData = HomeWidgetPlugin.getData(context)
            val caloriesLeft = widgetData.getInt("calories_left", 0)
            val caloriesGoal = widgetData.getInt("calories_goal", 2000)
            val caloriesConsumed = widgetData.getInt("calories_consumed", 0)

            views.setTextViewText(R.id.calories_left, caloriesLeft.toString())

            // Calculate progress percentage
            val progress = if (caloriesGoal > 0) {
                ((caloriesConsumed.toFloat() / caloriesGoal.toFloat()) * 100).toInt()
            } else {
                0
            }
            views.setProgressBar(R.id.calories_progress, 100, progress.coerceIn(0, 100), false)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
