//
//  LoginModel.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/02.
//

import Foundation

class LoginModel {
    static var jwt: String?
    static var nickname: String?
    static var userImgUrl: String?
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
    var dormitoryId: Int?
    var dormitoryName: String?
    var userImageUrl: String?
}

// 로그인을 했을 때 보낼 Request body의 형태.
struct LoginInput : Encodable {
    var loginId: String?
    var password: String?
}

struct NaverLoginCheck {
    static var firstLogin = false
}

struct NaverLoginInput: Encodable {
    var accessToken: String?
}

struct NaverLoginOutput: Decodable {
    var isSuccess: Bool?
    var code: Int?
    var message: String?
    var result: NaverLoginResult?
}

struct NaverLoginResult: Decodable {
    var jwt: String?
    var loginStatus: String?
    var nickName: String?
    var dormitoryId: Int?
    var dormitoryName: String?
    var userImageUrl: String?
}
