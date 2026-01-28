import WidgetKit
import SwiftUI
import ActivityKit

// MARK: - Live Activity Attributes (MUST be named LiveActivitiesAppAttributes)
struct LiveActivitiesAppAttributes: ActivityAttributes, Identifiable {
    public typealias LiveDeliveryData = ContentState
    
    public struct ContentState: Codable, Hashable { }
    
    var id = UUID()
}

extension LiveActivitiesAppAttributes {
    func prefixedKey(_ key: String) -> String {
        return "\(id)_\(key)"
    }
}

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
struct DietAIEntry: TimelineEntry {
    let date: Date
    let data: WidgetData
}

// MARK: - Provider
struct DietAIProvider: TimelineProvider {
    func placeholder(in context: Context) -> DietAIEntry {
        DietAIEntry(date: Date(), data: WidgetData(
            caloriesLeft: 1054,
            caloriesGoal: 2000,
            caloriesConsumed: 946,
            streak: 2,
            protein: 45.0,
            carbs: 120.0,
            fat: 30.0
        ))
    }

    func getSnapshot(in context: Context, completion: @escaping (DietAIEntry) -> ()) {
        let entry = DietAIEntry(date: Date(), data: loadWidgetData())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<DietAIEntry>) -> ()) {
        let currentDate = Date()
        let entry = DietAIEntry(date: currentDate, data: loadWidgetData())

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
    var entry: DietAIEntry
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

// MARK: - Small Widget View
struct SmallCaloriesView: View {
    var entry: DietAIEntry

    var progress: Double {
        guard entry.data.caloriesGoal > 0 else { return 0 }
        return Double(entry.data.caloriesConsumed) / Double(entry.data.caloriesGoal)
    }

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "flame.fill")
                    .foregroundColor(.orange)
                    .font(.system(size: 12))
                Text("Diet AI")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.secondary)
                Spacer()
            }

            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 8)

                Circle()
                    .trim(from: 0, to: min(progress, 1.0))
                    .stroke(
                        progress > 1.0 ? Color.red : Color.green,
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))

                VStack(spacing: 2) {
                    Text("\(entry.data.caloriesLeft)")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.primary)
                    Text("left")
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 80, height: 80)
        }
        .padding()
        .containerBackground(for: .widget) {
            Color(.systemBackground)
        }
    }
}

// MARK: - Medium Widget View
struct MediumCaloriesView: View {
    var entry: DietAIEntry

    var progress: Double {
        guard entry.data.caloriesGoal > 0 else { return 0 }
        return Double(entry.data.caloriesConsumed) / Double(entry.data.caloriesGoal)
    }

    var body: some View {
        HStack(spacing: 16) {
            // Left - Ring
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 10)

                Circle()
                    .trim(from: 0, to: min(progress, 1.0))
                    .stroke(
                        progress > 1.0 ? Color.red : Color.green,
                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))

                VStack(spacing: 2) {
                    Text("\(entry.data.caloriesLeft)")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.primary)
                    Text("kcal left")
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 100, height: 100)

            // Right - Macros
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                        .font(.system(size: 14))
                    Text("Diet AI")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.secondary)
                }

                MacroRow(label: "Protein", value: entry.data.protein, color: .blue)
                MacroRow(label: "Carbs", value: entry.data.carbs, color: .orange)
                MacroRow(label: "Fat", value: entry.data.fat, color: .purple)
            }

            Spacer()
        }
        .padding()
        .containerBackground(for: .widget) {
            Color(.systemBackground)
        }
    }
}

// MARK: - Macro Row
struct MacroRow: View {
    let label: String
    let value: Double
    let color: Color

    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(.secondary)
            Spacer()
            Text("\(Int(value))g")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.primary)
        }
    }
}

// MARK: - Streak Widget
struct StreakWidgetView: View {
    var entry: DietAIEntry
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "flame.fill")
                    .foregroundColor(.orange)
                    .font(.system(size: 12))
                Text("Streak")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.secondary)
                Spacer()
            }
            
            Spacer()
            
            Text("\(entry.data.streak)")
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(.orange)
            
            Text("days")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .padding()
        .containerBackground(for: .widget) {
            Color(.systemBackground)
        }
    }
}

// MARK: - Calories Widget
struct DietAIWidget: Widget {
    let kind: String = "DietAIWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: DietAIProvider()) { entry in
            CaloriesWidgetView(entry: entry)
        }
        .configurationDisplayName("Calories")
        .description("Track your daily calorie intake")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// MARK: - Streak Widget
struct StreakWidget: Widget {
    let kind: String = "StreakWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: DietAIProvider()) { entry in
            StreakWidgetView(entry: entry)
        }
        .configurationDisplayName("Streak")
        .description("Track your logging streak")
        .supportedFamilies([.systemSmall])
    }
}

