import Flutter
import UIKit
import ActivityKit
import flutter_local_notifications

// Live Activity Attributes - must match CalAiWidget
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

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var currentActivity: Any? = nil
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Required for flutter_local_notifications
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
      GeneratedPluginRegistrant.register(with: registry)
    }
    
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    }
    
    // Setup Live Activity method channel
    let controller = window?.rootViewController as! FlutterViewController
    let liveActivityChannel = FlutterMethodChannel(
      name: "net.kernys.dietai/live_activity",
      binaryMessenger: controller.binaryMessenger
    )
    
    liveActivityChannel.setMethodCallHandler { [weak self] (call, result) in
      self?.handleLiveActivityMethod(call: call, result: result)
    }
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  private func handleLiveActivityMethod(call: FlutterMethodCall, result: @escaping FlutterResult) {
    if #available(iOS 16.2, *) {
      switch call.method {
      case "checkSupport":
        result(ActivityAuthorizationInfo().areActivitiesEnabled)
        
      case "startActivity":
        guard let args = call.arguments as? [String: Any] else {
          result(FlutterError(code: "INVALID_ARGS", message: "Invalid arguments", details: nil))
          return
        }
        
        startLiveActivity(args: args, result: result)
        
      case "updateActivity":
        guard let args = call.arguments as? [String: Any] else {
          result(FlutterError(code: "INVALID_ARGS", message: "Invalid arguments", details: nil))
          return
        }
        
        updateLiveActivity(args: args, result: result)
        
      case "endActivity":
        endLiveActivity(result: result)
        
      default:
        result(FlutterMethodNotImplemented)
      }
    } else {
      result(FlutterError(code: "UNSUPPORTED", message: "Live Activities require iOS 16.2+", details: nil))
    }
  }
  
  @available(iOS 16.2, *)
  private func startLiveActivity(args: [String: Any], result: @escaping FlutterResult) {
    // End any existing activity first
    endAllActivities()
    
    let caloriesLeft = args["caloriesLeft"] as? Int ?? 0
    let caloriesGoal = args["caloriesGoal"] as? Int ?? 2000
    let caloriesConsumed = args["caloriesConsumed"] as? Int ?? 0
    let proteinLeft = args["proteinLeft"] as? Int ?? 0
    let carbsLeft = args["carbsLeft"] as? Int ?? 0
    let fatLeft = args["fatLeft"] as? Int ?? 0
    
    let attributes = CalAiActivityAttributes(activityName: "Cal AI")
    let contentState = CalAiActivityAttributes.ContentState(
      caloriesLeft: caloriesLeft,
      caloriesGoal: caloriesGoal,
      caloriesConsumed: caloriesConsumed,
      proteinLeft: proteinLeft,
      carbsLeft: carbsLeft,
      fatLeft: fatLeft
    )
    
    let activityContent = ActivityContent(state: contentState, staleDate: nil)
    
    do {
      let activity = try Activity<CalAiActivityAttributes>.request(
        attributes: attributes,
        content: activityContent,
        pushType: nil
      )
      currentActivity = activity
      result(activity.id)
    } catch {
      result(FlutterError(code: "START_ERROR", message: error.localizedDescription, details: nil))
    }
  }
  
  @available(iOS 16.2, *)
  private func updateLiveActivity(args: [String: Any], result: @escaping FlutterResult) {
    guard let activity = currentActivity as? Activity<CalAiActivityAttributes> else {
      result(FlutterError(code: "NO_ACTIVITY", message: "No active Live Activity", details: nil))
      return
    }
    
    let caloriesLeft = args["caloriesLeft"] as? Int ?? 0
    let caloriesGoal = args["caloriesGoal"] as? Int ?? 2000
    let caloriesConsumed = args["caloriesConsumed"] as? Int ?? 0
    let proteinLeft = args["proteinLeft"] as? Int ?? 0
    let carbsLeft = args["carbsLeft"] as? Int ?? 0
    let fatLeft = args["fatLeft"] as? Int ?? 0
    
    let contentState = CalAiActivityAttributes.ContentState(
      caloriesLeft: caloriesLeft,
      caloriesGoal: caloriesGoal,
      caloriesConsumed: caloriesConsumed,
      proteinLeft: proteinLeft,
      carbsLeft: carbsLeft,
      fatLeft: fatLeft
    )
    
    Task {
      await activity.update(using: contentState)
      result(true)
    }
  }
  
  @available(iOS 16.2, *)
  private func endLiveActivity(result: @escaping FlutterResult) {
    guard let activity = currentActivity as? Activity<CalAiActivityAttributes> else {
      result(true) // Already ended
      return
    }
    
    Task {
      await activity.end(nil, dismissalPolicy: .immediate)
      currentActivity = nil
      result(true)
    }
  }
  
  @available(iOS 16.2, *)
  private func endAllActivities() {
    Task {
      for activity in Activity<CalAiActivityAttributes>.activities {
        await activity.end(nil, dismissalPolicy: .immediate)
      }
      currentActivity = nil
    }
  }
}
