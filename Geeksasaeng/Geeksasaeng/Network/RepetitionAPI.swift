//
//  RepetitionAPI.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/10.
//

import Foundation
import Alamofire

/* 아이디 중복 확인 */
struct IdRepetitionInput: Encodable {
    var loginId: String?
}

struct IdRepetitionModel: Decodable {
    var code: Int?
    var isSuccess: Bool?
    var message: String?
}


/* 닉네임 중복 확인 */
struct NickNameRepetitionInput: Encodable {
    var nickName: String
}

struct NickNameRepetitionModel: Decodable {
    var code: Int?
    var isSuccess: Bool?
    var message: String?
}

class RepetitionAPI {
    public static func checkIdRepetition(_ parameters: IdRepetitionInput, completion: @escaping (ResponseCase, String) -> Void) {
            AF.request("https://geeksasaeng.shop/members/id-duplicated", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: nil)
                .validate()
                .responseDecodable(of: IdRepetitionModel.self) { response in
                    switch response.result {
                    case .success(let result):
                        if result.isSuccess! {
                            print("DEBUG: 성공")
                            completion(.success, result.message!)
                        } else {
                            print("DEBUG: 실패", result.message!)
                            completion(.onlyRequestSuccess, result.message!)
                        }
                    case .failure(let error):
                        print("DEBUG:", error.localizedDescription)
                        completion(.failure, "Failure")
                    }
                }
        }

    
    public static func checkNicknameRepetition(_ parameters: NickNameRepetitionInput, completion: @escaping (ResponseCase, String) -> Void) {
        AF.request("https://geeksasaeng.shop/members/nickname-duplicated", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: nil)
            .validate()
            .responseDecodable(of: NickNameRepetitionModel.self) { response in
                switch response.result {
                case.success(let result):
                    if result.isSuccess! {
                        print("DEBUG: 성공")
                        completion(.success, result.message!)
                    } else {
                        print("DEBUG: 실패", result.message!)
                        completion(.onlyRequestSuccess, result.message!)
                    }
                case .failure(let error):
                    print("DEBUG: ", error.localizedDescription)
                    completion(.failure, "Failure")
                }
            }
    }
    
    public static func checkNicknameRepetitionFromNaverRegister(parameters: NickNameRepetitionInput, completion: @escaping (Bool, String) -> Void) {
        AF.request("https://geeksasaeng.shop/members/nickname-duplicated", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: nil)
            .validate()
            .responseDecodable(of: NickNameRepetitionModel.self) { response in
                switch response.result {
                case.success(let result):
                    if result.isSuccess! {
                        print("DEBUG: 성공")
                        completion(true, result.message!)
                    } else {
                        print("DEBUG: 실패", result.message!)
                        completion(false, result.message!)
                    }
                case .failure(let error):
                    print("DEBUG: ", error.localizedDescription)
                    completion(false, "API 요청에 실패하였습니다")
                }
            }
    }
}
