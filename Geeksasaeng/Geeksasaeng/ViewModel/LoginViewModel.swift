//
//  LoginManager.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/02.
//

import Alamofire

// 로그인 API 연동
class LoginViewModel {
    public func login(_ viewController : LoginViewController, _ parameter : LoginInput) {
        AF.request("https://geeksasaeng.shop/login", method: .post,
                   parameters: parameter, encoder: JSONParameterEncoder.default, headers: nil)
        .validate()
        .responseDecodable(of: LoginOutput.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("DEBUG: 성공")
                    // 자동로그인 체크 시 UserDefaults에 id, pw 저장
                    if viewController.automaticLoginButton.currentImage == UIImage(systemName: "checkmark.rectangle") {
                        UserDefaults.standard.set(parameter.loginId, forKey: "id")
                        UserDefaults.standard.set(parameter.password, forKey: "password")
                    }
                    
                    // static property에 jwt 값 저장
                    LoginModel.jwt = result.result?.jwt
                    
                    print("DEBUG: 로그인 성공", result.result)
                    
                    // 로그인 완료 후 경우에 따른 화면 전환
                    if result.result?.loginStatus == "NEVER" {
                        viewController.showNextView(isFirstLogin: true)
                    } else {
                        viewController.showNextView(isFirstLogin: false)
                    }
                    
                } else {
                    print("DEBUG:", result.message!)
                }
            case .failure(let error):
                print("DEBUG:", error.localizedDescription)
            }
        }
    }
}

// 첫 로그인이면 (DB에 정보 없으면) NaverRegisterVC로 이동
