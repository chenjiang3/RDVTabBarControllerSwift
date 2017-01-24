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
    var imagePositionAdjustment: UIOffset = UIOffset(horizontal: 0, vertical: 0)
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

    var unselectedBackgroundImage: UIImage?
    var selectedBackgroundImage: UIImage?
    var unselectedImage: UIImage?
    var selectedImage: UIImage?

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

    open override func draw(_ rect: CGRect) {
        let frameSize = frame.size
        var imageSize = CGSize.zero
        var titleSize = CGSize.zero

        var image: UIImage?
        var backgroundImage: UIImage?
        var titleAttributes = self.selectedTitleAttributes

        var imageStartingY = CGFloat(0)

        if isSelected {
            image = self.selectedImage
            backgroundImage = self.selectedBackgroundImage
            titleAttributes = self.selectedTitleAttributes
        } else {
            image = self.unselectedImage
            backgroundImage = self.unselectedBackgroundImage
            titleAttributes = self.unselectedTitleAttributes
        }

        imageSize = image?.size ?? CGSize.zero

        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()

        backgroundImage?.draw(in: bounds)

        // Draw image and title
        if title.characters.count == 0 {
            let x = CGFloat(roundf(Float(frameSize.width / CGFloat(2) - imageSize.width / CGFloat(2)))) + imagePositionAdjustment.horizontal
            let y = CGFloat(roundf(Float(frameSize.height / CGFloat(2) - imageSize.height / CGFloat(2)))) + imagePositionAdjustment.vertical
            image?.draw(in: CGRect(x: x, y: y, width: imageSize.width, height: imageSize.height))
        } else {
            titleSize = NSString(string: title).boundingRect(with: CGSize(width: frameSize.width, height: 20),
                                                             options: .usesLineFragmentOrigin,
                                                             attributes: titleAttributes,
                                                             context: nil).size
            imageStartingY = CGFloat(roundf(Float((frameSize.height - imageSize.height - titleSize.height) / CGFloat(2.0))))
            var x = CGFloat(roundf(Float(frameSize.width / 2 - imageSize.width / 2))) + imagePositionAdjustment.horizontal
            var y = imageStartingY + imagePositionAdjustment.vertical
            image?.draw(in: CGRect(x: x, y: y, width: imageSize.width, height: imageSize.height))

            let fillColor = titleAttributes[NSForegroundColorAttributeName] as! UIColor
            context?.setFillColor(fillColor.cgColor)

            x = CGFloat(roundf(Float(frameSize.width / 2 - titleSize.width / 2))) + titlePositionAdjustment.horizontal
            y = imageStartingY + imageSize.height + titlePositionAdjustment.vertical
            let rect = CGRect(x: x, y: y, width: titleSize.width, height: titleSize.height)
            NSString(string: title).draw(in: rect, withAttributes: titleAttributes)
        }


        context?.restoreGState()
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























