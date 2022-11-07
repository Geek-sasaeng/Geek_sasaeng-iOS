//
//  File.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/10/27.
//

import Foundation

// 채팅 내용 수신하는 데이터 모델
struct Chatting: Decodable {
    var chattingRoomId: String?
    var content: String?
    var createdAt: String?
}
