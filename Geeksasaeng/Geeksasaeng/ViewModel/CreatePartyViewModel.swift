//
//  CreatePartyViewModel.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/17.
//

import UIKit
import Alamofire

class CreatePartyViewModel {
    public static func registerParty(_ parameter : CreatePartyInput) {
        AF.request("https://geeksasaeng.shop/delivery-party", method: .post,
                   parameters: parameter, encoder: JSONParameterEncoder.default,
                   headers: [
                    "Authorization": "Bearer eyJ0eXBlIjoiand0IiwiYWxnIjoiSFMyNTYifQ.eyJqd3RJbmZvIjp7InVuaXZlcnNpdHlJZCI6MSwidXNlcklkIjoyNn0sImlhdCI6MTY1Nzk0MTQ4NiwiZXhwIjoxNjU4ODMwNTE5fQ.n9HFrLuc97GeWOcKo-ffAj-k5XAvcd7IH0iEuOVzPaQ"
                   ])
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
