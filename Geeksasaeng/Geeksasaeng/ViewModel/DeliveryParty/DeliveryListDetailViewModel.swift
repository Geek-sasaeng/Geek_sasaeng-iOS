//
//  DeliveryListDetailViewModel.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/21.
//

import UIKit
import Alamofire

class DeliveryListDetailViewModel {
    
    public static func getDetailInfo(partyId : Int, completion: @escaping (DeliveryListDetailModelResult?, String) -> Void) {
        AF.request("https://geeksasaeng.shop/delivery-party/\(partyId)", method: .get, parameters: nil,
                   headers: ["Authorization": "Bearer " + (LoginModel.jwt ?? "")])
        .validate()
        .responseDecodable(of: DeliveryListDetailModel.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("DEBUG: 디테일 정보 불러오기 성공")
                    // 성공 시에 completion에 result 전달
                    completion(result.result!, "success")
                } else {
                    print("DEBUG: 디테일 정보 불러오기 실패", result.message!)
                    completion(nil, result.message!)
                }
            case .failure(let error):
                print("DEBUG: 디테일 정보 불러오기 실패", error.localizedDescription)
                completion(nil, "failure")
            }
        }
    }
}
