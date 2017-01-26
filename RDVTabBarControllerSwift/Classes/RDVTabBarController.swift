//
//  RDVTabBarController.swift
//  Pods
//
//  Created by chenjiang on 2017/1/23.
//
//

import UIKit

// MARK: - RDVTabBarControllerDelegate
public protocol RDVTabBarControllerDelegate: NSObjectProtocol {
    func tabBarController(_ tabBarController: RDVTabBarController, shouldSelectViewController viewController: UIViewController) -> Bool
    func tabBarController(_ tabBarController: RDVTabBarController, didSelectViewController viewController: UIViewController)
}

// MARK: - RDVTabBarController
open class RDVTabBarController: UIViewController, RDVTabBarDelegate {

    open weak var delegate: RDVTabBarControllerDelegate?

    var _tabBarHidden = false
    var tabBarHidden: Bool {
        get {
            return _tabBarHidden
        }
        set {
            _tabBarHidden = newValue
        }
    }

    var _selectedViewController: UIViewController?
    open var selectedViewController: UIViewController? {
        get {
            return _selectedViewController
        }
        set {
            _selectedViewController = newValue
        }
    }

    var _selectedIndex: Int = 0
    open var selectedIndex: Int {
        get {
            return _selectedIndex
        }
        set {
            guard let viewControllers = viewControllers else {
                return
            }

            if newValue >= viewControllers.count {
                return
            }

            if let selectedViewController = self.selectedViewController {
                selectedViewController.willMove(toParentViewController: nil)
                selectedViewController.view.removeFromSuperview()
                selectedViewController.removeFromParentViewController()
            }

            _selectedIndex = newValue

            self.tabBar.selectedItem = self.tabBar.items?[_selectedIndex]

            self.selectedViewController = self.viewControllers?[_selectedIndex]

            if let selectedViewController0 = self.selectedViewController {
                addChildViewController(selectedViewController0)
                selectedViewController0.view.frame = self.contentView.bounds
                self.contentView.addSubview(selectedViewController0.view)
                selectedViewController0.didMove(toParentViewController: self)
            }

            setNeedsStatusBarAppearanceUpdate()
        }
    }

    var _contentView: UIView?
    var contentView: UIView {
        if _contentView == nil {
            _contentView = UIView()
            _contentView?.backgroundColor = UIColor.white
            _contentView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
        return _contentView!
    }

    var _tabBar: RDVTabBar?
    open var tabBar: RDVTabBar {
        if _tabBar == nil {
            _tabBar = RDVTabBar()
            _tabBar?.backgroundColor = UIColor.clear
            _tabBar?.autoresizingMask = [.flexibleWidth, .flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
            _tabBar?.delegate = self
        }
        return _tabBar!
    }

    var _viewControllers: [UIViewController]?
    public var viewControllers: [UIViewController]? {
        get {
            return _viewControllers
        }
        set {
            if let _viewControllers = _viewControllers {
                for viewController in _viewControllers {
                    viewController.willMove(toParentViewController: nil)
                    viewController.view.removeFromSuperview()
                    viewController.removeFromParentViewController()
                }
            }

            if let viewControllers = newValue {
                _viewControllers = viewControllers
                var tabBarItems = [RDVTabBarItem]()
                for viewController in viewControllers {
                    let tabBarItem = RDVTabBarItem()
                    tabBarItem.title = viewController.title ?? ""
                    tabBarItems.append(tabBarItem)
                    viewController.rdv_setTabBarController(self)
                }
                tabBar.items = tabBarItems
            } else {
                if let _viewControllers = _viewControllers {
                    for viewController in _viewControllers {
                        viewController.rdv_setTabBarController(nil)
                    }
                }
                self._viewControllers = nil
            }
        }
    }

    override open func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        view.borderColor = UIColor.red

        view.addSubview(contentView)
        view.addSubview(tabBar)
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.selectedIndex = self._selectedIndex
        self.setTabBarHidden(self.tabBarHidden, animated: false)
    }

    func setTabBarHidden(_ hidden: Bool, animated: Bool) {
        _tabBarHidden = hidden

        let block = { [weak self] in
            guard let me = self else {
                return
            }

            let viewSize = me.view.bounds.size
            var tabBarStartingY = viewSize.height
            var contentViewHeight = viewSize.height
            var tabBarHeight = me.tabBar.frame.height

            if tabBarHeight == 0 {
                tabBarHeight = 49
            }

            if me.tabBarHidden == false {
                tabBarStartingY = viewSize.height - tabBarHeight
                if me.tabBar.translucent == false {
                    contentViewHeight -= (me.tabBar.minimumContentHeight() > 0 ? me.tabBar.minimumContentHeight() : tabBarHeight)
                }
                me.tabBar.isHidden = false
            }
            me.tabBar.frame = CGRect(x: 0, y: tabBarStartingY, width: viewSize.width, height: tabBarHeight)
            me.contentView.frame = CGRect(x: 0, y: 0, width: viewSize.width, height: contentViewHeight)
        }

        let completion: (Bool) -> Void = { [weak self] (finished) in
            guard let me = self else {
                return
            }
            if me.tabBarHidden {
                me.tabBar.isHidden = true
            }
        }

        if animated {
            UIView.animate(withDuration: TimeInterval(0.24), animations: block, completion: completion)
        } else {
            block()
            completion(true)
        }
    }

    func indexForViewController(_ viewController: UIViewController) -> Int {
        var searchedController = viewController
        if let navController = searchedController.navigationController {
            searchedController = navController
        }
        return viewControllers?.index(of: searchedController) ?? 0
    }



}

// MARK: - RDVTabBarDelegate
extension RDVTabBarController {

