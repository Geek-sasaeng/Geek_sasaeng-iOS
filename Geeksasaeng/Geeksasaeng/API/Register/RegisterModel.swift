//
//  RegisterModel.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/02.
//

import Foundation

// 회원가입을 요청했을 때 받게 될 Response의 형태.
struct RegisterModel : Decodable {
    var isSuccess : Bool?
    var code : Int?
    var message : String?
    var result : RegisterModelResult?
}

struct RegisterModelResult : Decodable {
    var loginId: String?
    var nickname: String?
    var universityName: String?
    var email: String?
    var phoneNumber: String?
}
