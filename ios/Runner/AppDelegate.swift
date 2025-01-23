import UIKit
import Flutter
import GoogleMaps
import flutter_local_notifications
import FirebaseCore

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      FirebaseApp.configure()
    GMSServices.provideAPIKey("AIzaSyA1KtWkaT4h8q_ph8m71mqVFLdcicwEVpA")
      GeneratedPluginRegistrant.register(with: self)
      if #available(iOS 10.0, *) {
          UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
      }

     FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
         GeneratedPluginRegistrant.register(with: registry)
        }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
