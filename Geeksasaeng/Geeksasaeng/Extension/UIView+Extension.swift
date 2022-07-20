//
//  UIView+Extension.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/09.
//

import UIKit

extension UIView {
    
    // ?? 얜 어디에 쓰는 거지
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    /* view에 그라데이션 적용 -> vertical style */
    func setGradient(startColor: UIColor, endColor: UIColor){
        let gradient = CAGradientLayer()
        // startColor가 더 연한 색깔
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.frame = bounds
        layer.addSublayer(gradient)
    }
}
