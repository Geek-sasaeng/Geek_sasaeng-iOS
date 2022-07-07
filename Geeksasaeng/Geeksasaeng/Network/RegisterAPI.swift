//
//  RegisterModel.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/02.
//

import Foundation
import Alamofire

// 회원가입을 요청했을 때 받게 될 Response의 형태.
struct RegisterModel : Decodable {
    var isSuccess : Bool?
    var code : Int?
    var message : String?
    var result : RegisterModelResult?
}

struct RegisterModelResult : Decodable {
    var loginId: String?
    var nickname: String?
    var universityName: String?
    var email: String?
    var phoneNumber: String?
}

// 회원가입을 완료했을 때 보낼 Request body의 형태.
struct RegisterInput : Encodable {
    var checkPassword: String?
    var email: String?
    var loginId: String?
    var nickname: String?
    var password: String?
    var phoneNumber: String?
    var universityName: String?
}

// 회원가입 API 연동
class RegisterAPI {
    public static func registerUser(_ viewController : EmailAuthViewController, _ parameter : RegisterInput) {
        AF.request("https://geeksasaeng.shop/members", method: .post,
                   parameters: parameter, encoder: JSONParameterEncoder.default, headers: nil)
        .validate()
        .responseDecodable(of: RegisterModel.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("DEBUG: 성공")
                } else {
                    print("DEBUG:", result.message!)
                }
            case .failure(let error):
                print("DEBUG:", error.localizedDescription)
            }
        }
    }
}
