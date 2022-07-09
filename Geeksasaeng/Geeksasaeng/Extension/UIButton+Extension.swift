//
//  UIButton+Extension.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/09.
//

import UIKit

extension UIButton {
    
    // UIButton의 아래 라인 만들어주는 함수
    func makeBottomLine(_ width: CGFloat) {
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.init(hex: 0x5B5B5B)
        
        self.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { make in
            make.top.equalTo(self.snp.bottom).offset(-8)
            make.width.equalTo(width)
            make.height.equalTo(1)
        }
    }
    
    func setActivatedNextButton() {
        self.isEnabled = true
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = .mainColor
    }
    
    func setDeactivatedNextButton() {
        self.isEnabled = false
        self.tintColor = UIColor(hex: 0xA8A8A8)
        self.backgroundColor = UIColor(hex: 0xEFEFEF)
    }
    
    func setActivatedButton() {
        self.isEnabled = true
        self.setTitleColor(.mainColor, for: .normal)
        self.backgroundColor = .white
        self.layer.shadowRadius = 4
        self.layer.shadowColor = UIColor.mainColor.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.masksToBounds = false
    }
    
    func setDeactivatedButton() {
        self.isEnabled = false
        self.setTitleColor(UIColor(hex: 0xA8A8A8), for: .normal)
        self.backgroundColor = UIColor(hex: 0xEFEFEF)
        self.layer.shadowRadius = 0
    }
}
