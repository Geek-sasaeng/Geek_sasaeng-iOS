//
//  CompleteDeliveryModel.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2023/01/20.
//

import Foundation

// 배달 완료 API에 필요한 모델
struct CompleteDeliveryInput: Encodable {
    var roomId: String?
}

struct CompleteDeliveryModel: Decodable {
    var code: Int?
    var isSuccess: Bool?
    var message: String?
    var result: String?
}
