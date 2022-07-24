//
//  EditPartyModel.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/23.
//

import Foundation

struct EditPartyInput: Encodable {
    var dormitory: Int?
    var foodCategory: Int?
    var title: String?
    var content: String?
    var orderTime: String?
    var maxMatching: Int?
    var storeUrl: String?
    var latitude: Double?
    var longitude: Double?
    var hashTag: Bool?
}

struct EditPartyModel: Decodable {
    var isSuccess: Bool?
    var code: Int?
    var message: String?
    var result: EditPartyModelResult?
}

struct EditPartyModelResult: Decodable {
    var chief: String?
    var dormitory: String?
    var foodCategory: String?
    var title: String?
    var content: String?
    var orderTime: String?
    var updatedAt: String?
    var orderTimeCategoryType: String?
    var currentMatching: Int?
    var maxMatching: Int?
    var matchingStatus: String?
    var storeUrl: String?
    var latitude: Double?
    var longitude: Double?
    var hashTag: Bool?
}
