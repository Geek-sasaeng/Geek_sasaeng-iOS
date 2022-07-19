//
//  CreatePartyViewModel.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/17.
//

import UIKit
import Alamofire

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
    static var hashTagEatTogether: Int?
    static var hashTagOrderAsSoonAsMatch: Int?
    static var location: String?
}

// delivery-parties API Request Input
struct CreatePartyInput: Encodable {
    var dormitory: Int?
    var title: String?
    var content: String?
    var orderTime: String?
    var maxMatching: Int?
    var foodCategory: Int?
    var location: String?
    var hashTag: [Int]?
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
    var hashTag: [String]?
    var createdAt: String?
    var orderTimeCategoryType: String?
    var currentMatching: Int?
    var maxMatching: Int?
    var location: String?
    var matchingStatus: String
}

class CreatePartyViewModel {
    public static func registerParty(_ parameter : CreatePartyInput) {
        AF.request("https://geeksasaeng.shop/delivery-party", method: .post,
                   parameters: parameter, encoder: JSONParameterEncoder.default,
                   headers: [
                    "Authorization": "Bearer eyJ0eXBlIjoiand0IiwiYWxnIjoiSFMyNTYifQ.eyJqd3RJbmZvIjp7InVuaXZlcnNpdHlJZCI6MSwidXNlcklkIjoyNn0sImlhdCI6MTY1Nzk0MTQ4NiwiZXhwIjoxNjU4ODMwNTE5fQ.n9HFrLuc97GeWOcKo-ffAj-k5XAvcd7IH0iEuOVzPaQ"
                   ])
        .validate()
        .responseDecodable(of: CreatePartyModel.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("DEBUG: 파티생성 성공")
                    
                } else {
                    print("DEBUG:", result.message!)
                }
            case .failure(let error):
                print("DEBUG:", error.localizedDescription)
            }
        }
    }
}
