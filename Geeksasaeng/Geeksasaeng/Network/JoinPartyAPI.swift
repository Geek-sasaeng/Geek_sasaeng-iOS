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
    public static func requestJoinParty(_ parameter : JoinPartyInput, completion: @escaping () -> Void) {
        let url = "https://geeksasaeng.shop/deliveryPartyMember"
        
        AF.request(url, method: .post,
                   parameters: parameter, encoder: JSONParameterEncoder.default, headers: ["Authorization": "Bearer " + (LoginModel.jwt ?? "")])
        .validate()
        .responseDecodable(of: JoinPartyModel.self) { response in
            print("왜?", response)
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("DEBUG: 배달파티 신청(채팅방에 초대) 성공", result)
                    // 신청 성공했을 때만 completion 보내준다
                    completion()
                } else {
                    print("DEBUG:", result.message!)
                }
            case .failure(let error):
                print("DEBUG:", error.localizedDescription)
            }
        }
    }
}
