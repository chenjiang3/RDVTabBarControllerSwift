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

class TabBarViewController: RDVTabBarController, RDVTabBarControllerDelegate {

    var vc4: UINavigationController?

    // MARK: - RDVTabBarControllerDelegate
    func tabBarController(_ tabBarController: RDVTabBarController, didSelectViewController viewController: UIViewController) {
        print("selected viewcontroller \(viewController)")
    }

    func tabBarController(_ tabBarController: RDVTabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        if let vc4 = self.vc4, vc4 == viewController {
            return false
        }
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewControllers()
    }

    func setupViewControllers() {
        let vc1 = BaseViewController()
        vc1.title = "vc1"
        let nav1 = UINavigationController(rootViewController: vc1)

        let vc2 = BaseViewController()
        vc2.title = "vc2"
        let nav2 = UINavigationController(rootViewController: vc2)

        let vc3 = BaseViewController()
        vc3.title = "vc3"
        let nav3 = UINavigationController(rootViewController: vc3)

        let vc4 = BaseViewController()
        vc4.title = "vc4"
        let nav4 = UINavigationController(rootViewController: vc4)

        self.vc4 = nav4

        self.viewControllers = [nav1, nav2, nav3, nav4]

        self.customTabBar()

        self.selectedIndex = 0

        self.delegate = self
    }

    func customTabBar() {
        self.tabBar.setHeight(TABBAR_HEIGHT)

        let tabBarItemImages = ["tabMe", "tabMe", "tabMe", "tabMe"]
        let tabbarTitles = ["微信", "通讯录", "发现", "我"]

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

        let selectedTabColor = UIColor(rgb: 0x2e72db)
        let normalTabColor = UIColor(rgb: 0x81818c)

        var i = 0
        for item in items {
            item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 1)
            let selectedimage = UIImage(named: "\(tabBarItemImages[i])+")
            let unselectedimage = UIImage(named: "\(tabBarItemImages[i])")
            item.setFinishedSelectedImage(selectedimage, unselectedImage: unselectedimage)

            item.title = tabbarTitles[i]

            item.selectedTitleAttributes = [
                NSForegroundColorAttributeName: selectedTabColor,
                NSFontAttributeName: UIFont.systemFont(ofSize: 11)
            ]
            item.unselectedTitleAttributes = [
                NSForegroundColorAttributeName: normalTabColor,
                NSFontAttributeName: UIFont.systemFont(ofSize: 11)
            ]

            i += 1
        }
    }

}

