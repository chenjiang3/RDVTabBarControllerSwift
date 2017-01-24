//
//  RDVTabBarController.swift
//  Pods
//
//  Created by chenjiang on 2017/1/23.
//
//

import UIKit

open class RDVTabBarController: UIViewController, RDVTabBarDelegate {

    var _tabBarHidden = false
    var tabBarHidden: Bool {
        get {
            return _tabBarHidden
        }
        set {
            _tabBarHidden = newValue
        }
    }

    var _selectedIndex: Int = 0
    open var selectedIndex: Int {
        get {
            return _selectedIndex
        }
        set {
            _selectedIndex = newValue

            guard let viewControllers = viewControllers else {
                return
            }

            if newValue >= viewControllers.count {
                return
            }


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

    var selectedViewController: UIViewController? {
        return self.viewControllers?[self.selectedIndex]
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

    func tabBar(_ tabBar: RDVTabBar?, shouldSelectItemAtIndex: Int, resultBlock: ((Bool) -> Void)?) {

    }

    func tabBar(_ tabBar: RDVTabBar?, didSelectItemAtIndex: Int) {

    }

    func indexForViewController(_ viewController: UIViewController) -> Int {
        var searchedController = viewController
        if let navController = searchedController.navigationController {
            searchedController = navController
        }
        return viewControllers?.index(of: searchedController) ?? 0
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

//    func rdv_tabBarItem() -> RDVTabBarItem {
//        let tabBarController = rdv_tabBarController()
//        let index = tabBarController?.indexForViewController(self)
//        return tabBarController?.tabBar
//    }

}

// MARK: - ClosureWrapper
class ClosureWrapper<T>: NSObject, NSCopying {
    public var closure: T?

    convenience init(_ closure: T?) {
        self.init()
        self.closure = closure
    }

    func copy(with zone: NSZone? = nil) -> Any {
        let wrapper = ClosureWrapper(closure)
        return wrapper
    }
}





















































