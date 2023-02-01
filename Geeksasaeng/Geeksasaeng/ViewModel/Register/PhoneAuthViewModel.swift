//
//  PhoneAuthViewModel.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/08.
//

import Foundation
import Alamofire

// 핸드폰 번호 인증 API 연동
class PhoneAuthViewModel {
    
    public static func requestSendPhoneAuth(_ parameter : PhoneAuthInput, completion: @escaping (PhoneAuthModel?) -> Void) {
        AF.request("https://geeksasaeng.shop/sms", method: .post,
                   parameters: parameter, encoder: JSONParameterEncoder.default, headers: nil)
        .validate()
        .responseDecodable(of: PhoneAuthModel.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("DEBUG: sms 전송 성공")
                } else {
                    print("DEBUG: sms 전송 실패", result.message!)
                }
                completion(result)
            case .failure(let error):
                print("DEBUG: sms 전송 실패", error.localizedDescription)
                completion(nil)
            }
        }
    }
}
