//
//  UniversityListViewModel.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/10.
//

import Foundation
import Alamofire

class UniversityListViewModel {
    public static func requestGetUnivList(_ viewController: EmailAuthViewController) {
        AF.request("https://geeksasaeng.shop/universities", method: .get, parameters: nil)
            .validate()
            .responseDecodable(of: UniversityNameModel.self) {
                response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess! {
                        print("DEBUG: 성공")
                        // TODO: 테스트 필요... 명세서대로 했는데 지금 에러남
//                        print(result.result?.name)
                    } else {
                        print("DEBUG: 실패", result.message!)
                    }
                case .failure(let error):
                    print("DEBUG:", error.localizedDescription)
                }
            }
        
    }
}

