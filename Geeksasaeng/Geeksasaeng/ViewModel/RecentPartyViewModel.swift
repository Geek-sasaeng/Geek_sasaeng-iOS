//
//  RecentPartyViewModel.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/08/18.
//

import Foundation
import Alamofire

/* 가장 최근에 참여한 배달파티 3개 조회 - 나의 정보 화면에서 사용 */
class RecentPartyViewModel {
    
    public static func requestGetRecentPartyList(completion: @escaping ([RecentPartyModelResult]) -> Void) {
        let url = "https://geeksasaeng.shop/delivery-parties/recent/ongoing"
        AF.request(url, method: .get, parameters: nil, headers: ["Authorization": "Bearer " + (LoginModel.jwt ?? "")])
            .validate()
            .responseDecodable(of: RecentPartyModel.self) {
                response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess! {
                        guard let result = result.result else {
                            return
                        }
                        
                        // 가장 위의 3개만 잘라와서 전달
                        var passedResult = result
                        
                        if passedResult.count > 3 {
                            let count = passedResult.count
                            passedResult.removeSubrange(3..<count)
                        }
                       
                        print("DEBUG: 최신 3개 불러오기 성공", passedResult)
                        completion(passedResult)
                    } else {
                        print("DEBUG: 최신 3개 불러오기 실패", result.message!)
                    }
                case .failure(let error):
                    print("DEBUG: 최신 3개 불러오기 실패", error.localizedDescription)
                }
            }
        
    }
}

