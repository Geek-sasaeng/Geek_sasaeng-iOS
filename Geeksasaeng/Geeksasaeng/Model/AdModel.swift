//
//  AdModel.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/17.
//

import Foundation

// API Response
struct AdModel: Decodable {
    var code: Int?
    var isSuccess: Bool?
    var message: String?
    var result: [AdModelResult]?
}

struct AdModelResult: Decodable {
    var id: Int?
    var imgUrl: String?
}
