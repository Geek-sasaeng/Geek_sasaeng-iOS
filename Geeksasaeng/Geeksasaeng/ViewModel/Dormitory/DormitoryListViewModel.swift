//
//  DormitoryListViewModel.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/28.
//

import Foundation
import Alamofire

/* 기숙사 리스트 조회 */
class DormitoryListViewModel {
    public static func requestGetDormitoryList(universityId: Int, completion: @escaping ([DormitoryNameResult]) -> Void) {
        AF.request("https://geeksasaeng.shop/\(universityId)/dormitories", method: .get, parameters: nil)
            .validate()
            .responseDecodable(of: DormitoryNameModel.self) {
                response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess! {
                        guard let result = result.result else {
                            return
                        }
                        completion(result)
                        print("DEBUG: 성공")
                        
                    } else {
                        print("DEBUG: 실패", result.message!)
                    }
                case .failure(let error):
                    print("DEBUG:", error.localizedDescription)
                }
            }
        
    }
}

