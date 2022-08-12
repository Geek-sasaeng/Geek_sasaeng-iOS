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
    
    public static func requestSendEmail(_ parameter : EmailAuthInput, completion: @escaping (Bool, String) -> ()) {
        AF.request("https://geeksasaeng.shop/email", method: .post,
                   parameters: parameter, encoder: JSONParameterEncoder.default, headers: nil)
        .validate()
        .responseDecodable(of: EmailAuthModel.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("DEBUG: 성공", result.message!)
                    completion(result.isSuccess!, "인증번호가 전송되었습니다.")
                    
                } else {
                    print("DEBUG: 실패", result.message!)
                    completion(result.isSuccess!, "인증번호 전송이 실패했습니다.")
                }
            case .failure(let error):
                print("DEBUG:", error.localizedDescription)
                completion(false, "이메일 주소를 다시 확인해 주세요.")
            }
        }
    }
}
