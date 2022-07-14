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
                    // 홈 화면으로 이동
                    viewController.showHomeView()
                    
                    // TODO: 첫 로그인 시에는 기숙사 선택 화면으로 이동하도록 설정 필요!
                } else {
                    print("DEBUG:", result.message!)
                }
            case .failure(let error):
                print("DEBUG:", error.localizedDescription)
            }
        }
    }
    
    public static func loginNaver(viewController: LoginViewController, _ parameter : LoginInput, id: String, phoneNumber: String) {
        AF.request("https://geeksasaeng.shop/login", method: .post,
                   parameters: parameter, encoder: JSONParameterEncoder.default, headers: nil)
        .validate()
        .responseDecodable(of: LoginOutput.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    // 네이버 아이디 비밀번호가 긱사생 DB에 등록되어 있으면
                    print("DEBUG: 성공")
                    print("DEBUG: \(result.code!)")
                    viewController.showHomeView()
                    
                } else {
                    // 네이버 아이디 비밀번호로 처음 로그인 한 경우
                    print(result.code!)
                    print("DEBUG:", result.message!)
                    print("회원가입 화면으로 이동합니다")
                    if result.code == 2400 {
                        viewController.showNaverRegisterView(id: id, phoneNum: phoneNumber)
                    } else {
                        print("DEBUG:", result.message!)
                    }
                }
            case .failure(let error):
                print("DEBUG:", error.localizedDescription)
            }
        }
    }
}

// 첫 로그인이면 (DB에 정보 없으면) NaverRegisterVC로 이동
