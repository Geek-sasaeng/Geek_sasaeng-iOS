//
//  MessageData.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/12/12.
//

import Foundation
import RealmSwift

// 채팅 전송하는 데이터 모델
struct MsgRequest: Encodable {
    var content: String?
    var chatRoomId: String?
    var isSystemMessage: Bool?
    var chatType: String?
    var chatId: String?
    var jwt: String?
}

// 채팅 수신하는 데이터 모델
// + Realm으로 로컬에 저장되는 채팅 데이터 모델
class MsgResponse: Object, Decodable {
    @Persisted(primaryKey: true) var chatId: String? = nil
    @Persisted var content: String? = nil
    @Persisted var chatRoomId: String? = nil
    @Persisted var isSystemMessage: Bool? = nil
    @Persisted var memberId: Int? = nil
    @Persisted var profileImgUrl: String? = nil
    @Persisted var readMembers = List<Int>()
    @Persisted var createdAt: String? = nil
    @Persisted var chatType: String? = nil
    @Persisted var unreadMemberCnt: Int? = nil
    @Persisted var isImageMessage: Bool? = nil
    
    // 생성자
    convenience init(chatId: String,
                     content: String,
                     chatRoomId: String,
                     isSystemMessage: Bool,
                     memberId: Int,
                     profileImgUrl: String,
                     readMembers: List<Int>,
                     createdAt: String,
                     chatType: String,
                     unreadMemberCnt: Int,
                     isImageMessage: Bool) {
        self.init()
        self.chatId = chatId
        self.content = content
        self.chatRoomId = chatRoomId
        self.isSystemMessage = isSystemMessage
        self.memberId = memberId
        self.profileImgUrl = profileImgUrl
        self.readMembers = readMembers
        self.createdAt = createdAt
        self.chatType = chatType
        self.unreadMemberCnt = unreadMemberCnt
        self.isImageMessage = isImageMessage
    }
}
