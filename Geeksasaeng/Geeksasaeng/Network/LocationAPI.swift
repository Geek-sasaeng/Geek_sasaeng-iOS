//
//  LocationAPI.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/21.
//

import UIKit
import Alamofire

struct LocationModel: Decodable {
    var code: Int?
    var isSuccess: Bool?
    var message: String?
    var result: LocationModelResult?
}

struct LocationModelResult: Decodable {
    var latitude: Double
    var longitude: Double
}

class LocationAPI {
    public static func getLocation(_ dormitoryId : Int) {
        AF.request("https://geeksasaeng.shop/\(dormitoryId)/default-location", method: .get, parameters: nil,
        headers: ["Authorization": "Bearer " + (LoginModel.jwt ?? "")])
        .validate()
        .responseDecodable(of: LocationModel.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("DEBUG: 기숙사 좌표 불러오기 성공")
                    
                    CreateParty.latitude = result.result?.latitude
                    CreateParty.longitude = result.result?.longitude
                } else {
                    print("DEBUG:", result.message!)
                }
            case .failure(let error):
                print("DEBUG:", error.localizedDescription)
            }
        }
    }
}

