//
//  MessageData.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/12/12.
//

import Foundation

// 채팅 전송하는 데이터 모델
struct MsgRequest: Encodable {
    var content: String? = nil
    var chatRoomId: String? = nil
    var isSystemMessage: Bool? = nil
    var memberId: Int? = nil
    var email: String? = nil
    var profileImgUrl: String? = nil
    var chatType: String? = nil
    var chatId: String? = nil
    var isImageMessage: Bool = false
}

// 채팅 수신하는 데이터 모델
struct MsgResponse: Decodable {
    var chatId: Int? = nil
    var content: String? = nil
    var chatRoomId: String? = nil
    var isSystemMessage: Bool? = nil
    var memberId: Int? = nil
    var email: String? = nil
    var profileImgUrl: String? = nil
    var readMembers: [String]? = nil
    var createdAt: String? = nil
    var chatType: String? = nil
    var unreadMemberCnt: Int? = nil
    var isImageMessage: Bool? = nil
}
