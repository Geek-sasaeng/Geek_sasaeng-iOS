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
    
    public static func requestSendEmail(_ viewController : UIViewController, _ parameter : EmailAuthInput) {
        AF.request("https://geeksasaeng.shop/members/email", method: .post,
                   parameters: parameter, encoder: JSONParameterEncoder.default, headers: nil)
        .validate()
        .responseDecodable(of: PhoneAuthModel.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("DEBUG: 성공", result.message!)
                    // 성공했을 때에 성공했다는 토스트 메세지 출력
                    viewController.showToast(viewController: viewController, message: "인증번호가 전송되었습니다.", font: .customFont(.neoMedium, size: 15), color: .mainColor)
                } else {
                    print("DEBUG: 실패", result.message!)
                    viewController.showToast(viewController: viewController, message: result.message ?? "인증번호 전송이 실패했습니다.", font: .customFont(.neoMedium, size: 15), color: UIColor(hex: 0xA8A8A8))
                }
            case .failure(let error):
                print("DEBUG:", error.localizedDescription)
                viewController.showToast(viewController: viewController, message: "이메일 주소를 다시 확인해 주세요.", font: .customFont(.neoMedium, size: 15), color: UIColor(hex: 0xA8A8A8))
            }
        }
    }
}
