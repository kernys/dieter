import Foundation
import ActivityKit

// Shared Live Activity Attributes
// IMPORTANT: This file must be added to BOTH Runner and CalAiWidgetExtension targets
struct CalAiActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var caloriesLeft: Int
        var caloriesGoal: Int
        var caloriesConsumed: Int
        var proteinLeft: Int
        var carbsLeft: Int
        var fatLeft: Int
    }
    
    var activityName: String
}
