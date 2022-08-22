//
//  UserInfoAPI.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/08/18.
//

import Foundation
import Alamofire

struct UserInfoModel: Decodable {
    var isSuccess: Bool?
    var code: Int?
    var message: String?
    var result: UserInfoModelResult?
}

struct UserInfoModelResult: Decodable {
    var id: Int?
    var loginId: String?
    var nickname: String?
    var universityId: Int?
    var universityName: String?
    var emailId: Int?
    var emailAddress: String?
    var phoneNumber: String?
    var profileImgUrl: String?
    var informationAgreeStatus: String?
    var dormitoryId: Int?
    var dormitoryName: String?
    var loginStatus: String?
    var memberLoginType: String?
    var perDayReportingCount: Int?
    var reportedCount: Int?
    var fcmToken: String?
}

class UserInfoAPI {
    public static func getUserInfo(completion: @escaping (Bool, UserInfoModelResult) -> Void) {
        AF.request("https://geeksasaeng.shop/members", method: .get, parameters: nil,
        headers: ["Authorization": "Bearer " + (LoginModel.jwt ?? "")])
        .validate()
        .responseDecodable(of: UserInfoModel.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("DEBUG: 유저 정보 불러오기 성공")
                    completion(result.isSuccess!, result.result!)
                } else {
                    print("DEBUG:", result.message!)
                }
            case .failure(let error):
                print("DEBUG:", error.localizedDescription)
            }
        }
    }
}
