//
//  EmailAuthCheckViewModel.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/09.
//

import Foundation
import Alamofire

class EmailAuthCheckViewModel {
    // TODO: - VM은 VC를 몰라야 함 / VC -> VM / 결합력
    public static func requestCheckEmailAuth(_ viewController: AuthNumViewController, _ parameter: EmailAuthCheckInput) {
        AF.request("https://geeksasaeng.shop/email/check", method: .post, parameters: parameter, encoder: JSONParameterEncoder.default, headers: nil)
            .validate()
            .responseDecodable(of: EmailAuthCheckModel.self) {
                response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess! {
                        print("DEBUG: 성공")
                        // 성공하면 휴대폰 인증 화면으로 넘어간다.
                        viewController.emailId = result.result?.emailId
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

