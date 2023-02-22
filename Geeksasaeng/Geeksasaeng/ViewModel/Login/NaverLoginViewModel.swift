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
    
    // 토큰 삭제
    func requestDeleteToken() {
        naverLoginModel.naverLoginInstance?.requestDeleteToken()
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
        
        
    }

}
