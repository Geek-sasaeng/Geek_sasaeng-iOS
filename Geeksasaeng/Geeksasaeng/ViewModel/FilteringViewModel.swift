//
//  FilteringViewModel.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/17.
//

import Foundation
import Alamofire

/* 필터링된 배달 목록을 가져오는 API 호출 */
class FilteringViewModel {
    
    // escaping을 통해 이 함수를 호출한 부분의 클로저로 결과 값을 넘겨줌 -> 호출한 VC에서 처리 가능해짐
    /* 인원수 필터링된 배달 목록 데이터를 불러온다 */
    public static func requestGetPeopleFilter(cursor: Int, dormitoryId: Int, maxMatching: Int, completion: @escaping (Result<DeliveryListModel, AFError>) -> Void) {
        let url = "https://geeksasaeng.shop/\(dormitoryId)/delivery-parties/\(maxMatching)"
        let parameters: Parameters = [
            "cursor": cursor
        ]
        
        // 데이터를 새로 읽어온다는 느낌을 주기 위해 1.5초 딜레이
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.5, execute: {
            AF.request(url, method: .get, parameters: parameters,
                       encoding: URLEncoding(destination: .queryString))
            .validate()
            .responseDecodable(of: DeliveryListModel.self) { response in
                // completion으로 result 넘겨줌
                completion(response.result)
            }
        })
    }
    
    /* 시간 필터링된 배달 목록 데이터를 불러온다 */
    public static func requestGetTimeFilter(cursor: Int, dormitoryId: Int, orderTimeCategory: String, completion: @escaping (Result<DeliveryListModel, AFError>) -> Void) {
        let url = "https://geeksasaeng.shop/\(dormitoryId)/delivery-parties/filter/\(orderTimeCategory)"
        let parameters: Parameters = [
            "cursor": cursor
        ]
        
        // 데이터를 새로 읽어온다는 느낌을 주기 위해 1.5초 딜레이
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.5, execute: {
            AF.request(url, method: .get, parameters: parameters,
                       encoding: URLEncoding(destination: .queryString))
            .validate()
            .responseDecodable(of: DeliveryListModel.self) { response in
                // completion으로 result 넘겨줌
                completion(response.result)
            }
        })
    }
}
