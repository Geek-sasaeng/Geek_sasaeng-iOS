//
//  ReportAPI.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/31.
//

import Foundation
import Alamofire

/* 배달파티 신고하기 API의 Request body */
struct ReportPartyInput : Encodable {
    var block: Bool?
    var reportCategoryId: Int?
    var reportContent: String?
    var reportedDeliveryPartyId: Int?
    var reportedMemberId: Int?
}
struct ReportMemberInput : Encodable {
    var block: Bool?
    var reportCategoryId: Int?
    var reportContent: String?
    var reportedMemberId: Int?
}

/* 신고하기 API의 Response */
struct ReportModel : Decodable {
    var code : Int?
    var isSuccess : Bool?
    var message : String?
    var result : String?
}

/* 신고 API 연동 */
class ReportAPI {
    
    /* 신고하기 버튼을 눌러서 파티 신고 요청 */
    public static func requestReportParty(_ viewController : UIViewController, _ parameter : ReportPartyInput, completion: @escaping () -> Void) {
        let url = "https://geeksasaeng.shop/reports/delivery-parties"
        
        AF.request(url, method: .post,
                   parameters: parameter, encoder: JSONParameterEncoder.default, headers: ["Authorization": "Bearer " + (LoginModel.jwt ?? "")])
        .validate()
        .responseDecodable(of: ReportModel.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("DEBUG: 파티 신고 성공", result)
                    viewController.showToast(viewController: viewController, message: "파티 신고가 완료되었습니다.", font: .customFont(.neoBold, size: 15), color: .mainColor)
                    completion()
                } else {
                    print("DEBUG:", result.message!)
                }
            case .failure(let error):
                print("DEBUG:", error.localizedDescription)
            }
        }
    }
    
    /* 신고하기 버튼을 눌러서 멤버 신고 요청 */
    public static func requestReportMember(_ viewController : UIViewController, _ parameter : ReportMemberInput, completion: @escaping () -> Void) {
        let url = "https://geeksasaeng.shop/reports/members"
        
        AF.request(url, method: .post,
                   parameters: parameter, encoder: JSONParameterEncoder.default, headers: ["Authorization": "Bearer " + (LoginModel.jwt ?? "")])
        .validate()
        .responseDecodable(of: ReportModel.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("DEBUG: 유저 신고 성공", result)
                    viewController.showToast(viewController: viewController, message: "유저 신고가 완료되었습니다.", font: .customFont(.neoBold, size: 15), color: .mainColor)
                    completion()
                } else {
                    print("DEBUG:", result.message!)
                }
            case .failure(let error):
                print("DEBUG:", error.localizedDescription)
            }
        }
    }
}
