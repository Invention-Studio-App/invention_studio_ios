//
//  AppDelegate.swift
//  invention-studio-ios
//
//  Created by Nick's Creative Studio on 11/13/17.
//  Copyright © 2017 Invention Studio at Georgia Tech. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseMessaging
import FirebaseInstanceID
import UserNotifications
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {


        /*
         * Setup Firebase Notifications
         */
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .badge, .sound],
            completionHandler: {_, _ in })

        application.registerForRemoteNotifications()
        FirebaseApp.configure()

        /*
         * Apply color theme globally
         */
        Theme.apply()

        /*
         * Set Main Window Based on User Login
         */
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        var initialViewController: UIViewController
        let loginSession = UserDefaults.standard.double(forKey: "LoginSession") //0 if DNE
        //TODO: Use server time
        let timeStamp = NSDate().timeIntervalSince1970

        let shouldLogin = true //For debugging purposes - To force login, set to false. For normal operation, set to true

        //Check that the threshold for staying logged in has not passed
        //If the user has never logged in before, this will automatically fail since loginSession == 0
        if timeStamp < loginSession && shouldLogin {
            initialViewController = storyboard.instantiateViewController(withIdentifier: "TabBarController")
            UserDefaults.standard.set(true, forKey: "LoggedIn")
            let username = UserDefaults.standard.string(forKey: "Username")
            Messaging.messaging().subscribe(toTopic: username!)
        } else {
            if let username = UserDefaults.standard.string(forKey: "Username") {
                Messaging.messaging().unsubscribe(fromTopic: username)
            }
            UserDefaults.standard.set(false, forKey: "LoggedIn")
            UserDefaults.standard.set(0, forKey: "DepartmentId")
            UserDefaults.standard.set(nil, forKey: "Name")
            UserDefaults.standard.set(nil, forKey: "Username")
            UserDefaults.standard.set(nil, forKey: "UserKey")
            UserDefaults.standard.set(0, forKey:"LoginSession")

            initialViewController = storyboard.instantiateViewController(withIdentifier: "LandingViewController")
        }
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()

        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])

    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
            let tabBarController = self.window?.rootViewController as? UITabBarController
            tabBarController?.selectedIndex = 2
    }

    
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "invention_studio_ios")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

