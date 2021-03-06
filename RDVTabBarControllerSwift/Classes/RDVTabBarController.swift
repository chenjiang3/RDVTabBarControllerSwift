// RDVTabBarController.swift
//
// Copyright (c) 2017 chenjiang
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

fileprivate let TABBAR_HEIGHT_IPHONE_X: CGFloat = 84.0
fileprivate let TABBAR_HEIGHT_NORMAL: CGFloat = 49.0

// MARK: - RDVTabBarControllerDelegate
public protocol RDVTabBarControllerDelegate: NSObjectProtocol {
    func tabBarController(_ tabBarController: RDVTabBarController, shouldSelectViewController viewController: UIViewController) -> Bool
    func tabBarController(_ tabBarController: RDVTabBarController, didSelectViewController viewController: UIViewController)
}

// MARK: - RDVTabBarController
open class RDVTabBarController: UIViewController, RDVTabBarDelegate {
    
    open weak var delegate: RDVTabBarControllerDelegate?
    
    open var tabBarHidden: Bool = false
    
    open var selectedViewController: UIViewController?
    
    private var _selectedIndex: Int = 0
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
    
    lazy var contentView: UIView = {
        let v: UIView = UIView()
        v.backgroundColor = UIColor.white
        v.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return v
    }()
    
    open lazy var tabBar: RDVTabBar = {
        let _tabBar = RDVTabBar()
        _tabBar.backgroundColor = UIColor.clear
        _tabBar.delegate = self
        return _tabBar
    }()
    
    private lazy var tabBarContainer: UIView = {
        let v: UIView = UIView()
        v.backgroundColor = UIColor.white
        v.autoresizingMask = [.flexibleWidth, .flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
        v.addSubview(self.tabBar)
        self.tabBar.translatesAutoresizingMaskIntoConstraints = false
        let leftConstraint = NSLayoutConstraint(item: self.tabBar, attribute: .left, relatedBy: .equal, toItem: v, attribute: .left, multiplier: 1.0, constant: 0.0)
        let rightConstraint = NSLayoutConstraint(item: self.tabBar, attribute: .right, relatedBy: .equal, toItem: v, attribute: .right, multiplier: 1.0, constant: 0.0)
        let topConstraint = NSLayoutConstraint(item: self.tabBar, attribute: .top, relatedBy: .equal, toItem: v, attribute: .top, multiplier: 1.0, constant: 0.0)
        let heightConstraint = NSLayoutConstraint(item: self.tabBar, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: TABBAR_HEIGHT_NORMAL)
        v.addConstraint(leftConstraint)
        v.addConstraint(topConstraint)
        v.addConstraint(rightConstraint)
        self.tabBar.addConstraint(heightConstraint)
        return v
    }()
    
    private var _viewControllers: [UIViewController]?
    open var viewControllers: [UIViewController]? {
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
                    viewController.rdv_tabBarController = self
                }
                tabBar.items = tabBarItems
            } else {
                if let _viewControllers = _viewControllers {
                    for viewController in _viewControllers {
                        viewController.rdv_tabBarController = nil
                    }
                }
                self._viewControllers = nil
            }
        }
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        view.addSubview(contentView)
        view.addSubview(tabBarContainer)
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.selectedIndex = self._selectedIndex
        self.setTabBarHidden(self.tabBarHidden, animated: false)
    }
    
    open func setTabBarHidden(_ hidden: Bool, animated: Bool) {
        self.tabBarHidden = hidden
        
        let block = { [weak self] in
            guard let me = self else {
                return
            }
            
            let viewSize = me.view.bounds.size
            var tabBarContainerStartingY = viewSize.height
            var contentViewHeight = viewSize.height
            var tabBarContainerHeight = TABBAR_HEIGHT_NORMAL
            if isIphoneX() {
                tabBarContainerHeight = TABBAR_HEIGHT_IPHONE_X
            } else {
                tabBarContainerHeight = TABBAR_HEIGHT_NORMAL
            }
            
            if me.tabBarHidden {
                tabBarContainerStartingY = viewSize.height
            } else {
                tabBarContainerStartingY = viewSize.height - tabBarContainerHeight
            }
            
            if me.tabBarHidden == false {
                if me.tabBar.translucent == false {
                    contentViewHeight -= tabBarContainerHeight
                }
                me.tabBar.isHidden = false
                me.tabBarContainer.isHidden = false
            }
            
            me.tabBarContainer.frame = CGRect(x: 0, y: tabBarContainerStartingY, width: viewSize.width, height: tabBarContainerHeight)
            me.contentView.frame = CGRect(x: 0, y: 0, width: viewSize.width, height: contentViewHeight)
        }
        
        let completion: (Bool) -> Void = { [weak self] (finished) in
            guard let me = self else {
                return
            }
            if me.tabBarHidden {
                me.tabBar.isHidden = true
                me.tabBarContainer.isHidden = true
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
public extension UIViewController {
    
    public var rdv_tabBarController: RDVTabBarController? {
        get {
            guard let tabBarController = objc_getAssociatedObject(self, &key_rdv_tabBarController) else {
                return self.parent?.rdv_tabBarController
            }
            
            return tabBarController as? RDVTabBarController
        }
        set {
            objc_setAssociatedObject(self, &key_rdv_tabBarController, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    public var rdv_tabBarItem: RDVTabBarItem? {
        get {
            guard let tabBarController = self.rdv_tabBarController else {
                return nil
            }
            
            let index = tabBarController.indexForViewController(self)
            return tabBarController.tabBar.items?[index]
        }
        set {
            guard let newValue = newValue else {
                return
            }
            
            guard let tabBarController = self.rdv_tabBarController else {
                return
            }
            
            let tabBar = tabBarController.tabBar
            let index = tabBarController.indexForViewController(self)
            
            guard let tabBarItems = tabBar.items else {
                return
            }
            
            var copyArray = tabBarItems
            copyArray[index] = newValue
            tabBar.items = copyArray
        }
    }
    
}
