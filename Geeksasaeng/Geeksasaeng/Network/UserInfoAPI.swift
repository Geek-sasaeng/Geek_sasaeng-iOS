//
//  UserInfoAPI.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/08/18.
//

import Foundation
import Alamofire

/* 회원정보 화면을 위한 모델 */
struct UserInfoModel: Decodable {
    var code: Int?
    var isSuccess: Bool?
    var message: String?
    var result: UserInfoModelResult?
}
struct UserInfoModelResult: Decodable {
    var createdAt: String?
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
    var parties: [UserInfoPartiesModel]?
}
struct UserInfoPartiesModel: Decodable {
    var id: Int?
    var title: String?
    var createdAt: String?
}

/* 회원정보 수정 시 비밀번호 확인을 위한 모델 */
struct PasswordCheckInput: Encodable {
    var password: String?
}
struct PasswordCheckModel: Decodable {
    var code: Int?
    var isSuccess: Bool?
    var message: String?
    var result: String?
}

/* 회원정보 수정화면을 위한 모델 */
struct EditUserInfoModel: Decodable {
    var code: Int?
    var isSuccess: Bool?
    var message: String?
    var result: EditUserInfoModelResult?
}
struct EditUserInfoModelResult: Decodable {
    var dormitoryId: Int?
    var dormitoryList: [Dormitory]?
    var dormitoryName: String?
    var imgUrl: String?
    var loginId: String?
    var nickname: String?
}
struct Dormitory: Decodable {
    var dormitoryId: Int?
    var dormitoryName: String?
}

/* 회원정보 수정 POST를 위한 모델 */
struct EditUserInput: Encodable {
    var checkPassword: String?
    var dormitoryId: Int?
    var loginId: String?
    var nickname: String?
    var password: String?
}
struct EditUserModel: Decodable {
    var code: Int?
    var isSuccess: Bool?
    var message: String?
    var result: EditUserModelResult?
}
struct EditUserModelResult: Decodable {
    var dormitoryId: Int?
    var dormitoryName: String?
    var loginId: String?
    var nickname: String?
    var profileImgUrl: String?
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
                    completion(result.isSuccess!, result.result!)
                }
            case .failure(let error):
                print("DEBUG:", error.localizedDescription)
            }
        }
    }
    
    public static func passwordCheck(_ parameter: PasswordCheckInput, completion: @escaping (Bool) -> Void) {
        AF.request("https://geeksasaeng.shop/members/password", method: .post ,parameters: parameter, encoder: JSONParameterEncoder.default, headers: ["Authorization": "Bearer " + (LoginModel.jwt ?? "")])
            .validate()
            .responseDecodable(of: PasswordCheckModel.self) { response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess! {
                        print("DEBUG: 비밀번호 일치")
                        completion(true)
                    } else {
                        completion(false)
                        print("DEBUG: 비밀번호 불일치")
                    }
                case .failure(let error):
                    print("DEBUG: ", error.localizedDescription)
                    completion(false)
                }
            }
    }
    
    public static func getEditUserInfo(completion: @escaping (Bool, EditUserInfoModelResult) -> Void) {
        AF.request("https://geeksasaeng.shop/members/info", method: .get, parameters: nil,
        headers: ["Authorization": "Bearer " + (LoginModel.jwt ?? "")])
        .validate()
        .responseDecodable(of: EditUserInfoModel.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("DEBUG: 유저 정보 불러오기 성공")
                    completion(result.isSuccess!, result.result!)
                } else {
                    print("DEBUG:", result.message!)
                    completion(false, EditUserInfoModelResult()) // 비어있는 객체 return
                }
            case .failure(let error):
                print("DEBUG:", error.localizedDescription)
                completion(false, EditUserInfoModelResult())
            }
        }
    }
    
    public static func editUser(_ parameter: EditUserInput, imageData: UIImage, completion: @escaping (Bool, EditUserModelResult) -> Void) {
        let URL = "https://geeksasaeng.shop/members/info"
        let header : HTTPHeaders = [
            "Content-Type" : "multipart/form-data",
            "Authorization": "Bearer " + (LoginModel.jwt ?? "")
        ]
        let parameters: [String: Any] = [
            "checkPassword": parameter.checkPassword!,
            "dormitoryId": parameter.dormitoryId!,
            "loginId": parameter.loginId!,
            "nickname": parameter.nickname!,
            "password": parameter.password!
        ]
        
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
            if let image = imageData.pngData() {
                print("pngData success")
                multipartFormData.append(image, withName: "profileImg", fileName: "\(image).png", mimeType: "image/png")
            }
        }, to: URL, usingThreshold: UInt64.init(), method: .post, headers: header).validate().responseDecodable(of: EditUserModel.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("DEBUG: 사용자 정보 수정 성공")
                    completion(true, result.result!)
                } else {
                    completion(false, result.result!)
                    print("DEBUG: 사용자 정보 수정 실패")
                }
            case .failure(let error):
                print("DEBUG: ", error.localizedDescription)
                completion(false, EditUserModelResult())
            }
        }
    }
}
