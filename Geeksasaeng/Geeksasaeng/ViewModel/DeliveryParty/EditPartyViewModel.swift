//
//  EditPartyViewModel.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/23.
//

import UIKit
import Alamofire

class EditPartyViewModel {
    public static func editParty(dormitoryId: Int, partyId: Int, chatRoomId: String, _ parameter : EditPartyInput, completion: @escaping (Bool) -> Void) {
        AF.request("https://geeksasaeng.shop/\(dormitoryId)/delivery-party/\(partyId)/\(chatRoomId)", method: .put,
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
