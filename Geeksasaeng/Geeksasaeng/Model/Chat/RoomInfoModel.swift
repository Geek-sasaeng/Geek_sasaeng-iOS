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
    var participants: [String]?
}
