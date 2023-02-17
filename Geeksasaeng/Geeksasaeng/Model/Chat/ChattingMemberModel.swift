//
//  ChattingMemberModel.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2023/02/15.
//

import Foundation

// 채팅방 내 멤버 프로필 클릭 시 정보 조회 API req
struct ChattingMemberInput: Encodable {
    var chatRoomId: String?
    var memberId: Int?
}

// res
struct ChattingMemberModel: Decodable {
    var code: Int?
    var isSuccess: Bool?
    var message: String?
    var result: ChattingMemberResultModel?
}

struct ChattingMemberResultModel: Decodable {
    var grade: String?
    var isChief: Bool?
    var userName: String?
}
