//
//  DormitoryNameModel.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/29.
//

import Foundation

// Response 결과값 받을 때
struct DormitoryNameModel: Decodable {
    var code: Int?
    var isSuccess: Bool?
    var message: String?
    var result: [DormitoryNameResult]?
}

struct DormitoryNameResult: Decodable {
    var id: Int?
    var name: String?
}
