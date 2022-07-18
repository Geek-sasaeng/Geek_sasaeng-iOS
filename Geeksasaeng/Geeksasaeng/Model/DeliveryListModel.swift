//
//  DeliveryListModel.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/14.
//

import Foundation

// 배달 목록 불러오기 Response
struct DeliveryListModel: Decodable {
    var code: Int?
    var isSuccess: Bool?
    var message: String?
    var result: [DeliveryListModelResult]?
}

struct DeliveryListModelResult: Decodable {
    var id: Int?
    var title: String?
    var orderTime: String?
    var currentMatching: Int?
    var maxMatching: Int?
    var hashTags: [String]?
}
