//
//  DeliveryListDetailViewModel.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/21.
//

import UIKit
import Alamofire

class getDetailInfoResult {
    var chief: String?
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
}

class DeliveryListDetailViewModel {
    public static func getDetailInfo(viewController: PartyViewController, _ partyId : Int) {
        AF.request("https://geeksasaeng.shop/delivery-party/\(partyId)", method: .get, parameters: nil,
        headers: ["Authorization": "Bearer eyJ0eXBlIjoiand0IiwiYWxnIjoiSFMyNTYifQ.eyJqd3RJbmZvIjp7InVuaXZlcnNpdHlJZCI6MSwidXNlcklkIjoyNn0sImlhdCI6MTY1Nzk0MTQ4NiwiZXhwIjoxNjU4ODMwNTE5fQ.n9HFrLuc97GeWOcKo-ffAj-k5XAvcd7IH0iEuOVzPaQ"])
        .validate()
        .responseDecodable(of: DeliveryListDetailModel.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("DEBUG: 디테일 정보 불러오기 성공")
                    
                    // 프로퍼티에 저장 -> profileImgUrl 수정 필요
                    if let result = result.result {
                        if let chief = result.chief,
                           let content = result.content,
                           let currentMatching = result.currentMatching,
                           let foodCategory = result.foodCategory,
                           let hashTag = result.hashTag,
                           let id = result.id,
                           let latitude = result.latitude,
                           let longitude = result.longitude,
                           let matchingStatus = result.matchingStatus,
                           let maxMatching = result.maxMatching,
                           let orderTime = result.orderTime,
                           let title = result.title,
                           let updatedAt = result.updatedAt {
                            viewController.detailData.chief = chief
                            viewController.detailData.content = content
                            viewController.detailData.currentMatching = currentMatching
                            viewController.detailData.foodCategory = foodCategory
                            viewController.detailData.hashTag = hashTag
                            viewController.detailData.id = id
                            viewController.detailData.latitude = latitude
                            viewController.detailData.longitude = longitude
                            viewController.detailData.matchingStatus = matchingStatus
                            viewController.detailData.maxMatching = maxMatching
                            viewController.detailData.orderTime = orderTime
                            viewController.detailData.title = title
                            viewController.detailData.updatedAt = updatedAt
                            if let chiefProfileImgUrl = result.chiefProfileImgUrl {
                                viewController.detailData.chiefProfileImgUrl = chiefProfileImgUrl
                            }
                        }
                    }
                    
                    viewController.setDefaultValue()
                    
                } else {
                    print("DEBUG:", result.message!)
                }
            case .failure(let error):
                print("DEBUG:", error.localizedDescription)
            }
        }
    }
}
