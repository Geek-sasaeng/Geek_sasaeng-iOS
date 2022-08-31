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
    public static func registerUser(_ viewController : AgreementViewController, _ parameter : RegisterInput) {
        AF.request("https://geeksasaeng.shop/members", method: .post,
                   parameters: parameter, encoder: JSONParameterEncoder.default, headers: nil)
        .validate()
        .responseDecodable(of: RegisterModel.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("DEBUG: 회원가입 성공")
                    
                    // 일반 회원가입은 완료한 이후 로그인 화면으로 이동.
                    viewController.showLoginView()
                } else {
                    print("DEBUG:", result.message!)
                }
            case .failure(let error):
                print("DEBUG:", error.localizedDescription)
            }
        }
    }
    
    public static func registerUserFromNaver(_ viewController : AgreementViewController, _ parameter : NaverRegisterInput) {
        AF.request("https://geeksasaeng.shop/members/social", method: .post,
                   parameters: parameter, encoder: JSONParameterEncoder.default, headers: nil)
        .validate()
        .responseDecodable(of: NaverRegisterModel.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("DEBUG: 회원가입 성공")
                    // 네이버 회원가입은 자동 로그인이 default
                    UserDefaults.standard.set(result.result?.jwt, forKey: "jwt")
                    LoginModel.jwt = result.result?.jwt
                    viewController.showDomitoryView()
                } else {
                    print("DEBUG:", result.message!)
                }
            case .failure(let error):
                print("DEBUG:", error.localizedDescription)
            }
        }
    }
}
