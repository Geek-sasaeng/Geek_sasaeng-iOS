//
//  String+Extension.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/09.
//

import UIKit

extension String {
    func isValidId() -> Bool {
        // 대문자 or 소문자, 숫자, 6-20자
        let idExpression = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{6,20}"
        let idValidation = NSPredicate.init(format: "SELF MATCHES %@", idExpression)
        
        return idValidation.evaluate(with: self)
    }
    
    func isValidPassword() -> Bool {
        // 대문자, 소문자, 특수문자, 숫자, 8자 이상
//        let pwExpression = "^(?=.*[A-Za-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,}"
        let pwExpression = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-])[A-Za-z0-9!@#$%^&*()_+=-]{8,}"
        let pwValidation = NSPredicate.init(format: "SELF MATCHES %@", pwExpression)
        
        return pwValidation.evaluate(with: self)
    }
    
    func isValidNickname() -> Bool {
        // 대문자 or 소문자, 한글, 3-8자
        let nicknameExpression = "^(?=.*[A-Za-z가-힣])[A-Za-z가-힣]{3,8}"
        let nicknameValidation = NSPredicate.init(format: "SELF MATCHES %@", nicknameExpression)
        
        return nicknameValidation.evaluate(with: self)
    }
}
