//
//  NaverLoginViewModel.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/05.
//

import Alamofire
import NaverThirdPartyLogin

class naverLoginViewModel {
    let naverLoginModel = NaverLoginModel()
    
    func setInstanceDelegate(_ viewController: UIViewController) {
        naverLoginModel.naverLoginInstance?.delegate = viewController as? NaverThirdPartyLoginConnectionDelegate
    }
    
    func requestLogin() {
        naverLoginModel.naverLoginInstance?.requestThirdPartyLogin()
    }
    
    func returnToken() -> String {
        return naverLoginModel.naverLoginInstance?.accessToken ?? ""
    }
    
    func isExistToken() -> Bool {
        return naverLoginModel.isExistToken()
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
                
                if resultCode.trimmingCharacters(in: .whitespaces) == "success"{
                    let resultJson = body["response"] as! [String: Any]
                    
                    let phone = resultJson["mobile"] as! String
                    let email = resultJson["email"] as? String ?? ""
                    
                    print("네이버 로그인 핸드폰 ",phone)
                    print("네이버 로그인 이메일 ",email)
                    
                    /* 네이버 로그인 최초인지 확인 */
                    let input = LoginInput(loginId: email, password: "1q2w3e4r!")
                    LoginViewModel.loginNaver(viewController: viewController, input, id: email, phoneNumber: phone)
                    
                }
                else { // 실패
                    print("ERROR!")
                }
            }
        }
    }

}
