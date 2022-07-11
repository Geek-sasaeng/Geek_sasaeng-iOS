//
//  RepetitionAPI.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/10.
//

import Foundation
import Alamofire

/* 아이디 중복 확인 */
struct IdRepetitionInput: Encodable {
    var loginId: String?
}

struct IdRepetitionModel: Decodable {
    var code: Int?
    var isSuccess: Bool?
    var message: String?
}


/* 닉네임 중복 확인 */
struct NickNameRepetitionInput: Encodable {
    var nickName: String
}

struct NickNameRepetitionModel: Decodable {
    var code: Int?
    var isSuccess: Bool?
    var message: String?
}

class RepetitionAPI {
        public static func checkIdRepetition(_ viewController: RegisterViewController, parameters: IdRepetitionInput) {
            AF.request("https://geeksasaeng.shop/members/id-duplicated", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: nil)
                .validate()
                .responseDecodable(of: IdRepetitionModel.self) { response in
                    switch response.result {
                    case .success(let result):
                        if result.isSuccess! {
                            print("DEBUG: 성공")
                            viewController.idAvailableLabel.text = result.message
                            viewController.idAvailableLabel.textColor = .mainColor
                            viewController.idAvailableLabel.isHidden = false
                        } else {
                            print("DEBUG: 실패", result.message!)
                            viewController.idAvailableLabel.text = result.message
                            viewController.idAvailableLabel.textColor = .red
                            viewController.idAvailableLabel.isHidden = false
                        }
                    case .failure(let error):
                        print("DEBUG:", error.localizedDescription)
                    }
                }
        }

    
    public static func checkNicknameRepetition(_ viewController: RegisterViewController, parameters: NickNameRepetitionInput) {
        AF.request("https://geeksasaeng.shop/members/nickname-duplicated", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: nil)
            .validate()
            .responseDecodable(of: NickNameRepetitionModel.self) { response in
                switch response.result {
                case.success(let result):
                    if result.isSuccess! {
                        print("DEBUG: 성공")
                        viewController.nickNameAvailableLabel.text = result.message
                        viewController.nickNameAvailableLabel.textColor = .mainColor
                        viewController.nickNameAvailableLabel.isHidden = false
                    } else {
                        print("DEBUG: 실패", result.message!)
                        viewController.nickNameAvailableLabel.text = result.message
                        viewController.nickNameAvailableLabel.textColor = .red
                        viewController.nickNameAvailableLabel.isHidden = false
                    }
                case .failure(let error):
                    print("DEBUG: ", error.localizedDescription)
                }
            }
    }
}
