//
//  EditPartyViewModel.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/23.
//

import UIKit
import Alamofire

class EditPartyViewModel {
//    public static func EditParty(_ parameter : EditPartyInput, partyId: Int) {
//        AF.request("https://geeksasaeng.shop/delivery-party/\(partyId)", method: .put,
//                   parameters: parameter, encoder: JSONParameterEncoder.default,
//                   headers: ["Authorization": "Bearer " + (LoginModel.jwt ?? "")])
//        .validate()
//        .responseDecodable(of: EditPartyModel.self) { response in
//            switch response.result {
//            case .success(let result):
//                if result.isSuccess! {
//                    print("DEBUG: 파티수정 성공")
//
//                } else {
//                    print("DEBUG:", result.message!)
//                }
//            case .failure(let error):
//                print("DEBUG:", error.localizedDescription)
//            }
//        }
//    }
    
    public static func editParty(dormitoryId: Int, partyId: Int, _ parameter : EditPartyInput, completion: @escaping (Bool) -> Void) {
        AF.request("https://geeksasaeng.shop/\(dormitoryId)/delivery-party/\(partyId)", method: .put,
                   parameters: parameter, encoder: JSONParameterEncoder.default,
                   headers: ["Authorization": "Bearer " + (LoginModel.jwt ?? "")])
        .validate()
        .responseDecodable(of: EditPartyModel.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("DEBUG: 파티수정 성공")
                    completion(true)
                } else {
                    print("DEBUG:", result.message!)
                    completion(false)
                }
            case .failure(let error):
                print("DEBUG:", error.localizedDescription)
                completion(false)
            }
        }
    }
}
