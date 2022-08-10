//
//  UILabel+Extension.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/08/09.
//

import Foundation

// 패딩이 적용된 라벨
class PaddingLabel: UILabel {

    var topInset: CGFloat = 10.0
    var bottomInset: CGFloat = 10.0
    var leftInset: CGFloat = 18.0
    var rightInset: CGFloat = 18.0

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }

    override var bounds: CGRect {
        didSet {
            preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset)
        }
    }
}
