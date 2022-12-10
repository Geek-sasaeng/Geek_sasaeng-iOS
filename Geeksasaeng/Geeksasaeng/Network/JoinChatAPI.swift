//
//  JoinChatAPI.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/12/08.
//

import Foundation
import Alamofire

/* 채팅방 입장 API의 Request body */
struct JoinChatInput: Encodable {
    var partyChatRoomId: String?
}

/* 채팅방 입장 API의 Response */
struct JoinChatModel: Decodable {
    var code : Int?
    var isSuccess : Bool?
    var message : String?
    var result : JoinChatModelResult?
}
struct JoinChatModelResult: Decodable {
    var enterTime: String?
    var partyChatRoomId: String?
    var partyChatRoomMemberId: String?
    var remittance: Bool?
}

/* 채팅방 입장 API 연동 */
class JoinChatAPI {
    
    /* 파티장이 아닌 유저가 신청하기 눌렀을 때 유저를 채팅방의 멤버로 추가할 때 사용 */
    public static func requestJoinChat(_ parameter : JoinChatInput,
                                        completion: @escaping (Bool, JoinChatModelResult?) -> Void)
    {
        let url = "https://geeksasaeng.shop/party-chat-room/member"
        
        AF.request(url,
                   method: .post,
                   parameters: parameter,
                   encoder: JSONParameterEncoder.default,
                   headers: ["Authorization": "Bearer " + (LoginModel.jwt ?? "")])
        .validate()
        .responseDecodable(of: JoinChatModel.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("DEBUG: 채팅방 입장 성공", result)
                    completion(result.isSuccess!, result.result)
                } else {
                    print("DEBUG: 채팅방 입장 실패", result.message!)
                    completion(result.isSuccess!, nil)
                }
            case .failure(let error):
                print("DEBUG: 채팅방 입장 실패", error.localizedDescription)
                completion(false, nil)
            }
        }
    }
}
