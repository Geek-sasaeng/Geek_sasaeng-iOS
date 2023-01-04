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
    public static func login(_ parameter : LoginInput, completion: @escaping (ResponseCase, LoginModelResult?, String?) -> Void) {
        AF.request("https://geeksasaeng.shop/login", method: .post,
                   parameters: parameter, encoder: JSONParameterEncoder.default, headers: nil)
        .validate()
        .responseDecodable(of: LoginOutput.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    guard let passedResult = result.result else { return }
                    print("DEBUG: 성공")
                    completion(.success, passedResult, nil)
                } else {
                    completion(.onlyRequestSuccess, nil, result.message!)
                }
            case .failure(let error):
                print("DEBUG:", error.localizedDescription)
                completion(.failure, nil, "로그인 요청에 실패하였습니다")
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
                    LoginModel.userImgUrl = result.result?.userImageUrl
                    LoginModel.memberId = result.result?.memberId
                    
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

enum ResponseCase {
    case success
    case onlyRequestSuccess
    case failure
}
