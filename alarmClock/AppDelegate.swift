//
//  AppDelegate.swift
//  alarmClock
//
//  Created by tangwei on 16/12/5.
//  Copyright © 2016年 tangwei. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.registerKeyboard()
        self.registerNotification()
        self.init_ui()
        
        return true
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification)
    {
        let alert : UIAlertView = UIAlertView.init(title: "前台通知", message: notification.alertBody, delegate: nil, cancelButtonTitle: "确定")
        alert.show()
    }
    
    func init_ui() -> Void {
        let vc : ViewController = ViewController()
        let nav : UINavigationController = UINavigationController.init(rootViewController: vc)
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent;
        
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
        self.window?.becomeKey()
    }
    
    func registerNotification() -> Void
    {
        if #available(iOS 8.0, *) {
            let uns = UIUserNotificationSettings(types: [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(uns)
        }
    }

    func registerKeyboard() -> Void {
        
        let manager : IQKeyboardManager = IQKeyboardManager.shared()
        manager.isEnabled = true
        manager.shouldResignOnTouchOutside = true
        manager.shouldToolbarUsesTextFieldTintColor = false
        manager.isEnableAutoToolbar = true
    }
}

