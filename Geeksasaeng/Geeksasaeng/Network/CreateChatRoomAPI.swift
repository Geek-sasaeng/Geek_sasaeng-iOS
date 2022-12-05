//
//  CreateChatRoomAPI.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/12/05.
//

import Foundation
import Alamofire

/* 배달파티 채팅방 생성 API의 Request body */
struct CreateChatRoomInput : Encodable {
    var accountNumber: String?
    var bank: String?
    var category: String?
    var maxMatching: Int?
    var title: String?
}

/* 배달파티 채팅방 생성 API의 Response */
struct CreateChatRoomModel : Decodable {
    var code : Int?
    var isSuccess : Bool?
    var message : String?
    var result : CreateChatRoomModelResult?
}

struct CreateChatRoomModelResult: Decodable {
    var partyChatRoomId: String?
    var title: String?
}

/* 배달파티 채팅방 생성 API 연동 */
class CreateChatRoomAPI {
    
    /* 신고하기 버튼을 눌러서 파티 신고 요청 */
    public static func requestCreateChatRoom(_ input : CreateChatRoomInput,
                                             completion: @escaping (Bool, CreateChatRoomModelResult?) -> Void) {
        let url = "https://geeksasaeng.shop/party-chat-room"
        
        AF.request(url, method: .post,
                   parameters: input,
                   encoder: JSONParameterEncoder.default,
                   headers: ["Authorization": "Bearer " + (LoginModel.jwt ?? "")])
        .validate()
        .responseDecodable(of: CreateChatRoomModel.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("DEBUG: 채팅방 생성 성공", result)
                    completion(result.isSuccess!, result.result)
                } else {
                    print("DEBUG:", result.result!)
                    completion(result.isSuccess!, nil)
                }
            case .failure(let error):
                print("DEBUG:", error.localizedDescription)
                completion(false, nil)
            }
        }
    }
}
