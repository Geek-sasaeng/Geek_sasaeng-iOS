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
    public static func requestGetDeliveryList(isInitial: Bool, cursor: Int, dormitoryId: Int, completion: @escaping (Result<DeliveryListModel, AFError>) -> Void) {
        let url = "https://geeksasaeng.shop/\(dormitoryId)/delivery-parties"
        let parameters: Parameters = [
            "cursor": cursor
        ]
        
        // 배달 목록 부분을 처음 킨 거면 딜레이 없이 바로 보여주고, 아니면 1.5초의 딜레이 시간을 줌
        DispatchQueue.global().asyncAfter(deadline: .now() + (isInitial ? 0 : 1.5) , execute: {
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
