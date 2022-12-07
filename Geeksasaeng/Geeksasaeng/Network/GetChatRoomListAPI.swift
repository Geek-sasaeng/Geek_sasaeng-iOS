//
//  GetChatRoomListAPI.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/12/05.
//

import Foundation
import Alamofire

/* 채팅방 목록 조회 API의 Response */
struct GetChatRoomListModel : Decodable {
    var code : Int?
    var isSuccess : Bool?
    var message : String?
    var result : GetChatRoomListModelResult?
}

struct GetChatRoomListModelResult: Decodable {
    var finalPage: Bool?
    var parties: [ChatRoomInfo]?
}

struct ChatRoomInfo: Decodable {
    var roomId: String?
    var roomTitle: String?
}

/* 채팅방 목록 조회 API 연동 */
class GetChatRoomListAPI {
    
    /* 채팅방 탭에 왔을 때 채팅방 목록 조회 요청 */
    public static func requestGetChatRoomList(cursor: Int,
                                             completion: @escaping (GetChatRoomListModel?, String?) -> Void)
    {
        let url = "https://geeksasaeng.shop/party-chat-room"
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (LoginModel.jwt ?? "")]
        
        // Query String을 통해 요청
        let parameters: Parameters = [
            "cursor": cursor
        ]
        
        AF.request(url,
                   method: .get,
                   parameters: parameters,
                   encoding: URLEncoding(destination: .queryString),
                   headers: headers)
        .validate()
        .responseDecodable(of: GetChatRoomListModel.self) { response in
            switch response.result {
            case .success(let model):
                if model.isSuccess! {
                    print("DEBUG: 채팅방 목록 조회 성공", model.result)
                    completion(model, nil)
                } else {
                    print("DEBUG: 채팅방 목록 조회 실패", model.message)
                    completion(nil, model.message)
                }
            case .failure(let error):
                print("DEBUG: 채팅방 목록 조회 실패", error.localizedDescription)
                completion(nil, "채팅방 목록을 불러오지 못했습니다.")
            }
        }
    }
}
