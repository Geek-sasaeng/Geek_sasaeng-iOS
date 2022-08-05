//
//  DormitoryAPI.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/08/04.
//

import Foundation
import Alamofire

struct DormitoryInput: Encodable {
    var dormitoryId: Int?
}

struct DormitoryModel: Decodable {
    var isSuccess: Bool?
    var code: Int?
    var message: String?
    var result: DormitoryModelResult?
}

struct DormitoryModelResult: Decodable {
    var id: Int?
    var dormitoryId: Int?
    var dormitoryName: String?
}

class DormitoryAPI {
    public static func patchDormitory(_ parameter: DormitoryInput) {
        AF.request("https://geeksasaeng.shop/members/dormitory", method: .patch, parameters: parameter, encoder: JSONParameterEncoder.default,
        headers: ["Authorization": "Bearer " + (LoginModel.jwt ?? "")])
        .validate()
        .responseDecodable(of: DormitoryModel.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("DEBUG: 기숙사 수정 성공")
                } else {
                    print("DEBUG:", result.message!)
                }
            case .failure(let error):
                print("DEBUG:", error.localizedDescription)
            }
        }
    }
}
