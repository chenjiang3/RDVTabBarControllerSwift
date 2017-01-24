//
//  RDVTabBarItem.swift
//  Pods
//
//  Created by chenjiang on 2017/1/23.
//
//

import UIKit

open class RDVTabBarItem: UIControl {

    open var title = ""
    var imagePositionAdjustment: UIOffset?
    var unselectedTitleAttributes = [
        NSFontAttributeName: UIFont.systemFont(ofSize: 12),
        NSForegroundColorAttributeName: UIColor.black
    ]

    var selectedTitleAttributes = [
        NSFontAttributeName: UIFont.systemFont(ofSize: 12),
        NSForegroundColorAttributeName: UIColor.black
    ]

    var titlePositionAdjustment = UIOffset.zero

    var badgeBackgroundColor = UIColor.red
    var badgeTextColor = UIColor.white
    var badgeTextFont = UIFont.systemFont(ofSize: 12)
    var badgePositionAdjustment = UIOffset.zero

    var itemHeight: CGFloat?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInitialization()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInitialization()
    }

    func commonInitialization() {
        backgroundColor = UIColor.clear
    }

}


// MARK: - Accessibility
extension RDVTabBarItem {

    override open var accessibilityLabel: String? {
        get {
            return "tabbarItem"
        }
        set {
            super.accessibilityLabel = newValue
        }
    }

    override open var isAccessibilityElement: Bool {
        get {
            return true
        }
        set {
            super.isAccessibilityElement = newValue
        }
    }

}























