//
//  NaverLoginModel.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/05.
//

import Foundation
import NaverThirdPartyLogin

class NaverLoginModel {
    let naverLoginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    func isExistToken() -> Bool {
        if (naverLoginInstance?.accessToken) != nil {
            return true
        } else {
            return false
        }
    }
}
