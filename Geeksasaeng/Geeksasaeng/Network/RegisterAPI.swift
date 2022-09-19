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
    var emailId: Int?
    var loginId: String?
    var nickname: String?
    var phoneNumberId: Int?
    var universityName: String?
}

// 회원가입을 완료할 때 보낼 Request body의 형태.
struct RegisterInput : Encodable {
    var checkPassword: String?
    var emailId: Int?
    var informationAgreeStatus: String?
    var loginId: String?
    var nickname: String?
    var password: String?
    var phoneNumberId: Int?
    var universityName: String?
}

struct NaverRegisterInput: Encodable {
    var accessToken: String?
    var email: String?
    var informationAgreeStatus: String?
    var nickname: String?
    var universityName: String?
}

struct NaverRegisterModel: Decodable {
    var code: Int?
    var isSuccess: Bool?
    var message: String?
    var result: NaverRegisterModelResult?
}

struct NaverRegisterModelResult: Decodable {
    var email: Int?
    var loginId: String?
    var nickname: String?
    var phoneNumber: Int?
    var universityName: String?
    var jwt: String?
}


// 회원가입 API 연동
class RegisterAPI {
    public static func registerUser(_ parameter : RegisterInput, completion: @escaping (ResponseCase) -> Void) {
        AF.request("https://geeksasaeng.shop/members", method: .post,
                   parameters: parameter, encoder: JSONParameterEncoder.default, headers: nil)
        .validate()
        .responseDecodable(of: RegisterModel.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("DEBUG: 회원가입 성공")
                    completion(.success)
                } else {
                    completion(.onlyRequestSuccess)
                    print("DEBUG:", result.message!)
                }
            case .failure(let error):
                completion(.failure)
                print("DEBUG:", error.localizedDescription)
            }
        }
    }
    
    public static func registerUserFromNaver(_ parameter : NaverRegisterInput, completion: @escaping (ResponseCase, NaverRegisterModelResult?) -> Void) {
        AF.request("https://geeksasaeng.shop/members/social", method: .post,
                   parameters: parameter, encoder: JSONParameterEncoder.default, headers: nil)
        .validate()
        .responseDecodable(of: NaverRegisterModel.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("DEBUG: 회원가입 성공")
                    guard let passedResult = result.result else { return }
                    completion(.success, passedResult)
                } else {
                    print("DEBUG:", result.message!)
                    completion(.onlyRequestSuccess, nil)
                }
            case .failure(let error):
                print("DEBUG:", error.localizedDescription)
                completion(.failure, nil)
            }
        }
    }
}
