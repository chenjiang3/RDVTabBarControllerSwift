// RDVTabBarItem.swift
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

open class RDVTabBarItem: UIControl {

    open var title = ""
    open var imagePositionAdjustment = UIOffset(horizontal: 0, vertical: 0)
    open var unselectedTitleAttributes = [
        NSFontAttributeName: UIFont.systemFont(ofSize: 12),
        NSForegroundColorAttributeName: UIColor.black
    ]

    open var selectedTitleAttributes = [
        NSFontAttributeName: UIFont.systemFont(ofSize: 12),
        NSForegroundColorAttributeName: UIColor.black
    ]

    open var titlePositionAdjustment = UIOffset.zero
    
    open var badgeValue: String = "" {
        didSet {
            setNeedsDisplay()
        }
    }
    
    open var badgeBackgroundColor = UIColor.red
    open var badgeTextColor = UIColor.white
    open var badgeTextFont = UIFont.systemFont(ofSize: 12)
    open var badgePositionAdjustment = UIOffset.zero

    open var unselectedBackgroundImage: UIImage?
    open var selectedBackgroundImage: UIImage?
    open var unselectedImage: UIImage?
    open var selectedImage: UIImage?

    open var itemHeight: CGFloat?

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

    open func setFinishedSelectedImage(_ selectedImage: UIImage?, unselectedImage: UIImage?) {
        self.selectedImage = selectedImage
        self.unselectedImage = unselectedImage
    }

    open func setBackgroundSelectedImage(_ selectedImage: UIImage?, unselectedImage: UIImage?) {
        self.selectedBackgroundImage = selectedImage
        self.unselectedBackgroundImage = unselectedImage
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
        if title.count == 0 {
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

        // Draw badges
        if let badgeValue = Int(badgeValue), badgeValue != 0 {
            var badgeSize = CGSize.zero

            badgeSize = NSString(string: self.badgeValue).boundingRect(with: CGSize(width: frameSize.width,
                                                                                    height: CGFloat(20)),
                                                                       options: .usesLineFragmentOrigin,
                                                                       attributes: [NSFontAttributeName: badgeTextFont],
                                                                       context: nil).size
            let textOffset = CGFloat(2.0)

            if badgeSize.width < badgeSize.height {
                badgeSize = CGSize(width: badgeSize.height, height: badgeSize.height)
            }

            let x = CGFloat(roundf(Float((frameSize.width / CGFloat(2) + (imageSize.width / CGFloat(2)) * CGFloat(0.9))))) + badgePositionAdjustment.horizontal
            let y = textOffset + badgePositionAdjustment.vertical
            let badgeBackgroundFrame = CGRect(x: x,
                                              y: y,
                                              width: badgeSize.width + CGFloat(2) * textOffset,
                                              height: badgeSize.height + CGFloat(2) * textOffset)

            context?.setFillColor(badgeBackgroundColor.cgColor)
            context?.fillEllipse(in: badgeBackgroundFrame)

            context?.setFillColor(badgeTextColor.cgColor)

            let badgeTextStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
            badgeTextStyle.lineBreakMode = .byWordWrapping
            badgeTextStyle.alignment = NSTextAlignment.center

            let badgeTextAttributes: [String : Any] = [
                NSFontAttributeName: badgeTextFont,
                NSForegroundColorAttributeName: badgeTextColor,
                NSParagraphStyleAttributeName: badgeTextStyle
            ]

            let rect = CGRect(x: badgeBackgroundFrame.minX + textOffset,
                              y: badgeBackgroundFrame.minY + textOffset,
                              width: badgeSize.width,
                              height: badgeSize.height)
            NSString(string: self.badgeValue).draw(in: rect, withAttributes: badgeTextAttributes)
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
