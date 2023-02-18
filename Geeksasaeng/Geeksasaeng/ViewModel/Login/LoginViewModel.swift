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
    public static func login(_ parameter : LoginInput, completion: @escaping (LoginOutput?) -> Void) {
        AF.request("https://geeksasaeng.shop/login", method: .post,
                   parameters: parameter, encoder: JSONParameterEncoder.default, headers: nil)
        .validate()
        .responseDecodable(of: LoginOutput.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("DEBUG: 일반 로그인 성공", result)
                } else {
                    print("DEBUG: 일반 로그인 실패", result)
                }
                completion(result)
            case .failure(let error):
                print("DEBUG: 일반 로그인 실패", error.localizedDescription)
                completion(nil)
            }
        }
    }
    
    // TODO: - viewController를 넘기지 않는 방식으로 변경 필요.
    /* loginNaver는 네아로에서 제공하는 메서드에서 호출 중이라 일단 보류 */
    public static func loginNaver(viewController: LoginViewController, _ parameter : NaverLoginInput) {
        AF.request("https://geeksasaeng.shop/login/social", method: .post,
                   parameters: parameter, encoder: JSONParameterEncoder.default, headers: nil)
        .validate()
        .responseDecodable(of: LoginOutput.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    LoginModel.jwt = result.result?.jwt
                    LoginModel.nickname = result.result?.nickName
                    LoginModel.profileImgUrl = result.result?.profileImgUrl
                    LoginModel.memberId = result.result?.memberId
                    
                    if result.result?.loginStatus == "NEVER" { // 사용자는 등록되어 있으나 첫 로그인 -> 기숙사 선택화면으로 이동
                        print("DEBUG: 네이버 로그인 성공", result.result)
                        print("DEBUG: \(result.code!)")
                        viewController.showDormitoryView(nickname: result.result?.nickName ?? "홍길동")
                    } else { // 로그인 성공 -> 홈 화면으로 이동
                        viewController.dormitoryInfo = DormitoryNameResult(id: result.result?.dormitoryId, name: result.result?.dormitoryName)
                        viewController.userImageUrl = result.result?.profileImgUrl
                        viewController.showHomeView()
                    }
                    
                } else {
                    // 네이버 로그인 실패
                    print(result.code!)
                    print("DEBUG: 네이버 로그인 실패", result.result)
                    
                    if result.code == 2807 { // 아예 첫 로그인 -> 회원가입 화면으로 이동
                        viewController.accessToken = parameter.accessToken
                        viewController.showNaverRegisterView()
                    }
                }
            case .failure(let error):
                print("DEBUG: 네이버 로그인 실패", error.localizedDescription)
            }
        }
    }
}

enum ResponseCase {
    case success
    case onlyRequestSuccess
    case failure
}
