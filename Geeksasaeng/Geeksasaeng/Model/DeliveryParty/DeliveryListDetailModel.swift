//
//  DeliveryListDetailModel.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/21.
//

import Foundation

struct DeliveryListDetailModel: Decodable {
    var code: Int?
    var isSuccess: Bool?
    var message: String?
    var result: DeliveryListDetailModelResult?
}

struct DeliveryListDetailModelResult: Decodable {
    var chief: String?
    var chiefId: Int?
    var chiefProfileImgUrl: String?
    var content: String?
    var currentMatching: Int?
    var foodCategory: String?
    var hashTag: Bool?
    var id: Int?
    var latitude: Double?
    var longitude: Double?
    var matchingStatus: String?
    var maxMatching: Int?
    var orderTime: String?
    var title: String?
    var updatedAt: String?
    var storeUrl: String?
    var authorStatus: Bool?
    var dormitory: Int?
    var uuid: String?
    var belongStatus: String?
    var partyChatRoomId: String?
    var activeStatus: Bool?
}
