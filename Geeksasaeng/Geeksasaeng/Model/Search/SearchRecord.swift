//
//  SearchRecord.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/11/07.
//

import Foundation
import RealmSwift

// 검색 기록 데이터 객체
class SearchRecord: Object {
    // 고유값
    @Persisted(primaryKey: true) var _id: ObjectId
    // 검색어
    @Persisted var content: String = ""
    // 검색한 시간
    @Persisted var createdAt: Date = Date()
    
    // 생성자
    convenience init(content: String) {
        self.init()
        self.content = content
    }
}
