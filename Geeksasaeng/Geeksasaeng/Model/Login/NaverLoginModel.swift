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
}
