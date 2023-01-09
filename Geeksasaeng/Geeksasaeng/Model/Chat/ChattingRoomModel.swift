//
//  ChattingRoomModel.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2023/01/09.
//

import Foundation

// 채팅방 상세조회 API에 필요한 모델
struct ChattingRoomInput: Encodable {
    var chatRoomId: String?
}

struct ChattingRoomModel: Decodable {
    var code: Int?
    var isSuccess: Bool?
    var message: String?
    var result: ChattingRoomResult?
}

struct ChattingRoomResult: Decodable {
    var accountNumber: String?   // 방장 계좌번호
    var bank: String?    // 은행
    var cheifId: Int?    // 방장 memberId
    var enterTime: String?   // 내가 이 채팅방에 언제 들어왔는지
    var isChief: Bool?   // 방장인지
    var isOrderFinish: Bool?     // 주문 완료된 채팅인지
    var isRemittanceFinish: Bool?    // 송금 완료된 채팅인지
}

