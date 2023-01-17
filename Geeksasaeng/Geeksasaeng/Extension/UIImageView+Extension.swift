//
//  UIImageView+Extension.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2023/01/14.
//

import UIKit

extension UIImageView {
    
    // 방장 프로필 이미지에 테두리 그려주는 함수
    func drawBorderToChief() {
        self.layer.borderColor = UIColor.init(hex: 0x3266EB).cgColor
        self.layer.borderWidth = 1
    }
}

