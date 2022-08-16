//
//  ChatRoomExitAPI.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/08/14.
//

import Foundation
import Alamofire

struct ChatRoomExitInput: Encodable {
    var uuid: String?
}

struct ChatRoomExitForCheifInput: Encodable {
    var nickName: String?
    var uuid: String?
}

struct ChatRoomExitModel: Decodable {
    var isSuccess: Bool?
    var code: Int?
    var message: String?
    var result: String?
}

struct ChatRoomExitForCheifModel: Decodable {
    var isSuccess: Bool?
    var code: Int?
    var message: String?
    var result: ChatRoomExitForCheifModelResult?
}

struct ChatRoomExitForCheifModelResult: Decodable {
    var result: String?
}

class ChatRoomExitAPI {
    public static func patchExitUser(_ parameter: ChatRoomExitInput) {
        AF.request("https://geeksasaeng.shop/delivery-party/member", method: .patch, parameters: parameter, encoder: JSONParameterEncoder.default,
        headers: ["Authorization": "Bearer " + (LoginModel.jwt ?? "")])
        .validate()
        .responseDecodable(of: ChatRoomExitModel.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("DEBUG: 방장이 아닌 사용자 나가기 성공", result.result!)
                } else {
                    print("DEBUG: ", result.message!)
                }
            case .failure(let error):
                print("DEBUG:", error.localizedDescription)
            }
        }
    }
    
    public static func patchExitCheif(_ parameter: ChatRoomExitForCheifInput) {
        AF.request("https://geeksasaeng.shop/delivery-party/chief", method: .patch, parameters: parameter, encoder: JSONParameterEncoder.default,
        headers: ["Authorization": "Bearer " + (LoginModel.jwt ?? "")])
        .validate()
        .responseDecodable(of: ChatRoomExitForCheifModel.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("DEBUG: 방장인 사용자 나가기 성공", result.result!)
                } else {
                    print("DEBUG: ", result.message!)
                }
            case .failure(let error):
                print("DEBUG:", error.localizedDescription)
            }
        }
    }
}
