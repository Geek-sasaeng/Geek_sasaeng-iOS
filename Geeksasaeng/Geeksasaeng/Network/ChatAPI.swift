//
//  ChatAPI.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/12/18.
//

import Foundation
import Alamofire

/* 채팅방 사진 전송 API req */
struct ChatImageSendInput: Encodable {
    var chatId: String?
    var chatRoomId: String?
    var chatType: String?
    var content: String?
    var email: String?
    var isImageMessage: Bool?
    var isSystemMessage: Bool?
    var profileImgUrl: String?
}

/* 채팅방 사진 전송 API의 Response */
struct ChatImageSendModel: Decodable {
    var code : Int?
    var isSuccess : Bool?
    var message : String?
    var result : String?
}


/* 주문 완료 API req */
struct OrderCompletedInput: Encodable {
    var roomId: String?
}

/* 주문 완료 API res */
struct OrderCompletedModel: Decodable {
    var code: Int?
    var isSuccess: Bool?
    var message: String?
    var result: String?
}

/* 방장 퇴장 API req */
struct ExitChiefInput: Encodable {
    var roomId: String?
}

/* 방장 퇴장 API res */
struct ExitChiefModel: Decodable {
    var code: Int?
    var isSuccess: Bool?
    var message: String?
    var result: ExitChiefModelResult?
}

struct ExitChiefModelResult: Decodable {
    var message: String?
}

/* 파티원 퇴장 API req */
struct ExitMemberInput: Encodable {
    var roomId: String?
}

struct ExitMemberModel: Decodable {
    var code: Int?
    var isSuccess: Bool?
    var message: String?
    var result: ExitMemberModelResult?
}

struct ExitMemberModelResult: Decodable {
    var message: String?
}

class ChatAPI {
    
    // 채팅방 상세조회 API 연동
    public static func getChattingRoomInfo(_ parameter: ChattingRoomInput, completion: @escaping (ChattingRoomResult?) -> (Void)) {
        guard let roomId = parameter.chatRoomId else { return }
        let URL = "https://geeksasaeng.shop/party-chat-room/\(roomId)"
        AF.request(URL,
                   method: .get,
                   parameters: nil,
                   headers: ["Authorization": "Bearer " + (LoginModel.jwt ?? "")])
        .validate()
        .responseDecodable(of: ChattingRoomModel.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("DEBUG: 채팅방 상세조회 성공")
                    // result 값을 탈출 클로저를 통해 전달
                    completion(result.result)
                } else {
                    print("DEBUG: 채팅방 상세조회 실패", result.message!)
                    completion(nil)
                }
            case .failure(let error):
                print("DEBUG: 채팅방 상세조회 실패", error.localizedDescription)
                completion(nil)
            }
        }
    }
    
    public static func sendImage(_ parameter: ChatImageSendInput, imageData: UIImage, completion: @escaping (Bool) -> Void) {
        let URL = "https://geeksasaeng.shop/party-chat-room/chatimage"
        let header : HTTPHeaders = [
            "Content-Type" : "multipart/form-data",
            "Authorization": "Bearer " + (LoginModel.jwt ?? "")
        ]
        let parameters: [String: Any] = [
            "chatId": parameter.chatId!,
            "chatRoomId": parameter.chatRoomId!,
            "chatType": parameter.chatType!,
            "content": parameter.content!,
            "email": parameter.email!,
            "isImageMessage": parameter.isImageMessage!,
            "isSystemMessage": parameter.isSystemMessage!,
            "profileImgUrl": parameter.profileImgUrl!
        ]
        
        print("==========", parameters)
        
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
            if let image = imageData.pngData() {
                multipartFormData.append(image, withName: "images", fileName: "\(image).png", mimeType: "image/png")
            }
        }, to: URL, usingThreshold: UInt64.init(), method: .post, headers: header).validate().responseDecodable(of: ChatImageSendModel.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("DEBUG: 이미지 업로드 성공", result.message!)
                    completion(true)
                } else {
                    completion(false)
                    print("DEBUG: 이미지 업로드 실패", result.message!)
                }
            case .failure(let error):
                print("DEBUG: ", error.localizedDescription)
                completion(false)
            }
        }
    }
    
    public static func orderCompleted(_ parameter: OrderCompletedInput, completion: @escaping (Bool) -> Void) {
        let URL = "https://geeksasaeng.shop/party-chat-room/order"
        AF.request(URL, method: .patch, parameters: parameter, encoder: JSONParameterEncoder.default,
                   headers: ["Authorization": "Bearer " + (LoginModel.jwt ?? "")])
        .validate()
        .responseDecodable(of: OrderCompletedModel.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("주문완료 처리 성공")
                    completion(true)
                } else {
                    print("DEBUG: ", result.message!)
                    completion(false)
                }
            case .failure(let error):
                print("DEBUG: ", error.localizedDescription)
                completion(false)
            }
        }   
    }
    
    public static func exitChief(_ parameter: ExitChiefInput, completion: @escaping (Bool) -> Void) {
        let URL = "https://geeksasaeng.shop/party-chat-room/chief"
        AF.request(URL, method: .patch, parameters: parameter, encoder: JSONParameterEncoder.default,
        headers: ["Authorization": "Bearer " + (LoginModel.jwt ?? "")])
        .validate()
        .responseDecodable(of: ExitChiefModel.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("방장 퇴장 완료")
                    completion(true)
                } else {
                    print("DEBUG: ", result.message!)
                    completion(false)
                }
            case .failure(let error):
                print("DEBUG: ", error.localizedDescription)
                completion(false)
            }
        }
    }
    
    public static func exitMember(_ parameter: ExitMemberInput, completion: @escaping (Bool) -> Void) {
        let URL = "https://geeksasaeng.shop/party-chat-room/members/self"
        AF.request(URL, method: .delete, parameters: parameter, encoder: JSONParameterEncoder.default,
        headers: ["Authorization": "Bearer " + (LoginModel.jwt ?? "")])
        .validate()
        .responseDecodable(of: ExitMemberModel.self) { response in
            switch response.result {
            case . success(let result):
                if result.isSuccess! {
                    print("파티원 퇴장 완료")
                    completion(true)
                } else {
                    print("DEBUG: ", result.message!)
                    completion(false)
                }
            case .failure(let error):
                print("DEBUG: ", error.localizedDescription)
                completion(false)
            }
        }
    }
}


