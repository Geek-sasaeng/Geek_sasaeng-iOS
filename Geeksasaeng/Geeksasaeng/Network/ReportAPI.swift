//
//  ReportAPI.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/31.
//

import Foundation
import Alamofire

/* 신고하기 API의 Request body */
struct ReportInput : Encodable {
    var block: Bool?
    var reportCategoryId: Int?
    var reportContent: String?
    var reportedDeliveryPartyId: Int?
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
    
    /* 신고하기 버튼을 눌러서 신고 요청 */
    public static func requestReport(_ viewController : UIViewController, _ parameter : ReportInput, completion: @escaping () -> Void) {
        let url = "https://geeksasaeng.shop/reports/delivery-parties"
        
        AF.request(url, method: .post,
                   parameters: parameter, encoder: JSONParameterEncoder.default, headers: ["Authorization": "Bearer " + (LoginModel.jwt ?? "")])
        .validate()
        .responseDecodable(of: ReportModel.self) { response in
            switch response.result {
            case .success(let result):
                if result.isSuccess! {
                    print("DEBUG: 성공", result)
                    viewController.showToast(viewController: viewController, message: "신고가 완료되었습니다.", font: .customFont(.neoBold, size: 15), color: .mainColor)
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
