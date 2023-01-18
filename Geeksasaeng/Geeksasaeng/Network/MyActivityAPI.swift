//
//  MyActivityAPI.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2023/01/17.
//

import Foundation
import Alamofire

/* 나의 활동 목록 모델 */
struct MyActivityModel: Codable {
    let code: Int?
    let isSuccess: Bool?
    let message: String?
    let result: MyActivityModelResult?
}
struct MyActivityModelResult: Codable {
    let endedDeliveryPartiesVoList: [EndedDeliveryPartyList]?
    let finalPage: Bool?
}
struct EndedDeliveryPartyList: Codable {
    let foodCategory: String?
    let id, maxMatching: Int?
    let title, updatedAt: String?
}

class MyActivityAPI {
    // 나의 활동 목록 불러오기
    public static func getMyActivityList(cursor: Int, completion: @escaping (Bool, MyActivityModelResult?) -> Void) {
        let url = "https://geeksasaeng.shop/delivery-parties/end"
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (LoginModel.jwt ?? "")]
        
        // Query String을 통해 요청
        let parameters: Parameters = [
            "cursor": cursor
        ]
        
        AF.request(url,
                   method: .get,
                   parameters: parameters,
                   headers: headers)
        .validate()
        .responseDecodable(of: MyActivityModel.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("DEBUG: 나의 활동 목록 불러오기 성공")
                } else {
                    print("DEBUG: 나의 활동 목록 불러오기 실패", result.message!)
                }
                completion(result.isSuccess!, result.result)
            case .failure(let error):
                print("DEBUG: 나의 활동 목록 불러오기 실패", error.localizedDescription)
            }
        }
    }
}
