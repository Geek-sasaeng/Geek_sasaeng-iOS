//
//  NaverLoginViewModel.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/05.
//

import Alamofire
import NaverThirdPartyLogin

class NaverLoginViewModel {
    let naverLoginModel = NaverLoginModel()
    
    // 토큰이 남아 있는지 확인
    func isValidAccessTokenExpireTimeNow() -> Bool {
        guard let instance = naverLoginModel.naverLoginInstance else { return false }
        return instance.isValidAccessTokenExpireTimeNow()
    }
    
    // 토큰 재발급
    func requestAccessTokenWithRefreshToken() {
        naverLoginModel.naverLoginInstance?.requestAccessTokenWithRefreshToken()
    }
    
    // 로그인 시도
    func requestLogin() {
        naverLoginModel.naverLoginInstance?.requestThirdPartyLogin()
    }
    
    // 토큰 삭제
    func resetToken() {
        naverLoginModel.naverLoginInstance?.resetToken()
    }
    
    func setInstanceDelegate(_ viewController: UIViewController) {
        naverLoginModel.naverLoginInstance?.delegate = viewController as? NaverThirdPartyLoginConnectionDelegate
    }
    
    func returnToken() -> String {
        return naverLoginModel.naverLoginInstance?.accessToken ?? ""
    }
    
    func naverLoginPaser(_ viewController: LoginViewController) {
        guard let accessToken = naverLoginModel.naverLoginInstance?.isValidAccessTokenExpireTimeNow() else { return }
        
        if !accessToken {
            return
        }
        
        guard let tokenType = naverLoginModel.naverLoginInstance?.tokenType else { return }
        guard let accessToken = naverLoginModel.naverLoginInstance?.accessToken else { return }
        
        let requestUrl = "https://openapi.naver.com/v1/nid/me"
        let url = URL(string: requestUrl)!
        
        let authorization = "\(tokenType) \(accessToken)"
        
        let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization])
        
        req.responseJSON { response in
            
            guard let body = response.value as? [String: Any] else { return }
            
            if let resultCode = body["message"] as? String {
                // 네이버에 로그인 할 떄 아이디가 DB에 등록이 안되어있으면 추가 회원가입 절차 진행 -> 가입하는 되는 순간 phone, email 정보와 함께 닉네임 설정 화면으로 이동 -> 닉네임 중복확인하고 학교 이메일 인증 화면으로 이동 -> phone, email, nickname, university 정보 업로드
                
                // 그니까 로그인 버튼 누르면 email, phone 정보 가져와서 기존 DB랑 비교하고 있으면 DB에 있는 사용자 정보 불러와서 로그인 완료, 홈 화면으로  <->  없으면 회원가입 화면으로
                
                if resultCode.trimmingCharacters(in: .whitespaces) == "success" {
                    let resultJson = body["response"] as! [String: Any]
                    
                    let phone = resultJson["mobile"] as! String
                    let email = resultJson["email"] as? String ?? ""
                    
                    print("네이버 로그인 핸드폰 ",phone)
                    print("네이버 로그인 이메일 ",email)
                    
                    /* 토큰으로 서버에 네이버 로그인 시도 */
                    print("==========", accessToken)
                    // fcm 등록토큰 값 불러오기
                    let fcmToken = UserDefaults.standard.string(forKey: "fcmToken")
                    print("DEBUG: fcmToken in NaverLoginVM", fcmToken ?? "")
                    let input = NaverLoginInput(accessToken: accessToken, fcmToken: "")
                    
                    MyLoadingView.shared.show()
                    LoginViewModel.loginNaver(viewController: viewController, input)
                }
                else { // 실패
                    print("ERROR!")
                    viewController.showToast(viewController: viewController, message: "로그인 실패! 다시 시도해 주세요", font: .customFont(.neoBold, size: 13), color: .init(hex: 0xA8A8A8), width: 229, height: 40)
                }
            }
        }
    }

}
