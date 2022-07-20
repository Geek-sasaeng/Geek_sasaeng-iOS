//
//  EmailAuthCheckModel.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/09.
//

import Foundation

// Req 요청 보낼 때
struct EmailAuthCheckInput: Encodable {
    var email: String?
    var key: String?
}

// Res 응답 받을 때
struct EmailAuthCheckModel: Decodable {
    var code: Int?
    var isSuccess: Bool?
    var message: String?
    var result: String?
}
