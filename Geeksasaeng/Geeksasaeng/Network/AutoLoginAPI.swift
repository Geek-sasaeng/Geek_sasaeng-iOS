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
    public static func attemptAutoLogin(_ viewController: LoginViewController, jwt: String) {
        AF.request("https://geeksasaeng.shop/login/auto", method: .post,
                   headers: ["Authorization": "Bearer " + jwt])
            .validate()
            .responseDecodable(of: AutoLoginModel.self) { response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess! {
                        print("DEBUG: 성공")
                        
                        LoginModel.jwt = jwt
                        viewController.dormitoryInfo = DormitoryNameResult(id: result.result?.dormitoryId, name: result.result?.dormitoryName)
                        // userImageUrl 저장
                        viewController.userImageUrl = result.result?.userImageUrl
                        
                        print("DEBUG: 로그인 성공", result.result ?? "")
                        
                        // 로그인 완료 후 경우에 따른 화면 전환
                        if let result = result.result {
                            if result.loginStatus == "NEVER" {
                                viewController.showNextView(isFirstLogin: true, nickName: result.nickname ?? "홍길동")
                            } else {
                                viewController.showNextView(isFirstLogin: false)
                            }
                        }
                    } else {
                        print("DEBUG: 실패", result.message!)
                    }
                case .failure(let error):
                    print("DEBUG:", error.localizedDescription)
                }
            }
    }
}
