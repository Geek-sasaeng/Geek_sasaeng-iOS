//
//  UIView+Extension.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/09.
//

import UIKit

extension UIView {
    
    /* view에 그라데이션 적용 -> vertical style */
    func setGradient(startColor: UIColor, endColor: UIColor){
        let gradient = CAGradientLayer().then {
            // startColor가 더 연한 색깔
            $0.colors = [startColor.cgColor, endColor.cgColor]
            $0.startPoint = CGPoint(x: 0.0, y: 0.0)
            $0.endPoint = CGPoint(x: 0.0, y: 1.0)
            $0.frame = bounds
        }
        layer.addSublayer(gradient)
    }
    
    /* 뷰에 원하는 그림자 적용 */
    public func setViewShadow(shadowOpacity: Float, shadowRadius: CGFloat) {
        self.layer.shadowColor = UIColor.init(hex: 0x000000).cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = shadowRadius
    }
}
