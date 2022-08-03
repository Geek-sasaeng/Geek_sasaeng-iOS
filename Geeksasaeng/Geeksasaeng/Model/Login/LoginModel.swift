//
//  LoginModel.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/02.
//

import Foundation

class LoginModel {
    static var jwt: String?
}

// 로그인을 요청했을 때 받게 될 Response의 형태.
struct LoginOutput : Decodable {
    var isSuccess : Bool?
    var code : Int?
    var message : String?
    var result : LoginModelResult?
}

struct LoginModelResult : Decodable {
    var jwt: String?
    var loginStatus: String?
    var nickName: String?
}

// 로그인을 했을 때 보낼 Request body의 형태.
struct LoginInput : Encodable {
    var loginId: String?
    var password: String?
}

struct NaverLoginCheck {
    static var firstLogin = false
}
