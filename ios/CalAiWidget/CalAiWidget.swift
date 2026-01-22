import WidgetKit
import SwiftUI

// MARK: - Data Models
struct WidgetData: Codable {
    let caloriesLeft: Int
    let caloriesGoal: Int
    let caloriesConsumed: Int
    let streak: Int
    let protein: Double
    let carbs: Double
    let fat: Double
}

// MARK: - Timeline Entry
struct CalAiEntry: TimelineEntry {
    let date: Date
    let data: WidgetData
}

// MARK: - Provider
struct CalAiProvider: TimelineProvider {
    func placeholder(in context: Context) -> CalAiEntry {
        CalAiEntry(date: Date(), data: WidgetData(
            caloriesLeft: 1054,
            caloriesGoal: 2000,
            caloriesConsumed: 946,
            streak: 2,
            protein: 45.0,
            carbs: 120.0,
            fat: 30.0
        ))
    }

    func getSnapshot(in context: Context, completion: @escaping (CalAiEntry) -> ()) {
        let entry = CalAiEntry(date: Date(), data: loadWidgetData())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<CalAiEntry>) -> ()) {
        let currentDate = Date()
        let entry = CalAiEntry(date: currentDate, data: loadWidgetData())

        // Update every 30 minutes
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 30, to: currentDate)!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }

    private func loadWidgetData() -> WidgetData {
        let userDefaults = UserDefaults(suiteName: "group.com.calai.calAi")

        if let jsonString = userDefaults?.string(forKey: "widget_data"),
           let data = jsonString.data(using: .utf8),
           let widgetData = try? JSONDecoder().decode(WidgetData.self, from: data) {
            return widgetData
        }

        // Default values
        return WidgetData(
            caloriesLeft: 0,
            caloriesGoal: 2000,
            caloriesConsumed: 0,
            streak: 0,
            protein: 0,
            carbs: 0,
            fat: 0
        )
    }
}

// MARK: - Calories Widget View
struct CaloriesWidgetView: View {
    var entry: CalAiEntry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            SmallCaloriesView(entry: entry)
        case .systemMedium:
            MediumCaloriesView(entry: entry)
        default:
            SmallCaloriesView(entry: entry)
        }
    }
}

struct SmallCaloriesView: View {
    var entry: CalAiEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "flame.fill")
                    .foregroundColor(.orange)
                    .font(.system(size: 16))
                Spacer()
            }

            Spacer()

            Text("\(entry.data.caloriesLeft)")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.primary)

            Text("Calories left")
                .font(.system(size: 12))
                .foregroundColor(.secondary)

            Spacer()

            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 6)

                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.green)
                        .frame(width: progressWidth(geometry.size.width), height: 6)
                }
            }
            .frame(height: 6)
        }
        .padding(16)
        .containerBackground(.fill.tertiary, for: .widget)
    }

    private func progressWidth(_ totalWidth: CGFloat) -> CGFloat {
        let progress = Double(entry.data.caloriesConsumed) / Double(entry.data.caloriesGoal)
        return min(totalWidth * CGFloat(progress), totalWidth)
    }
}

struct MediumCaloriesView: View {
    var entry: CalAiEntry

    var body: some View {
        HStack(spacing: 16) {
            // Left side - Calories
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                        .font(.system(size: 16))
                    Text("Calories")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                }

                Text("\(entry.data.caloriesLeft)")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.primary)

                Text("left of \(entry.data.caloriesGoal)")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)

                // Progress bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 6)

                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.green)
                            .frame(width: progressWidth(geometry.size.width), height: 6)
                    }
                }
                .frame(height: 6)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            // Right side - Macros
            VStack(alignment: .leading, spacing: 8) {
                MacroRow(name: "Protein", value: entry.data.protein, color: .blue)
                MacroRow(name: "Carbs", value: entry.data.carbs, color: .orange)
                MacroRow(name: "Fat", value: entry.data.fat, color: .purple)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16)
        .containerBackground(.fill.tertiary, for: .widget)
    }

    private func progressWidth(_ totalWidth: CGFloat) -> CGFloat {
        let progress = Double(entry.data.caloriesConsumed) / Double(entry.data.caloriesGoal)
        return min(totalWidth * CGFloat(progress), totalWidth)
    }
}

struct MacroRow: View {
    let name: String
    let value: Double
    let color: Color

    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)

            VStack(alignment: .leading, spacing: 0) {
                Text(name)
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                Text("\(Int(value))g")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)
            }
        }
    }
}

// MARK: - Streak Widget View
struct StreakWidgetView: View {
    var entry: CalAiEntry

    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Spacer()

            HStack(spacing: 4) {
                Image(systemName: "flame.fill")
                    .foregroundColor(.orange)
                    .font(.system(size: 32))

                Text("\(entry.data.streak)")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.primary)
            }

            Text("Day Streak")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

// MARK: - Calories Widget
struct CalAiWidget: Widget {
    let kind: String = "CalAiWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CalAiProvider()) { entry in
            CaloriesWidgetView(entry: entry)
        }
        .configurationDisplayName("Calories")
        .description("Track your remaining calories for today.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// MARK: - Streak Widget
struct StreakWidget: Widget {
    let kind: String = "StreakWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CalAiProvider()) { entry in
            StreakWidgetView(entry: entry)
        }
        .configurationDisplayName("Streak")
        .description("Track your logging streak.")
        .supportedFamilies([.systemSmall])
    }
}

// MARK: - Widget Bundle
@main
struct CalAiWidgetBundle: WidgetBundle {
    var body: some Widget {
        CalAiWidget()
        StreakWidget()
    }
}

// MARK: - Preview
#Preview(as: .systemSmall) {
    CalAiWidget()
} timeline: {
    CalAiEntry(date: .now, data: WidgetData(
        caloriesLeft: 1054,
        caloriesGoal: 2000,
        caloriesConsumed: 946,
        streak: 2,
        protein: 45.0,
        carbs: 120.0,
        fat: 30.0
    ))
}

#Preview(as: .systemMedium) {
    CalAiWidget()
} timeline: {
    CalAiEntry(date: .now, data: WidgetData(
        caloriesLeft: 1054,
        caloriesGoal: 2000,
        caloriesConsumed: 946,
        streak: 2,
        protein: 45.0,
        carbs: 120.0,
        fat: 30.0
    ))
}
