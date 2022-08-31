//
//  EmailAuthModel.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/08.
//

import Foundation

// 사용자가 이메일 '인증번호 전송' 버튼을 눌렀을 때,
// 서버에 이메일 인증번호 전송을 요청하는 Request body의 형태.
struct EmailAuthInput : Encodable {
    var email: String?
    var university: String?
    var uuid: String?
}

// 이메일 인증번호 전송을 요청했을 때 받게 될 Response의 형태.
struct EmailAuthModel : Decodable {
    var code : Int?
    var isSuccess : Bool?
    var message : String?
    var result : String?
}
