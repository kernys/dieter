import WidgetKit
import SwiftUI
import ActivityKit

// CalAiActivityAttributes is defined in Shared/LiveActivityAttributes.swift
// That file must be added to BOTH Runner and CalAiWidgetExtension targets

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
        let userDefaults = UserDefaults(suiteName: "group.dietai")

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

            // Right side - Macros remaining
            VStack(alignment: .leading, spacing: 8) {
                MacroRow(name: "Protein left", value: entry.data.protein, color: .blue)
                MacroRow(name: "Carbs left", value: entry.data.carbs, color: .orange)
                MacroRow(name: "Fat left", value: entry.data.fat, color: .purple)
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

// MARK: - Live Activity Widget
struct CalAiLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: CalAiActivityAttributes.self) { context in
            // Lock screen / banner UI
            LockScreenLiveActivityView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI
                DynamicIslandExpandedRegion(.leading) {
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .foregroundColor(.orange)
                            .font(.system(size: 16))
                        Text("\(context.state.caloriesLeft)")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    Text("left")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
                
                DynamicIslandExpandedRegion(.center) {
                    Text("Cal AI")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    HStack(spacing: 16) {
                        MacroItem(label: "Protein", value: context.state.proteinLeft, color: .blue)
                        MacroItem(label: "Carbs", value: context.state.carbsLeft, color: .orange)
                        MacroItem(label: "Fat", value: context.state.fatLeft, color: .purple)
                    }
                    .padding(.top, 8)
                }
            } compactLeading: {
                // Compact leading (left side of pill)
                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                        .font(.system(size: 12))
                    Text("\(context.state.caloriesLeft)")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                }
            } compactTrailing: {
                // Compact trailing (right side of pill)
                Text("kcal")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            } minimal: {
                // Minimal (just icon when another activity is showing)
                Image(systemName: "flame.fill")
                    .foregroundColor(.orange)
                    .font(.system(size: 14))
            }
        }
    }
}

// MARK: - Lock Screen Live Activity View
struct LockScreenLiveActivityView: View {
    let context: ActivityViewContext<CalAiActivityAttributes>
    
    var progress: Double {
        guard context.state.caloriesGoal > 0 else { return 0 }
        return Double(context.state.caloriesConsumed) / Double(context.state.caloriesGoal)
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // Left - Calories info
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                        .font(.system(size: 14))
                    Text("Cal AI")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.secondary)
                }
                
                Text("\(context.state.caloriesLeft)")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.primary)
                
                Text("Calories left")
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Middle - Macros
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 4) {
                    Circle().fill(.blue).frame(width: 6, height: 6)
                    Text("\(context.state.proteinLeft)g")
                        .font(.system(size: 12, weight: .medium))
                    Text("Protein left")
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                }
                HStack(spacing: 4) {
                    Circle().fill(.orange).frame(width: 6, height: 6)
                    Text("\(context.state.carbsLeft)g")
                        .font(.system(size: 12, weight: .medium))
                    Text("Carbs left")
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                }
                HStack(spacing: 4) {
                    Circle().fill(.purple).frame(width: 6, height: 6)
                    Text("\(context.state.fatLeft)g")
                        .font(.system(size: 12, weight: .medium))
                    Text("Fats left")
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                }
            }
            
            // Right - Circular progress
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 4)
                    .frame(width: 50, height: 50)
                
                Circle()
                    .trim(from: 0, to: min(progress, 1.0))
                    .stroke(progressColor, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .frame(width: 50, height: 50)
                
                Image(systemName: "flame.fill")
                    .foregroundColor(progressColor)
                    .font(.system(size: 18))
            }
        }
        .padding(16)
        .activityBackgroundTint(.black.opacity(0.6))
    }
    
    var progressColor: Color {
        if progress > 1.0 {
            return .red
        } else if progress >= 0.8 {
            return .yellow
        } else {
            return .green
        }
    }
}

// MARK: - Macro Item for Dynamic Island
struct MacroItem: View {
    let label: String
    let value: Int
    let color: Color
    
    var body: some View {
        VStack(spacing: 2) {
            HStack(spacing: 4) {
                Circle().fill(color).frame(width: 6, height: 6)
                Text("\(value)g")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white)
            }
            Text(label)
                .font(.system(size: 9))
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Widget Bundle
@main
struct CalAiWidgetBundle: WidgetBundle {
    var body: some Widget {
        CalAiWidget()
        StreakWidget()
        CalAiLiveActivity()
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
