//
//  ChatAPI.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/12/18.
//

import Foundation
import Alamofire

/* 채팅방 사진 전송 */
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
struct ChatImageSendModel: Decodable {
    var code : Int?
    var isSuccess : Bool?
    var message : String?
    var result : String?
}

/* 주문 완료 */
struct orderCompletedInput: Encodable {
    var roomId: String?
}
struct orderCompletedModel: Decodable {
    var code: Int?
    var isSuccess: Bool?
    var message: String?
    var result: String?
}

/* 방장 퇴장 */
struct exitChiefInput: Encodable {
    var roomId: String?
}
struct exitChiefModel: Decodable {
    var code: Int?
    var isSuccess: Bool?
    var message: String?
    var result: exitChiefModelResult?
}
struct exitChiefModelResult: Decodable {
    var message: String?
}

/* 파티원 퇴장 */
struct exitMemberInput: Encodable {
    var roomId: String?
}
struct exitMemberModel: Decodable {
    var code: Int?
    var isSuccess: Bool?
    var message: String?
    var result: exitMemberModelResult?
}
struct exitMemberModelResult: Decodable {
    var message: String?
}

/* 송금 완료 */
struct CompleteRemittanceInput: Encodable {
    var roomId: String?
}
struct CompleteRemittanceModel: Decodable {
    var code: Int?
    var isSuccess: Bool?
    var message: String?
    var result: String?
}


class ChatAPI {
    /* 이미지 전송 */
    public static func sendImage(_ parameter: ChatImageSendInput, imageData: [UIImage], completion: @escaping (Bool) -> Void) {
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
            
            imageData.forEach { image in
                if let pngImage = image.pngData() {
                    multipartFormData.append(pngImage, withName: "images", fileName: "\(pngImage).png", mimeType: "image/png")
                }
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
    
    /* 주문 완료 */
    public static func orderCompleted(_ parameter: orderCompletedInput, completion: @escaping (Bool) -> Void) {
        let URL = "https://geeksasaeng.shop/party-chat-room/order"
        AF.request(URL, method: .patch, parameters: parameter, encoder: JSONParameterEncoder.default,
                   headers: ["Authorization": "Bearer " + (LoginModel.jwt ?? "")])
        .validate()
        .responseDecodable(of: orderCompletedModel.self) { response in
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
    
    /* 방장 나가기 */
    public static func exitChief(_ parameter: exitChiefInput, completion: @escaping (Bool) -> Void) {
        let URL = "https://geeksasaeng.shop/party-chat-room/chief"
        AF.request(URL, method: .patch, parameters: parameter, encoder: JSONParameterEncoder.default,
        headers: ["Authorization": "Bearer " + (LoginModel.jwt ?? "")])
        .validate()
        .responseDecodable(of: exitChiefModel.self) { response in
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
    
    /* 파티원 나가기 */
    public static func exitMember(_ parameter: exitMemberInput, completion: @escaping (Bool) -> Void) {
        let URL = "https://geeksasaeng.shop/party-chat-room/members/self"
        AF.request(URL, method: .delete, parameters: parameter, encoder: JSONParameterEncoder.default,
        headers: ["Authorization": "Bearer " + (LoginModel.jwt ?? "")])
        .validate()
        .responseDecodable(of: exitMemberModel.self) { response in
            switch response.result {
            case .success(let result):
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
    
    /* 송금 완료 */
    public static func completeRemittance(_ parameter: CompleteRemittanceInput, completion: @escaping (Bool) -> Void) {
        let URL = "https://geeksasaeng.shop/party-chat-room/members/remittance"
        AF.request(URL, method: .patch, parameters: parameter, encoder: JSONParameterEncoder.default,
        headers: ["Authorization": "Bearer " + (LoginModel.jwt ?? "")])
        .validate()
        .responseDecodable(of: CompleteRemittanceModel.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("송금 완료")
                    completion(true)
                } else {
                    print("송금 완료 실패")
                    completion(false)
                }
            case .failure(let error):
                print("DEBUG: ", error.localizedDescription)
                completion(false)
            }
        }
    }
}


