//
//  TabBarViewController.swift
//  RDVTabBarControllerSwift
//
//  Created by chenjiang on 2017/1/23.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import RDVTabBarControllerSwift

fileprivate let TABBAR_HEIGHT: CGFloat = 50.0

class TabBarViewController: RDVTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewControllers()


    }

    func setupViewControllers() {
        let vc1 = UIViewController()
        let nav1 = UINavigationController(rootViewController: vc1)

        let vc2 = UIViewController()
        let nav2 = UINavigationController(rootViewController: vc2)

        let vc3 = UIViewController()
        let nav3 = UINavigationController(rootViewController: vc3)

        let vc4 = UIViewController()
        let nav4 = UINavigationController(rootViewController: vc4)

        self.viewControllers = [nav1, nav2, nav3, nav4]

        self.customTabBar()

        self.selectedIndex = 0
    }

    func customTabBar() {
        self.tabBar.setHeight(TABBAR_HEIGHT)

        let tabbarTitles = ["vc1", "vc2", "vc3", "vc4"]

        guard let items = self.tabBar.items else {
            return
        }

        var i = 0
        for item in items {
            item.title = tabbarTitles[i]
            i += 1
        }
    }

}





