// MARK: - Live Activity Widget
struct DietAILiveActivity: Widget {
    // Create shared default with custom group
    let sharedDefault = UserDefaults(suiteName: "group.dietai")!
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveActivitiesAppAttributes.self) { context in
            // Lock screen / banner UI
            LockScreenLiveActivityView(context: context, sharedDefault: sharedDefault)
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI
                DynamicIslandExpandedRegion(.leading) {
                    // Food icon on left
                    Image(systemName: "fork.knife")
                        .foregroundColor(.green)
                        .font(.system(size: 20))
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    // Calories with flame icon on right
                    let caloriesLeft = sharedDefault.integer(forKey: context.attributes.prefixedKey("caloriesLeft"))
                    HStack(spacing: 4) {
                        Text("🔥")
                            .font(.system(size: 14))
                        Text("\(caloriesLeft)")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                
                DynamicIslandExpandedRegion(.center) {
                    Text("Diet AI")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    let proteinLeft = sharedDefault.integer(forKey: context.attributes.prefixedKey("proteinLeft"))
                    let carbsLeft = sharedDefault.integer(forKey: context.attributes.prefixedKey("carbsLeft"))
                    let fatLeft = sharedDefault.integer(forKey: context.attributes.prefixedKey("fatLeft"))
                    
                    HStack(spacing: 16) {
                        LiveActivityMacroItem(label: "Protein", value: proteinLeft, color: .blue)
                        LiveActivityMacroItem(label: "Carbs", value: carbsLeft, color: .orange)
                        LiveActivityMacroItem(label: "Fat", value: fatLeft, color: .purple)
                    }
                    .padding(.top, 8)
                }
            } compactLeading: {
                // Compact leading (left side of pill) - Food icon
                Image(systemName: "fork.knife")
                    .foregroundColor(.green)
                    .font(.system(size: 14))
            } compactTrailing: {
                // Compact trailing (right side of pill) - Flame + calories
                let caloriesLeft = sharedDefault.integer(forKey: context.attributes.prefixedKey("caloriesLeft"))
                HStack(spacing: 2) {
                    Text("🔥")
                        .font(.system(size: 10))
                    Text("\(caloriesLeft)")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                }
            } minimal: {
                // Minimal (just icon when another activity is showing)
                Image(systemName: "fork.knife")
                    .foregroundColor(.green)
                    .font(.system(size: 14))
            }
        }
    }
}

// MARK: - Lock Screen Live Activity View
struct LockScreenLiveActivityView: View {
    let context: ActivityViewContext<LiveActivitiesAppAttributes>
    let sharedDefault: UserDefaults
    
    var caloriesLeft: Int {
        sharedDefault.integer(forKey: context.attributes.prefixedKey("caloriesLeft"))
    }
    
    var caloriesGoal: Int {
        sharedDefault.integer(forKey: context.attributes.prefixedKey("caloriesGoal"))
    }
    
    var caloriesConsumed: Int {
        sharedDefault.integer(forKey: context.attributes.prefixedKey("caloriesConsumed"))
    }
    
    var proteinLeft: Int {
        sharedDefault.integer(forKey: context.attributes.prefixedKey("proteinLeft"))
    }
    
    var carbsLeft: Int {
        sharedDefault.integer(forKey: context.attributes.prefixedKey("carbsLeft"))
    }
    
    var fatLeft: Int {
        sharedDefault.integer(forKey: context.attributes.prefixedKey("fatLeft"))
    }
    
    var progress: Double {
        guard caloriesGoal > 0 else { return 0 }
        return Double(caloriesConsumed) / Double(caloriesGoal)
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // Left - Calories info
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                        .font(.system(size: 14))
                    Text("Diet AI")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.secondary)
                }
                
                Text("\(caloriesLeft)")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.primary)
                
                Text("Calories left")
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Right - Macros
            VStack(alignment: .trailing, spacing: 6) {
                LiveActivityMacroRow(label: "Protein", value: proteinLeft, color: .blue)
                LiveActivityMacroRow(label: "Carbs", value: carbsLeft, color: .orange)
                LiveActivityMacroRow(label: "Fat", value: fatLeft, color: .purple)
            }
            
            // Progress Ring
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 6)
                
                Circle()
                    .trim(from: 0, to: min(progress, 1.0))
                    .stroke(
                        progress > 1.0 ? Color.red : Color.green,
                        style: StrokeStyle(lineWidth: 6, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                
                Text("\(Int(progress * 100))%")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.primary)
            }
            .frame(width: 50, height: 50)
        }
        .padding(16)
        .activityBackgroundTint(Color.black.opacity(0.8))
    }
}

// MARK: - Live Activity Macro Row
struct LiveActivityMacroRow: View {
    let label: String
    let value: Int
    let color: Color
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(color)
                .frame(width: 6, height: 6)
            Text("\(label): \(value)g")
                .font(.system(size: 11))
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Live Activity Macro Item (for Dynamic Island expanded)
struct LiveActivityMacroItem: View {
    let label: String
    let value: Int
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            Text("\(value)g")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.white)
            Text(label)
                .font(.system(size: 9))
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Widget Bundle
@main
struct DietAIWidgetBundle: WidgetBundle {
    var body: some Widget {
        DietAIWidget()
        StreakWidget()
        DietAILiveActivity()
    }
}

// MARK: - Preview
#Preview(as: .systemSmall) {
    DietAIWidget()
} timeline: {
    DietAIEntry(date: .now, data: WidgetData(
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
    DietAIWidget()
} timeline: {
    DietAIEntry(date: .now, data: WidgetData(
        caloriesLeft: 1054,
        caloriesGoal: 2000,
        caloriesConsumed: 946,
        streak: 2,
        protein: 45.0,
        carbs: 120.0,
        fat: 30.0
    ))
}
