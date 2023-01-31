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
    static var profileImgUrl: String?
    static var memberId: Int?
    static var dormitoryId: Int?
    static var dormitoryName: String?
}

// 로그인을 했을 때 보낼 Request body의 형태.
struct LoginInput : Encodable {
    var loginId: String?
    var password: String?
    var fcmToken: String?
}

struct NaverLoginInput: Encodable {
    var accessToken: String?
    var fcmToken: String?
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
    var memberId: Int?
    var nickName: String?
    var dormitoryId: Int?
    var dormitoryName: String?
    var profileImgUrl: String?
    var fcmToken: String?
}
