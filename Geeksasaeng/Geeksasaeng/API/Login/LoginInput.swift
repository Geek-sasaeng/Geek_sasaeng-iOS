//
//  LoginInput.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/02.
//

import Foundation

// 로그인을 했을 때 보낼 Request body의 형태.
struct LoginInput : Encodable {
    var loginId: String?
    var password: String?
}
