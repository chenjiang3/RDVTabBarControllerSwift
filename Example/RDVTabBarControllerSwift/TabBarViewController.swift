//
//  TabBarViewController.swift
//  RDVTabBarControllerSwift
//
//  Created by chenjiang on 2017/1/23.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import RDVTabBarControllerSwift

func OnePxHeight() -> CGFloat {
    return CGFloat(1.0) / UIScreen.main.scale
}

extension UIView {
    public var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            self.frame.size.width = newValue
        }
    }

    public var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            self.frame.size.height = newValue
        }
    }
}

extension UIColor {
    public convenience init(rgb: Int) {
        self.init(rgb: rgb, alpha: 1.0)
    }

    public convenience init(rgb: Int, alpha: CGFloat) {
        let r = CGFloat(CGFloat((rgb & 0xFF0000) >> 16) / 255.0)
        let g = CGFloat(CGFloat((rgb & 0xFF00) >> 8) / 255.0)
        let b = CGFloat(CGFloat((rgb & 0xFF)) / 255.0)
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}

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

        let tabBarItemImages = ["tabMe", "tabMe", "tabMe", "tabMe"]
        let tabbarTitles = ["vc1", "vc2", "vc3", "vc4"]

        guard let items = self.tabBar.items else {
            return
        }

        let topBorder = UIView()
        self.tabBar.backgroundView.addSubview(topBorder)
        topBorder.backgroundColor = UIColor(rgb: 0xdcdcdc)
        topBorder.width = self.tabBar.width
        topBorder.height = OnePxHeight()
        topBorder.autoresizingMask = [.flexibleBottomMargin, .flexibleWidth]
        self.tabBar.backgroundView.backgroundColor = UIColor.clear


        var i = 0
        for item in items {
            item.title = tabbarTitles[i]
            i += 1
        }
    }

}





















