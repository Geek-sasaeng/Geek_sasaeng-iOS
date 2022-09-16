//
//  UILabel+Extension.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/08/09.
//

import Foundation
import UIKit

extension UILabel {
    // UILabel의 아래 라인 만들어주는 함수
    func makeBottomLine(color: UInt, width: CGFloat, height: CGFloat, offsetToTop: CGFloat) {
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.init(hex: color)
        
        self.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { make in
            make.top.equalTo(self.snp.bottom).offset(offsetToTop)
            make.width.equalTo(width)
            make.height.equalTo(height)
            make.left.equalTo(self.snp.left).offset(-5)
        }
    }
    
    func setTextColorAndFont(textColor: UIColor, font: UIFont) {
        self.textColor = textColor
        self.font = font
    }
}

// 패딩이 적용된 라벨
class PaddingLabel: UILabel {
    var textEdgeInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    open override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.inset(by: textEdgeInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textEdgeInsets.top, left: -textEdgeInsets.left, bottom: -textEdgeInsets.bottom, right: -textEdgeInsets.right)
        return textRect.inset(by: invertedInsets)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textEdgeInsets))
    }
    
    var paddingLeft: CGFloat {
        set { textEdgeInsets.left = newValue }
        get { return textEdgeInsets.left }
    }
    
    var paddingRight: CGFloat {
        set { textEdgeInsets.right = newValue }
        get { return textEdgeInsets.right }
    }
    
    var paddingTop: CGFloat {
        set { textEdgeInsets.top = newValue }
        get { return textEdgeInsets.top }
    }
    
    var paddingBottom: CGFloat {
        set { textEdgeInsets.bottom = newValue }
        get { return textEdgeInsets.bottom }
    }
}
