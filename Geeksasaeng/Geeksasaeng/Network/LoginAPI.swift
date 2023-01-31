//
//  LoginAPI.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/08/05.
//

import Foundation
import Alamofire

/* 자동 로그인 */
struct AutoLoginModel: Decodable {
    var code: Int?
    var isSuccess: Bool?
    var message: String?
    var result: AutoLoginModelResult?
}

struct AutoLoginModelResult: Decodable {
    var email: String?
    var loginId: String?
    var loginStatus: String?
    var memberId: Int?
    var memberLoginType: String?
    var nickname: String?
    var phoneNumber: String?
    var profileImgUrl: String?
    var universityName: String?
    var dormitoryId: Int?
    var dormitoryName: String?
}

/* 로그아웃 */
struct LogoutModel: Decodable {
    var code: Int?
    var isSuccess: Bool?
    var message: String?
    var result: String?
}

class LoginAPI {
    public static func attemptAutoLogin(jwt: String, completion: @escaping (AutoLoginModelResult) -> Void) {
        AF.request("https://geeksasaeng.shop/login/auto", method: .post,
                   headers: ["Authorization": "Bearer " + jwt])
            .validate()
            .responseDecodable(of: AutoLoginModel.self) { response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess! {
                        print("DEBUG: 자동 로그인 성공", result.result)
                        completion(result.result ?? AutoLoginModelResult())
                    } else {
                        print("DEBUG: 자동 로그인 실패", result.message!)
                    }
                case .failure(let error):
                    print("DEBUG: 자동 로그인 실패", error.localizedDescription)
                }
            }
    }
    
    public static func logout(completion: @escaping(Bool) -> Void) {
        let URL = "https://geeksasaeng.shop/logout"
        
        AF.request(URL, method: .delete, headers: ["Authorization": "Bearer " + (LoginModel.jwt ?? "")])
            .validate()
            .responseDecodable(of: LogoutModel.self) { response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess! {
                        print("DEBUG: 로그아웃 성공")
                        completion(true)
                    } else {
                        print("DEBUG: 로그아웃 실패", result.message!)
                        completion(false)
                    }
                case .failure(let error):
                    print("DEBUG: 로그아웃 실패", error.localizedDescription)
                    completion(false)
                }
            }
    }
}
