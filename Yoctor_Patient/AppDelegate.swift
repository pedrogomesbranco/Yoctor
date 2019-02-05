//
//  AppDelegate.swift
//  Yoctor_Patient
//
//  Created by Lucas Ferraço on 10/07/17.
//  Copyright © 2017 Yoctor. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

public let success = "success"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
        
        // UI Customization
  
        UINavigationBar.appearance().backgroundColor = UIColor.white
        UIApplication.shared.statusBarView?.backgroundColor = .white
		
        // Firebase initialization
		FirebaseApp.configure()
        
        // Notification initialization
        let notificationSettings = UIUserNotificationSettings(types: UIUserNotificationType.alert, categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
        
        //Verify Notification Authorization
        registerForPushNotifications()
        
		return true
	}

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        // Notification initialization
        let notificationSettings = UIUserNotificationSettings(types: UIUserNotificationType.alert, categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
        
        application.beginBackgroundTask(withName: "showNotification1", expirationHandler: nil)
        application.beginBackgroundTask(withName: "showNotification2", expirationHandler: nil)
        
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}
    
    /*func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Sound, .Alert, .Badge], categories: nil))
        
        application.beginBackgroundTask(withName: "showNotification1", expirationHandler: nil)
        application.beginBackgroundTask(withName: "showNotification2", expirationHandler: nil)
        
        return true
    }*/
    
    // Check notification status
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        // Device token
        let token = tokenParts.joined()
        print("Device Token: \(token)")
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
			guard settings.authorizationStatus == .authorized else { return }
        }
		
		DispatchQueue.main.async {
			UIApplication.shared.registerForRemoteNotifications()
		}
    }

}

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}
