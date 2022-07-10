//
//  UIView+Extension.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/09.
//

import UIKit

extension UIView {
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
}
