//
//  LoginModel.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/02.
//

import Foundation

// 로그인을 요청했을 때 받게 될 Response의 형태.
struct LoginModel : Decodable {
    var isSuccess : Bool?
    var code : Int?
    var message : String?
    var result : LoginModelResult?
}

struct LoginModelResult : Decodable {
    var jwt: String?
}
