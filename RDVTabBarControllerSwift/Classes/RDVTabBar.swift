// RDVTabBar.swift
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

fileprivate let translucent_value = 0.9

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
    open var selectedItem: RDVTabBarItem? {
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

    open var contentEdgeInsets = UIEdgeInsets.zero
    open var itemWidth: CGFloat?

    open var backgroundView = UIView()
    
    open var translucent: Bool = false {
        didSet {
            let alpha = translucent ? CGFloat(translucent_value) : CGFloat(1.0)
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
