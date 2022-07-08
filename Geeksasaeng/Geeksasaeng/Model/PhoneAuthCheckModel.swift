//
//  PhoneAuthCheckModel.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/08.
//

import Foundation

// Response
struct PhoneAuthCheckModel: Decodable {
    var code: Int?
    var isSuccess: Bool?
    var message: String?
    var result: PhoneAuthCheckResult?
}

struct PhoneAuthCheckResult: Decodable {
    var statusName: String?
}

// Request
struct PhoneAuthCheckInput: Encodable {
    var recipientPhoneNumber: String?
    var verifyRandomNumber: String?
}
