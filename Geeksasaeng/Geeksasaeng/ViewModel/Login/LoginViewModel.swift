//
//  LoginManager.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/02.
//

import Alamofire

// 자동로그인 체크 -> jwt 로컬에 저장 -> attempAutoLogin: header에 jwt 넣어서 API 호출

// 로그인 API 연동
class LoginViewModel {
    public static func login(_ viewController: LoginViewController, _ parameter : LoginInput, completion: @escaping (LoginModelResult) -> Void) {
        AF.request("https://geeksasaeng.shop/login", method: .post,
                   parameters: parameter, encoder: JSONParameterEncoder.default, headers: nil)
        .validate()
        .responseDecodable(of: LoginOutput.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    guard let passedResult = result.result else { return }
                    print("DEBUG: 성공")
                    completion(passedResult)
                } else {
                    print("DEBUG:", result.message!)
                    viewController.showBottomToast(viewController: viewController, message: result.message!, font: .customFont(.neoMedium, size: 15), color: .lightGray)
                }
            case .failure(let error):
                print("DEBUG:", error.localizedDescription)
            }
        }
    }
    
    public static func loginNaver(viewController: LoginViewController, _ parameter : NaverLoginInput) {
        AF.request("https://geeksasaeng.shop/login/social", method: .post,
                   parameters: parameter, encoder: JSONParameterEncoder.default, headers: nil)
        .validate()
        .responseDecodable(of: NaverLoginOutput.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    LoginModel.jwt = result.result?.jwt
                    LoginModel.nickname = result.result?.nickName
                    LoginModel.userImgUrl = result.result?.userImageUrl
                    
                    if result.result?.loginStatus == "NEVER" { // 사용자는 등록되어 있으나 첫 로그인 -> 기숙사 선택화면으로 이동
                        print("DEBUG: 성공")
                        print("DEBUG: \(result.code!)")
                        viewController.showDormitoryView(nickname: result.result?.nickName ?? "홍길동")
                    } else { // 로그인 성공 -> 홈 화면으로 이동
                        viewController.dormitoryInfo = DormitoryNameResult(id: result.result?.dormitoryId, name: result.result?.dormitoryName)
                        viewController.userImageUrl = result.result?.userImageUrl
                        viewController.showHomeView()
                    }
                    
                } else {
                    // 네이버 로그인 실패
                    print(result.code!)
                    print("DEBUG:", result.message!)
                    
                    if result.code == 2807 { // 아예 첫 로그인 -> 회원가입 화면으로 이동
                        viewController.accessToken = parameter.accessToken
                        viewController.showNaverRegisterView()
                    }
                }
            case .failure(let error):
                print("DEBUG:", error.localizedDescription)
            }
        }
    }
}
