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
    
    // escaping을 통해 이 함수를 호출한 부분의 클로저로 결과 값을 넘겨줌 -> 호출한 VC에서 처리 가능해짐
    public static func requestGetDeliveryList(cursor: Int, dormitoryId: Int, input: DeliveryListInput,
                                              completion: @escaping (DeliveryListModelResultList) -> Void) {
        let url = "https://geeksasaeng.shop/\(dormitoryId)/delivery-parties"
        var parameters: Parameters = [
            "cursor": cursor
        ]
        let orderTimeCategory = input.orderTimeCategory
        let maxMatching = input.maxMatching
        
        if let orderTimeCategory = orderTimeCategory,
           let maxMatching = maxMatching {
            print("DEBUG : 필터링 둘다 사용")
            parameters["orderTimeCategory"] = orderTimeCategory
            parameters["maxMatching"] = maxMatching
        }
        else if let orderTimeCategory = orderTimeCategory {
            print("DEBUG : 시간 필터링 사용")
            parameters["orderTimeCategory"] = orderTimeCategory
        }
        else if let maxMatching = maxMatching {
            print("DEBUG : 인원수 필터링 사용")
            parameters["maxMatching"] = maxMatching
        }
        print("DEBUG : 쿼리 스트링", parameters)
        
        // 새로고침 애니메이션을 보여주기 위해 0.5초의 딜레이를 둠
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5 , execute: {
            AF.request(url, method: .get, parameters: parameters,
                       encoding: URLEncoding(destination: .queryString), headers: ["Authorization": "Bearer " + (LoginModel.jwt ?? "") ])
            .validate()
            .responseDecodable(of: DeliveryListModel.self) { response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess! {
                        print("DEBUG: 배달 목록 데이터 받아오기 성공")
                        
                        // 성공 시에만 completion으로 result를 넘겨줌
                        if let resultData = result.result {
                            completion(resultData)
                        }
                    } else {
                        print("DEBUG:", result.message!)
                    }
                case .failure(let error):
                    print("DEBUG:", error.localizedDescription)
                }
            }
        })
    }
}
