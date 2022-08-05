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
}

class DeliveryListDetailViewModel {
    
    public static func getDetailInfo(partyId : Int, completion: @escaping (DeliveryListDetailModelResult) -> Void) {
        AF.request("https://geeksasaeng.shop/delivery-party/\(partyId)", method: .get, parameters: nil,
                   headers: ["Authorization": "Bearer " + (LoginModel.jwt ?? "")])
        .validate()
        .responseDecodable(of: DeliveryListDetailModel.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("DEBUG: 디테일 정보 불러오기 성공")
                    // 성공 시에 completion에 result 전달
                    completion(result.result!)
                    
                } else {
                    print("DEBUG:", result.message!)
                }
            case .failure(let error):
                print("DEBUG:", error.localizedDescription)
            }
        }
    }
}
