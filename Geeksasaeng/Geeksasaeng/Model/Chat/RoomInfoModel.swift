//
//  RoomInfoModel.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/08/07.
//

import Foundation

struct RoomInfoModel: Decodable, Encodable {
    var roomInfo: RoomInfoDetailModel?
}

struct RoomInfoDetailModel: Decodable, Encodable {
    var category: String?
    var title: String?
    var participants: [Participants]?
    var maxMatching: Int?
    var updatedAt: String?
    var accountNumber: String?
    var bank: String?
    var isFinish: Bool?
}

struct Participants: Decodable, Encodable {
    var participant: String?
    var enterTime: String?
    var isRemittance: String?
}
