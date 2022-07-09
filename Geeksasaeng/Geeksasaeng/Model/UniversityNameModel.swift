//
//  UniversityNameModel.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/10.
//

import Foundation

// Response
struct UniversityNameModel: Decodable {
    var code: Int?
    var isSuccess: Bool?
    var message: String?
    var result: UniversityNameResult?
}

struct UniversityNameResult: Decodable {
    var createdAt: String?
    var updatedAt: String?
    var status: String?
    var id: Int?
    var name: String?
    var emailAddress: String?
    var universityImgUrl: String?
}
