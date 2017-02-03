//
//  AppDelegate.swift
//  RDVTabBarControllerSwift
//
//  Created by chenjiang on 01/23/2017.
//  Copyright (c) 2017 chenjiang. All rights reserved.
//

import UIKit
import RDVTabBarControllerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var viewController: UIViewController?

    func setupTabViewController() {
        let firstViewController = RDVFirstViewController(nibName: nil, bundle: nil)
        let firstNavigationController = UINavigationController(rootViewController: firstViewController)

        let secondViewController = RDVSecondViewController(nibName: nil, bundle: nil)
        let secondNavigationController = UINavigationController(rootViewController: secondViewController)

        let thirdViewController = RDVThirdViewController(nibName: nil, bundle: nil)
        let thirdNavigationController = UINavigationController(rootViewController: thirdViewController)

        let tabBarController = RDVTabBarController()
        tabBarController.viewControllers = [firstNavigationController, secondNavigationController, thirdNavigationController]

        self.viewController = tabBarController

        customizeTabBarForController(tabBarController)

        let tabBar = tabBarController.tabBar
        tabBar.translucent = true

        tabBar.backgroundView.backgroundColor = UIColor(red: 245/255.0,
                                                        green: 245/255.0,
                                                        blue: 245/255.0,
                                                        alpha: 0.9)
    }

    func customizeTabBarForController(_ tabBarController: RDVTabBarController) {
        guard let items = tabBarController.tabBar.items else {
            return
        }

        let finishedImage = UIImage(named: "tabbar_selected_background")
        let unfinishedImage = UIImage(named: "tabbar_normal_background")
        let tabBarItemImages = ["first", "second", "third"]


        var index = 0
        for item in items {
            item.setBackgroundSelectedImage(finishedImage, unselectedImage: unfinishedImage)
            let selectedimage = UIImage(named: "\(tabBarItemImages[index])_selected")
            let unselectedimage = UIImage(named: "\(tabBarItemImages[index])_normal")
            item.setFinishedSelectedImage(selectedimage, unselectedImage: unselectedimage)

            index += 1
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.clear

        setupTabViewController()

        window?.rootViewController = self.viewController

        window?.makeKeyAndVisible()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

