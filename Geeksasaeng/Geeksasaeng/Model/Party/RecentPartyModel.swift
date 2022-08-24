//
//  RecentPartyModel.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/08/18.
//

import Foundation

/* 가장 최근 참여한 배달파티 데이터 구조 */
struct RecentPartyModel: Decodable {
    var isSuccess: Bool?
    var code: Int?
    var message: String?
    var result: [RecentPartyModelResult]?
}

struct RecentPartyModelResult: Decodable {
    var id: Int?
    var title: String?
    var createdAt: String?  // TODO: 추후에 나의 활동 보기 할 때 사용 예정
}
