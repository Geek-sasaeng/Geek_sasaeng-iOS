//
//  AutoLoginAPI.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/08/05.
//

import Foundation
import Alamofire

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
    var memberLoginType: String?
    var nickname: String?
    var phoneNumber: String?
    var profileImgUrl: String?
    var universityName: String?
    var dormitoryId: Int?
    var dormitoryName: String?
    var userImageUrl: String?
}

class AutoLoginAPI {
    public static func attemptAutoLogin(jwt: String, completion: @escaping (AutoLoginModelResult) -> Void) {
        AF.request("https://geeksasaeng.shop/login/auto", method: .post,
                   headers: ["Authorization": "Bearer " + jwt])
            .validate()
            .responseDecodable(of: AutoLoginModel.self) { response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess! {
                        print("DEBUG: 자동 로그인 성공")
                        completion(result.result ?? AutoLoginModelResult())
                    } else {
                        print("DEBUG: 자동 로그인 실패", result.message!)
                    }
                case .failure(let error):
                    print("DEBUG: 자동 로그인 실패", error.localizedDescription)
                }
            }
    }
}
