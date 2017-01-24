//
//  RDVTabBar.swift
//  Pods
//
//  Created by chenjiang on 2017/1/23.
//
//

import UIKit

protocol RDVTabBarDelegate: NSObjectProtocol {

    func tabBar(_ tabBar: RDVTabBar?, shouldSelectItemAtIndex: Int) -> Bool
    func tabBar(_ tabBar: RDVTabBar?, didSelectItemAtIndex: Int)
}

open class RDVTabBar: UIView {

    var _items: [RDVTabBarItem]?
    open var items: [RDVTabBarItem]? {
        get {
            return _items
        }
        set {
            guard let items = newValue else {
                return
            }
            if let oldItems = _items {
                for item in oldItems {
                    item.removeFromSuperview()
                }
            }
            _items = items
            for item in items {
                item.addTarget(self, action: #selector(tabBarItemWasSelected(_:)), for: .touchDown)
                addSubview(item)
            }
        }
    }

    var _selectedItem: RDVTabBarItem?
    var selectedItem: RDVTabBarItem? {
        get {
            return _selectedItem
        }
        set {
            if let oldSelectedItem = _selectedItem, oldSelectedItem == newValue{
                return
            }

            _selectedItem?.isSelected = false

            _selectedItem = newValue
            _selectedItem?.isSelected = true
        }
    }

    weak var delegate: RDVTabBarDelegate?

    var contentEdgeInsets = UIEdgeInsets.zero
    var itemWidth: CGFloat?

    open var backgroundView = UIView()

    var _translucent: Bool = false
    var translucent: Bool {
        get {
            return _translucent
        }
        set {
            _translucent = newValue
            let alpha = newValue ? CGFloat(0.9) : CGFloat(1.0)
            backgroundView.backgroundColor = UIColor(red: 245.0 / 255.0,
                                                     green: 245.0 / 255.0,
                                                     blue: 245.0 / 255.0,
                                                     alpha: alpha)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInitialization()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInitialization()
    }

    func commonInitialization() {
        addSubview(backgroundView)
        translucent = false
    }

    open func setHeight(_ height: CGFloat) {
        self.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: height)
    }

    override open func layoutSubviews() {
        let frameSize = frame.size
        let minimumContentHeight = self.minimumContentHeight()

        backgroundView.frame = CGRect(x: 0, y: frameSize.height - minimumContentHeight,
                                      width: frameSize.width, height: frameSize.height)
        let count = self.items?.count ?? 1
        let width = CGFloat(frameSize.width - contentEdgeInsets.left - contentEdgeInsets.right) / CGFloat(count)

        self.itemWidth = CGFloat(roundf(Float(width)))
        
        guard let items = self.items else {
            return
        }

        // Layout items
        var index = CGFloat(0)
        for item in items {
            let itemHeight = item.itemHeight ?? frameSize.height
            let x = self.contentEdgeInsets.left + (index * self.itemWidth!)
            let y = CGFloat(roundf(Float((frameSize.height - itemHeight) - self.contentEdgeInsets.top)))
            item.frame = CGRect(x: x, y: y, width: self.itemWidth!, height: itemHeight - self.contentEdgeInsets.bottom)
            item.setNeedsDisplay()

            index += CGFloat(1)
        }
    }

    func minimumContentHeight() -> CGFloat {
        var minimumTabBarContentHeight = frame.height
        guard let items = items else {
            return minimumTabBarContentHeight
        }

        for item in items {
            if let itemHeight = item.itemHeight, itemHeight < minimumTabBarContentHeight {
                minimumTabBarContentHeight = itemHeight
            }
        }

        return minimumTabBarContentHeight
    }

    // MARK: - Item selection
    func tabBarItemWasSelected(_ sender: RDVTabBarItem) {
        if let delegate = self.delegate {
            var index = self.items?.index(of: sender)

            if delegate.tabBar(self, shouldSelectItemAtIndex: index!) == false {
                return
            }

            self.selectedItem = sender

            index = self.items?.index(of: sender)
            delegate.tabBar(self, didSelectItemAtIndex: index!)
        }
    }



}

// MARK: UIView + extension
extension UIView {
    var borderColor: UIColor {
        get {
            guard let borderColor = layer.borderColor else {
                return UIColor.blue
            }
            return UIColor(cgColor: borderColor)
        }
        set {
            layer.borderColor = newValue.cgColor
            layer.borderWidth = 1.0
        }
    }
}








































