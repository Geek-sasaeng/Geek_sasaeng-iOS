//
//  CreatePartyViewModel.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/17.
//

import UIKit
import Alamofire

class CreatePartyViewModel {
    public static func registerParty(dormitoryId: Int, _ parameter : CreatePartyInput) {
        AF.request("https://geeksasaeng.shop/\(dormitoryId)/delivery-party", method: .post,
                   parameters: parameter, encoder: JSONParameterEncoder.default,
                   headers: ["Authorization": "Bearer " + (LoginModel.jwt ?? "")])
        .validate()
        .responseDecodable(of: CreatePartyModel.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("DEBUG: 파티생성 성공")
                    
                } else {
                    print("DEBUG:", result.message!)
                }
            case .failure(let error):
                print("DEBUG:", error.localizedDescription)
            }
        }
    }
}