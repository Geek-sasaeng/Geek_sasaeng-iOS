//
//  CloseMatchingModel.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2023/01/15.
//

import Foundation

// 매칭 마감 API에 필요한 모델
struct CloseMatchingInput: Encodable {
    var partyId: Int?
}

struct CloseMatchingModel: Decodable {
    var code : Int?
    var isSuccess : Bool?
    var message : String?
    var result : CloseMatchingModelResult?
}
struct CloseMatchingModelResult: Decodable {
    var deliveryPartyId: Int?
    var matchingStatus: String?
}
