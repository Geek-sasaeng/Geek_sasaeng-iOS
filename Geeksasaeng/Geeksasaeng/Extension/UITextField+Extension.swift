//
//  UITextField+Extension.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/09.
//

import UIKit

extension UITextField {
    
    // UITextField의 아래 라인 만들어주는 함수
    func makeBottomLine() {
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.init(hex: 0xEFEFEF)
        borderStyle = .none
        
        self.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { make in
            make.top.equalTo(self.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
}
