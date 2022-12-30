//
//  ChatAPI.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/12/18.
//

import Foundation
import Alamofire

/* 채팅방 사진 전송 API의 Request body */
struct ChatImageSendInput: Encodable {
    var chatId: String?
    var chatRootId: String?
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

class ChatAPI {
    public static func sendImage(_ parameter: ChatImageSendInput, imageData: UIImage, completion: @escaping (Bool) -> Void) {
        let URL = "https://geeksasaeng.shop/party-chat-room/chatimage"
        let header : HTTPHeaders = [
            "Content-Type" : "multipart/form-data",
            "Authorization": "Bearer " + (LoginModel.jwt ?? "")
        ]
        let parameters: [String: Any] = [
            "chatId": parameter.chatId!,
            "chatRootId": parameter.chatRootId!,
            "chatType": parameter.chatType!,
            "content": parameter.content!,
            "email": parameter.email!,
            "isImageMessage": parameter.isImageMessage!,
            "isSystemMessage": parameter.isSystemMessage!,
            "profileImgUrl": parameter.profileImgUrl!
        ]
        
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
}
