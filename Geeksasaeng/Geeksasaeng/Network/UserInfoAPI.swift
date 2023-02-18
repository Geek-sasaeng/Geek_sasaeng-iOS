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
    var nickname: String?
}
struct Dormitory: Decodable {
    var dormitoryId: Int?
    var dormitoryName: String?
}

/* 회원정보 수정 POST를 위한 모델 */
struct EditUserInput: Encodable {
    var dormitoryId: Int?
    var nickname: String?
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

/* 비밀번호 수정 */
struct EditPasswordInput: Encodable {
    var checkNewPassword: String?
    var newPassword: String?
}
struct EditPasswordModel: Decodable {
    var code: Int?
    var isSuccess: Bool?
    var message: String?
    var result: String?
}

/* 나의 활동 목록 모델 */
struct MyActivityModel: Codable {
    let code: Int?
    let isSuccess: Bool?
    let message: String?
    let result: MyActivityModelResult?
}
struct MyActivityModelResult: Codable {
    let endedDeliveryPartiesVoList: [EndedDeliveryPartyList]?
    let finalPage: Bool?
}
struct EndedDeliveryPartyList: Codable {
    let foodCategory: String?
    let id, matchingCount: Int?
    let title, updatedAt: String?
}

/* 회원 탈퇴 */
struct MemberDeleteModel: Decodable {
    var code: Int?
    var isSuccess: Bool?
    var message: String?
    var result: String?
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
            "dormitoryId": parameter.dormitoryId!,
            "nickname": parameter.nickname!
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
    
    public static func editPassword(_ parameter: EditPasswordInput, completion: @escaping (Bool) -> Void) {
        let URL = "https://geeksasaeng.shop/members/password"
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (LoginModel.jwt ?? "")]
        
        AF.request(URL, method: .patch, parameters: parameter, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .responseDecodable(of: EditPasswordModel.self) { response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess! {
                        print("DEBUG: 비밀번호 변경 성공")
                        completion(true)
                    } else {
                        print("DEBUG: 비밀번호 변경 실패", result.message!)
                        completion(false)
                    }
                case .failure(let error):
                    print("DEBUG: 비밀번호 변경 실패", error.localizedDescription)
                    completion(false)
                }
            }
        
    }
    
    
    // 나의 활동 목록 불러오기
    public static func getMyActivityList(cursor: Int, completion: @escaping (Bool, MyActivityModelResult?) -> Void) {
        let url = "https://geeksasaeng.shop/delivery-parties/end"
        let headers: HTTPHeaders = ["Authorization": "Bearer " + (LoginModel.jwt ?? "")]
        
        // Query String을 통해 요청
        let parameters: Parameters = [
            "cursor": cursor
        ]
        
        AF.request(url,
                   method: .get,
                   parameters: parameters,
                   headers: headers)
        .validate()
        .responseDecodable(of: MyActivityModel.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("DEBUG: 나의 활동 목록 불러오기 성공")
                } else {
                    print("DEBUG: 나의 활동 목록 불러오기 실패", result.message!)
                }
                completion(result.isSuccess!, result.result)
            case .failure(let error):
                print("DEBUG: 나의 활동 목록 불러오기 실패", error.localizedDescription)
            }
        }
    }
    
    // 회원탈퇴 API
    public static func deleteMember(memberId: Int, completion: @escaping (Bool) -> Void) {
        let url = "https://geeksasaeng.shop/members/account-delete"
        
        AF.request(url, method: .patch, parameters: nil, headers: ["Authorization": "Bearer " + (LoginModel.jwt ?? "")])
            .validate()
            .responseDecodable(of: MemberDeleteModel.self) { response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess! {
                        print("DEBUG: 회원 탈퇴 성공")
                        completion(true)
                    } else {
                        print("DEBUG: 회원 탈퇴 실패")
                        completion(false)
                    }
                case .failure(let error):
                    print("회원 탈퇴 실패", error.localizedDescription)
                    completion(false)
                }
            }
    }
    
}
