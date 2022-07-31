//
//  SearchViewModel.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/31.
//

import Foundation
import Alamofire

/* 검색 API 호출 */
class SearchViewModel {
    
    /* 검색어(키워드)를 포함한 배달파티 목록 조회 */
    // escaping을 통해 이 함수를 호출한 부분의 클로저로 결과 값을 넘겨줌 -> 호출한 VC에서 처리 가능해짐
    public static func requestDeliveryListByKeyword(cursor: Int, dormitoryId: Int, keyword: String,
                                                    maxMatching: Int? = nil, orderTimeCategory: String? = nil,
                                                    completion: @escaping (DeliveryListModelResultList) -> Void) {
        let url = "https://geeksasaeng.shop/\(dormitoryId)/delivery-parties/keyword"
        var parameters: Parameters = [
            "cursor": cursor,
            "keyword": keyword
        ]
        
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
        
        DispatchQueue.global().asyncAfter(deadline: .now() + ((cursor == 0) ? 0 : 1), execute: {
            AF.request(url, method: .get, parameters: parameters,
                       encoding: URLEncoding(destination: .queryString), headers: ["Authorization": "Bearer " + (LoginModel.jwt ?? "") ])
            .validate()
            .responseDecodable(of: DeliveryListModel.self) { response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess! {
                        print("DEBUG: 검색된 배달 목록 데이터 받아오기 성공")
                        
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
