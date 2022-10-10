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
    public static func requestCheckEmailAuth(_ parameter: EmailAuthCheckInput, completion: @escaping (Bool, Int) -> Void) {
        AF.request("https://geeksasaeng.shop/email/check", method: .post, parameters: parameter, encoder: JSONParameterEncoder.default, headers: nil)
            .validate()
            .responseDecodable(of: EmailAuthCheckModel.self) {
                response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess! {
                        print("DEBUG: 성공")
                        // 성공하면 휴대폰 인증 화면으로 넘어간다.
                        guard let data = result.result?.emailId else { return }
                        completion(true, data)
                    } else {
                        print("DEBUG: 실패", result.message!)
                        completion(false, 0)
                    }
                case .failure(let error):
                    print("DEBUG:", error.localizedDescription)
                    completion(false, 0)
                }
            }
        
    }
}

