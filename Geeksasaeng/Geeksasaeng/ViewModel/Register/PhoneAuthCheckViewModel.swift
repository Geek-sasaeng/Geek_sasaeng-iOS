//
//  PhoneAuthCheckViewModel.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/08.
//

import Foundation
import Alamofire

class PhoneAuthCheckViewModel {
    public static func requestCheckPhoneAuth(_ parameter: PhoneAuthCheckInput, completion: @escaping (ResponseCase, PhoneAuthCheckResult?, String?) -> Void) {
        AF.request("https://geeksasaeng.shop/sms/verification", method: .post, parameters: parameter, encoder: JSONParameterEncoder.default, headers: nil)
            .validate()
            .responseDecodable(of: PhoneAuthCheckModel.self) {
                response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess! {
                        print("DEBUG: 성공")
                        guard let passedResult = result.result else { return }
                        completion(.success, passedResult, nil)
                    } else {
                        print("DEBUG: 실패", result.message!)
                        completion(.onlyRequestSuccess, nil, result.message!)
                    }
                case .failure(let error):
                    print("DEBUG:", error.localizedDescription)
                    completion(.failure, nil, "인증번호를 다시 확인해 주세요")
                }
            }
        
    }
}

