//
//  DeliveryListViewModel.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/14.
//

import Foundation
import Alamofire

/* 홈 화면 배달 목록 정보 받아오는 API 호출 */
class DeliveryListViewModel {
    
    public static func requestGetDeliveryList(_ viewController: DeliveryViewController, cursor: Int, dormitoryId: Int) {
        let url = "https://geeksasaeng.shop/\(dormitoryId)/delivery-parties"
        let parameters: Parameters = [
            "cursor": cursor
        ]

        AF.request(url, method: .get, parameters: parameters,
                   encoding: URLEncoding(destination: .queryString))
        .validate()
        .responseDecodable(of: DeliveryListModel.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("DEBUG: 배달 목록 데이터 받아오기 성공")
                    viewController.deliveryCellDataArray = result.result
                } else {
                    print("DEBUG: 실패", result.message!)
                }
            case .failure(let error):
                print("DEBUG:", error.localizedDescription)
            }
        }
    }
}
