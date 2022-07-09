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
    
    public static func requestSendPhoneAuth(_ viewController : PhoneAuthViewController, _ parameter : PhoneAuthInput) {
        AF.request("https://geeksasaeng.shop/sms", method: .post,
                   parameters: parameter, encoder: JSONParameterEncoder.default, headers: nil)
        .validate()
        .responseDecodable(of: PhoneAuthModel.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("DEBUG: 성공")
                    // 성공했을 때에 성공했다는 토스트 메세지 출력
                    viewController.showToast(viewController: viewController, message: "인증번호가 전송되었습니다.", font: .customFont(.neoMedium, size: 15))
                } else {
                    print("DEBUG: 실패", result.message!)
                    viewController.showToast(viewController: viewController, message: result.message ?? "인증번호 전송이 실패했습니다.", font: .customFont(.neoMedium, size: 15))
                }
            case .failure(let error):
                print("DEBUG:", error.localizedDescription)
                viewController.showToast(viewController: viewController, message: "핸드폰 번호를 다시 확인해 주세요.", font: .customFont(.neoMedium, size: 15))
            }
        }
    }
}
