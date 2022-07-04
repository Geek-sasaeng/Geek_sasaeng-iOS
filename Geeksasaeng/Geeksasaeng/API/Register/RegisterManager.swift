//
//  RegisterManager.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/02.
//

import Alamofire

// 회원가입 API 연동
class RegisterManager {
    public static func registerUser(_ viewController : EmailAuthViewController, _ parameter : RegisterInput) {
        AF.request("https://geeksasaeng.shop/members", method: .post,
                   parameters: parameter, encoder: JSONParameterEncoder.default, headers: nil)
        .validate()
        .responseDecodable(of: RegisterModel.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("DEBUG: 성공")
                } else {
                    print("DEBUG:", result.message!)
                }
            case .failure(let error):
                print("DEBUG:", error.localizedDescription)
            }
        }
    }
}
