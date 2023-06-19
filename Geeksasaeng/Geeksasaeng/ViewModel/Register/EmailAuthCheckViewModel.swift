//
//  EmailAuthCheckViewModel.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/09.
//

import Foundation
import Alamofire

class EmailAuthCheckViewModel {
    // MEMO: - VM은 VC를 몰라야 함 / VC -> VM / 결합력
    public static func requestCheckEmailAuth(_ parameter: EmailAuthCheckInput, completion: @escaping (Bool, Int?) -> Void) {
        AF.request("https://geeksasaeng.shop/email/check", method: .post, parameters: parameter, encoder: JSONParameterEncoder.default, headers: nil)
            .validate()
            .responseDecodable(of: EmailAuthCheckModel.self) {
                response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess! {
                        print("DEBUG: 이메일 인증번호 확인 성공")
                        // 성공하면 휴대폰 인증 화면으로 넘어간다.
                    } else {
                        print("DEBUG: 이메일 인증번호 확인 실패", result)
                    }
                    completion(result.isSuccess!, result.result?.emailId)
                case .failure(let error):
                    print("DEBUG: 이메일 인증번호 확인 실패", error.localizedDescription)
                    completion(false, nil)
                }
            }
        
    }
}

