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
    var participants: [String]?
    var accountNumber: String?
    var bankName: String?
    var isFinish: Bool?
}
