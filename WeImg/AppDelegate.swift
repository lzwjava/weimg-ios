//
//  AppDelegate.swift
//  WeImg
//
//  Created by lzw on 16/1/28.
//  Copyright © 2016年 WeImg Inc. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // 全局的外观自定义
        customAppearce()
        
        let isLogined = UserManager.currentUser != nil
        
        if isLogined {
            
//            // 记录启动通知类型
//            if let
//                notification = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as? UILocalNotification,
//                userInfo = notification.userInfo,
//                type = userInfo["type"] as? String {
//                    remoteNotificationType = RemoteNotificationType(rawValue: type)
//            }
            
        } else {
            startShowStory()
        }
        

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func startShowStory() {
        
        let storyboard = UIStoryboard(name: "Show", bundle: nil)
        let rootViewController = storyboard.instantiateViewControllerWithIdentifier("ShowNavigationController") as! UINavigationController
        window?.rootViewController = rootViewController
    }
    
    func startMainStory() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootViewController = storyboard.instantiateViewControllerWithIdentifier("MainTabBarController") as! UITabBarController
        window?.rootViewController = rootViewController
    }
    
    private func customAppearce() {
        
        // Global Tint Color
        
        window?.tintColor = UIColor.yepTintColor()
        window?.tintAdjustmentMode = .Normal
        
        // NavigationBar Item Style
        
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.yepBarButtonColor()], forState: .Normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.yepBarButtonColor().colorWithAlphaComponent(0.3)], forState: .Disabled)
        UIBarButtonItem.appearance().tintColor = UIColor.yepBarButtonColor()
        
        // NavigationBar Title Style
        
        let shadow: NSShadow = {
            let shadow = NSShadow()
            shadow.shadowColor = UIColor.lightGrayColor()
            shadow.shadowOffset = CGSizeMake(0, 0)
            return shadow
        }()
        
        let textAttributes = [
            NSForegroundColorAttributeName: UIColor.yepNavgationBarTitleColor(),
            NSShadowAttributeName: shadow,
            NSFontAttributeName: UIFont.navigationBarTitleFont()
        ]
        
        /*
        let barButtonTextAttributes = [
        NSForegroundColorAttributeName: UIColor.yepTintColor(),
        NSFontAttributeName: UIFont.barButtonFont()
        ]
        */
        
        UINavigationBar.appearance().titleTextAttributes = textAttributes
        UINavigationBar.appearance().barTintColor = UIColor.yepNavigationBarTintColor()
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        //UIBarButtonItem.appearance().setTitleTextAttributes(barButtonTextAttributes, forState: UIControlState.Normal)
        //UINavigationBar.appearance().setBackgroundImage(UIImage(named:"white"), forBarMetrics: .Default)
        //UINavigationBar.appearance().shadowImage = UIImage()
        //UINavigationBar.appearance().translucent = false
        
        // TabBar
        
        //UITabBar.appearance().backgroundImage = UIImage(named:"white")
        //UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().tintColor = UIColor.yepBarButtonColor()
        UITabBar.appearance().barTintColor = UIColor.yepBarTintColor()
        //UITabBar.appearance().translucent = false
    }

}

