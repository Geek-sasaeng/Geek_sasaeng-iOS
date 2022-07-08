//
//  PhoneAuthNumModel.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/08.
//

import Foundation

// Response
struct PhoneAuthNumModel: Decodable {
    var code: Int?
    var isSuccess: Bool?
    var message: String?
    var result: PhoneAuthNumResult?
}

struct PhoneAuthNumResult: Decodable {
    var statusName: String?
}

// Request
struct PhoneAuthNumInput: Encodable {
    var recipientPhoneNumber: String?
    var verifyRandomNumber: String?
}
