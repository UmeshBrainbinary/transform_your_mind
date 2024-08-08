import UIKit
import Flutter
import UserNotifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let alarmChannel = FlutterMethodChannel(name: "com.example.alarm", binaryMessenger: controller.binaryMessenger)

    alarmChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
      if call.method == "setAlarm" {
        if let args = call.arguments as? [String: Any],
           let dateTime = args["dateTime"] as? String {
          self.setAlarm(dateTime: dateTime)
          result("Alarm set for \(dateTime)")
        } else {
          result(FlutterError(code: "INVALID_ARGUMENT", message: "Date time is required", details: nil))
        }
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
      if let error = error {
        print("Error requesting notification authorization: \(error)")
      }
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func setAlarm(dateTime: String) {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    if let date = formatter.date(from: dateTime) {
      let notificationContent = UNMutableNotificationContent()
      notificationContent.title = "Alarm"
      notificationContent.body = "It's time!"

      let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date), repeats: false)

      let request = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: trigger)

      UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
          print("Error scheduling alarm: \(error)")
        } else {
          print("Alarm scheduled for \(dateTime)")
        }
      }
    }
  }
}
