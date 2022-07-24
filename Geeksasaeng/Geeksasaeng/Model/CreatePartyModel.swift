//
//  CreatePartyModel.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/21.
//

import Foundation

// 저장 후 사용자에게 보여줄 데이터
struct CreateParty {
    static var orderForecastTime: String?
    static var matchingPerson: String?
    static var category: String?
    static var url: String?
    static var address: String?
    static var latitude: Double?
    static var longitude: Double?
    
    // API Input에 넣기 위한 값 (CreateVC, OrderAsSoonAsMatchVC에서 초기화)
    static var orderTime: String?
    static var maxMatching: Int?
    static var foodCategory: Int?
    static var hashTag: Bool?
}

// delivery-parties API Request Input
struct CreatePartyInput: Encodable {
    var dormitory: Int?
    var title: String?
    var content: String?
    var orderTime: String?
    var maxMatching: Int?
    var foodCategory: Int?
    var latitude: Double?
    var longitude: Double?
    var storeUrl: String?
    var hashTag: Bool?
}

struct CreatePartyModel: Decodable {
    var isSuccess : Bool?
    var code : Int?
    var message : String?
    var result : CreatePartyModelResult?
}

struct CreatePartyModelResult : Decodable {
    var chief: String?
    var dormitory: String?
    var foodCategory: String?
    var title: String?
    var content: String?
    var orderTime: String?
    var createdAt: String?
    var orderTimeCategoryType: String?
    var currentMatching: Int?
    var maxMatching: Int?
    var matchingStatus: String?
    var storeUrl: String?
    var latitude: Double?
    var longitude: Double?
    var hashTag: Bool?
}