//
//  DeliveryListModel.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/14.
//

import Foundation

// Response
struct DeliveryListModel: Decodable {
    var code: Int?
    var isSuccess: Bool?
    var message: String?
    var result: [DeliveryListModelResult]?
}

struct DeliveryListModelResult: Decodable {
    var id: Int?
    var chief: String?
    var foodCategory: String?
    var hashTags: [String]?
    var title: String?
    var content: String?
    var orderTime: String?
    var currentMatching: Int?
    var maxMatching: Int?
    var location: String?
    var matchingStatus: String?
}
