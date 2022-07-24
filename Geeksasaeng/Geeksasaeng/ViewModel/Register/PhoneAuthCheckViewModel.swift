//
//  PhoneAuthCheckViewModel.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/08.
//

import Foundation
import Alamofire

class PhoneAuthCheckViewModel {
    public static func requestCheckPhoneAuth(_ viewController: PhoneAuthViewController, _ parameter: PhoneAuthCheckInput) {
        AF.request("https://geeksasaeng.shop/sms/verification", method: .post, parameters: parameter, encoder: JSONParameterEncoder.default, headers: nil)
            .validate()
            .responseDecodable(of: PhoneAuthCheckModel.self) {
                response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess! {
                        print("DEBUG: 성공")
                        viewController.phoneNumberId = result.result?.phoneNumberId
                        // 성공하면 이용 약관 화면으로 넘어간다.
                        viewController.showNextView()
                    } else {
                        print("DEBUG: 실패", result.message!)
                        viewController.showToast(viewController: viewController, message: result.message ?? "인증번호 확인이 실패했습니다.", font: .customFont(.neoMedium, size: 15), color: UIColor(hex: 0xA8A8A8))
                    }
                case .failure(let error):
                    print("DEBUG:", error.localizedDescription)
                    viewController.showToast(viewController: viewController, message: "인증번호를 다시 확인해 주세요.", font: .customFont(.neoMedium, size: 15), color: UIColor(hex: 0xA8A8A8))
                }
            }
        
    }
}
