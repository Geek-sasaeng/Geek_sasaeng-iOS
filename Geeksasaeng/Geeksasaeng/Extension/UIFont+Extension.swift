//
//  UIFont+Extension.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/01.
//
// extension을 활용하여 swift 코드 내에서 편리하게 폰트를 적용 가능!
// - ex. label.font = .customFont(.neoBold, size: 16)

import UIKit

extension UIFont {
    public enum customFontType: String {
        case gmarketSansMedium = "GmarketSansMedium"
        case neoBold = "SpoqaHanSansNeo-Bold"
        case neoLight = "SpoqaHanSansNeo-Light"
        case neoMedium = "SpoqaHanSansNeo-Medium"
        case neoRegular = "SpoqaHanSansNeo-Regular"
    }
    
    static func customFont(_ type: customFontType, size: CGFloat) -> UIFont {
        return UIFont(name: "\(type.rawValue)", size: size)!
    }
}