    func tabBar(_ tabBar: RDVTabBar?, shouldSelectItemAtIndex index: Int) -> Bool {
        if let delegate = self.delegate, let viewController = self.viewControllers?[index] {
            if delegate.tabBarController(self, shouldSelectViewController: viewController) == false {
                return false
            }
        }

        if let selectedViewController = self.selectedViewController, let viewvc = self.viewControllers?[index], selectedViewController == viewvc {
            if selectedViewController.isKind(of: UINavigationController.self) {
                let selectedController = selectedViewController as! UINavigationController
                if let topViewController = selectedController.topViewController, topViewController != selectedController.viewControllers[0] {
                    selectedController.popToRootViewController(animated: true)
                }
            }
            return false
        }

        return true
    }

    func tabBar(_ tabBar: RDVTabBar?, didSelectItemAtIndex index: Int) {
        guard let viewControllers = self.viewControllers else {
            return
        }

        if index < 0 || index >= viewControllers.count {
            return
        }

        self.selectedIndex = index

        if let delegate = self.delegate {
            delegate.tabBarController(self, didSelectViewController: viewControllers[index])
        }
    }
}

// MARK: - UIViewController+RDVTabBarControllerItem
fileprivate var key_rdv_tabBarController = "rdv_tabBarController"
extension UIViewController {

    func rdv_setTabBarController(_ tabBarController: RDVTabBarController?) {
        objc_setAssociatedObject(self, &key_rdv_tabBarController, tabBarController, .OBJC_ASSOCIATION_ASSIGN)
    }

    func rdv_tabBarController() -> RDVTabBarController? {
        guard let tabBarController = objc_getAssociatedObject(self, &key_rdv_tabBarController) else {
            return self.parent?.rdv_tabBarController()
        }

        return tabBarController as? RDVTabBarController
    }

    func rdv_tabBarItem() -> RDVTabBarItem? {
        guard let tabBarController = self.rdv_tabBarController() else {
            return nil
        }

        let index = tabBarController.indexForViewController(self)
        return tabBarController.tabBar.items?[index]
    }

    func rdv_setTabBarItem(_ tabBarItem: RDVTabBarItem) {
        guard let tabBarController = self.rdv_tabBarController() else {
            return
        }

        let tabBar = tabBarController.tabBar
        let index = tabBarController.indexForViewController(self)

        guard let tabBarItems = tabBar.items else {
            return
        }

        var copyArray = tabBarItems
        copyArray[index] = tabBarItem
        tabBar.items = copyArray
    }

}
