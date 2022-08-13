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

struct ChatRoomExitModel: Decodable {
    var isSuccess: Bool?
    var code: Int?
    var message: String?
    var result: String?
}

class ChatRoomExitAPI {
    public static func patchExitUser(_ parameter: ChatRoomExitInput) {
        AF.request("https://geeksasaeng.shop/delivery-party/leave", method: .patch, parameters: parameter, encoder: JSONParameterEncoder.default,
        headers: ["Authorization": "Bearer " + (LoginModel.jwt ?? "")])
        .validate()
        .responseDecodable(of: ChatRoomExitModel.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("DEBUG: ", result.result!)
                } else {
                    print("DEBUG: ", result.message!)
                }
            case .failure(let error):
                print("DEBUG:", error.localizedDescription)
            }
        }
    }
    
//    public static func patchExitCheif(_ parameter: ChatRoomExitInput) {
//
//    }
}
