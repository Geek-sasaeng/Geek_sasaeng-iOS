//
//  CloseMatchingAPI.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/08/14.
//

import Foundation
import Alamofire

/* 매칭 수동 마감 API의 Request body */
struct CloseMatchingInput: Encodable {
    var uuid: String?
}

/* 매칭 수동 마감 API의 Response */
struct CloseMatchingModel: Decodable {
    var code : Int?
    var isSuccess : Bool?
    var message : String?
    var result : CloseMatchingModelResult?
}
struct CloseMatchingModelResult: Decodable {
    var deliveryPartyId: Int?
    var matchingStatus: String?
}

/* 수동 매칭 마감 API 연동 */
class CloseMatchingAPI {
    
    /* 매칭 마감 API 호출 함수 */
    public static func requestCloseMatching(_ parameter: CloseMatchingInput, completion: @escaping (Bool) -> Void) {
        guard let roomUUID = parameter.uuid else { return }
        let url = "https://geeksasaeng.shop/delivery-party/\(roomUUID)/matching-status"
        
        AF.request(url, method: .patch, parameters: nil, headers: ["Authorization": "Bearer " + (LoginModel.jwt ?? "")])
        .validate()
        .responseDecodable(of: CloseMatchingModel.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("DEBUG: 수동 매칭 마감 성공")
                } else {
                    print("DEBUG:", result.message!)
                }
                completion(result.isSuccess!)
            case .failure(let error):
                print("DEBUG:", error.localizedDescription)
                completion(false)
            }
        }
    }
}
