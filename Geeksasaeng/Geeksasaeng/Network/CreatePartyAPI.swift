//
//  CreatePartyAPI.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/12.
//

/* 나중에 파티 생성 API 개발되면 Input Model 추가 예정 */
import Foundation

/* CreatePartyVC의 각 서브뷰에서 다음 화면으로 넘어가기 직전에 해당되는 데이터 저장,
 - 중간에 블러뷰 터치로 서브뷰가 닫히면 진행된 곳까지 출력
 - 마지막 서브뷰까지 설정하고 완료 버튼을 누르면 모든 정보 출력 */
struct CreateParty {
    static var orderForecastTime: String?
    static var matchingPerson: String?
    static var category: String?
    static var receiptPlace: String?
    static var orderAsSoonAsMatch: Bool?
    static var address: String?
}
