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
struct MsgResponse: Decodable {
    var chatId: String? = nil
    var content: String? = nil
    var chatRoomId: String? = nil
    var isSystemMessage: Bool? = nil
    var memberId: Int? = nil
    var nickName: String? = nil
    var profileImgUrl: String? = nil
    var readMembers: [Int]? = nil
    var createdAt: String? = nil
    var chatType: String? = nil
    var unreadMemberCnt: Int? = nil
    var isImageMessage: Bool? = nil
}

// Realm으로 로컬에 저장되는 채팅 데이터 모델
class MsgToSave: Object, Decodable {
    @Persisted(primaryKey: true) var chatId: String? = nil
    @Persisted var content: String? = nil
    @Persisted var chatRoomId: String? = nil
    @Persisted var isSystemMessage: Bool? = nil
    @Persisted var memberId: Int? = nil
    @Persisted var nickName: String? = nil
    @Persisted var profileImgUrl: String? = nil
    @Persisted var createdAt: Date? = nil
    @Persisted var unreadMemberCnt: Int? = nil
    @Persisted var isImageMessage: Bool? = nil
    @Persisted var isReaded: Bool   // 내가 이 메세지를 읽었는지 안 읽었는지
    
    // 생성자
    convenience init(chatId: String,
                     content: String,
                     chatRoomId: String,
                     isSystemMessage: Bool,
                     memberId: Int,
                     nickName: String,
                     profileImgUrl: String,
                     createdAt: Date,
                     unreadMemberCnt: Int,
                     isImageMessage: Bool,
                     isReaded: Bool = false) {
        self.init()
        self.chatId = chatId
        self.content = content
        self.chatRoomId = chatRoomId
        self.isSystemMessage = isSystemMessage
        self.memberId = memberId
        self.nickName = nickName
        self.profileImgUrl = profileImgUrl
        self.createdAt = createdAt
        self.unreadMemberCnt = unreadMemberCnt
        self.isImageMessage = isImageMessage
        self.isReaded = isReaded
    }
}
