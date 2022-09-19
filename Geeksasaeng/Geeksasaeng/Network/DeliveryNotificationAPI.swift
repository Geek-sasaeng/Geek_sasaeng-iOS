//
//  DeliveryNotificationAPI.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/09/16.
//

import Foundation
import Alamofire

struct DeliveryNotificationInput: Encodable {
    var uuid: String?
}

struct DeliveryNotificationModel: Decodable {
    var code: Int?
    var isSuccess: Bool?
    var message: String?
    var result: String?
}

/* 배달 완료 푸시알림 전송 API 연동 */
class DeliveryNotificationAPI {
    public static func requestPushNotification(_ parameter: DeliveryNotificationInput) {
        AF.request("https://geeksasaeng.shop/delivery-party/complicated", method: .post, parameters: parameter, encoder: JSONParameterEncoder.default, headers: ["Authorization": "Bearer " + (LoginModel.jwt ?? "")])
            .validate()
            .responseDecodable(of: DeliveryNotificationModel.self) {
                response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess! {
                        guard let realResult = result.result else {
                            return
                        }
                        print("DEBUG: 성공", realResult, result.message)
                    } else {
                        print("DEBUG: 실패", response, result)
                    }
                case .failure(let error):
                    print("DEBUG:", error.localizedDescription)
                }
            }
        
    }
}

