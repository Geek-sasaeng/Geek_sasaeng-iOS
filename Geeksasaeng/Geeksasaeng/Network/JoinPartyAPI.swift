//
//  JoinPartyAPI.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/08/10.
//

import Foundation
import Alamofire

/* 배달파티 신청하기 API의 Request body */
struct JoinPartyInput: Encodable {
    var partyId: Int?
}

/* 신청하기 API의 Response */
struct JoinPartyModel: Decodable {
    var code : Int?
    var isSuccess : Bool?
    var message : String?
    var result : JoinPartyModelResult?
}
struct JoinPartyModelResult: Decodable {
    var deliveryPartyId: Int?
    var deliveryPartyMemberId: Int?
}

/* 배달파티 신청하기 API 연동 */
class JoinPartyAPI {
    
    /* 파티장이 아닌 유저가 신청하기 눌렀을 때 유저를 partyMember로 추가할 때 사용 */
    public static func requestJoinParty(_ parameter : JoinPartyInput,
                                        completion: @escaping (Bool) -> Void)
    {
        let url = "https://geeksasaeng.shop/delivery-party-member"
        
        AF.request(url, method: .post,
                   parameters: parameter, encoder: JSONParameterEncoder.default, headers: ["Authorization": "Bearer " + (LoginModel.jwt ?? "")])
        .validate()
        .responseDecodable(of: JoinPartyModel.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("DEBUG: 배달파티 신청 성공", result)
                    completion(result.isSuccess!)
                } else {
                    print("DEBUG: 배달파티 신청 실패", result.message!)
                    completion(result.isSuccess!)
                }
            case .failure(let error):
                print("DEBUG: 배달파티 신청 실패", error.localizedDescription)
                completion(false)
            }
        }
    }
}
