//
//  DeletePartyViewModel.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/24.
//

import UIKit
import Alamofire

class DeletePartyViewModel {
    public static func deleteParty(partyId : Int) {
        AF.request("https://geeksasaeng.shop/delivery-party/\(partyId)", method: .patch, parameters: nil,
                   headers: ["Authorization": "Bearer " + (LoginModel.jwt ?? "")])
        .validate()
        .responseDecodable(of: DeletePartyModel.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("DEBUG: 파티 삭제 성공")
                    
                } else {
                    print("DEBUG:", result.message!)
                }
            case .failure(let error):
                print("DEBUG:", error.localizedDescription)
            }
        }
    }
}
