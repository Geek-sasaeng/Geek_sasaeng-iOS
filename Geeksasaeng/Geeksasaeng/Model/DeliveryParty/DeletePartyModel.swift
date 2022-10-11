//
//  DeletePartyModel.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/24.
//

import Foundation

struct DeletePartyModel: Decodable {
    var isSuccess: Bool?
    var code: Int?
    var message: String?
    var result: DeletePartyModelResult?
}

struct DeletePartyModelResult: Decodable {
    var deliveryPartyId: Int?
    var status: String?
}
