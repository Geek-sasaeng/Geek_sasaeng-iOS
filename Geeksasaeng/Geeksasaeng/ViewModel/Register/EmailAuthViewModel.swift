//
//  EmailAuthViewModel.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/08.
//

import Foundation
import Alamofire

// 이메일로 인증번호 전송하는 API 연동
class EmailAuthViewModel {
    
    public static func requestSendEmail(_ parameter : EmailAuthInput, completion: @escaping (EmailAuthModel?) -> ()) {
        AF.request("https://geeksasaeng.shop/email", method: .post,
                   parameters: parameter, encoder: JSONParameterEncoder.default, headers: nil)
        .validate()
        .responseDecodable(of: EmailAuthModel.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("DEBUG: 이메일 전송 성공", result.message!)
                } else {
                    print("DEBUG: 이메일 전송 실패", result.message!)
                }
                completion(result)
            case .failure(let error):
                print("DEBUG: 이메일 전송 실패", error.localizedDescription)
                completion(nil)
            }
        }
    }
}
