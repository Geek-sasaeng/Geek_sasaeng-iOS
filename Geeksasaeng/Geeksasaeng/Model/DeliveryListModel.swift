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
    var category: String?
    var chief: String?
    var content: String?
    var currentMatching: Int?
    var hashTags: [String]?
    var id: Int?
    var location: String?
    var matchingStatus: String?
    var maxMatching: Int?
    var orderTime: String?
    var title: String?
}
