//
//  PhoneAuthModel.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/08.
//

import Foundation

// 사용자가 핸드폰 인증번호 버튼을 눌렀을 때,
// 서버에 핸드폰 인증번호 전송을 요청하는 Request body의 형태.
struct PhoneAuthInput : Encodable {
    var recipientPhoneNumber: String?
}

// 핸드폰 인증번호 전송을 요청했을 때 받게 될 Response의 형태.
struct PhoneAuthModel : Decodable {
    var code : Int?
    var isSuccess : Bool?
    var message : String?
    var result : PhoneAuthResult?
}

struct PhoneAuthResult : Decodable {
    var requestId: String?
    var requestTime: String?
    var statusCode: String?
    var statusName: String?
}
