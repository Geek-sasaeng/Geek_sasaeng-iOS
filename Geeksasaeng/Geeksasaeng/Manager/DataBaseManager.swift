//
//  DataBaseManager.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2023/01/07.
//

import UIKit
import RealmSwift

protocol DataBase {
    func read<T: Object>(_ object: T.Type) -> Results<T>
    func write<T: Object>(_ object: T)
    func delete<T: Object>(_ object: T)
    func sort<T: Object>(_ object: T.Type, by keyPath: String, ascending: Bool) -> Results<T>
}

final class DataBaseManager: DataBase {

    static let shared = DataBaseManager()

    private let database: Realm

    private init() {
        let configuration = Realm.Configuration(schemaVersion: 12)
        self.database = try! Realm(configuration: configuration)
    }
    
    func getLocationOfDefaultRealm() {
        print("DEBUG: 채팅 데이터 Realm 파일 경로", database.configuration.fileURL!)
    }

    func read<T: Object>(_ object: T.Type) -> Results<T> {
        return database.objects(object)
    }

    func write<T: Object>(_ object: T) {
        do {
            try database.write {
                database.add(object, update: .modified)
                print("DEBUG: local에 채팅을 저장하다", object)
            }

        } catch let error {
            print(error)
        }
    }

    func update<T: Object>(_ object: T, completion: @escaping ((T) -> ())) {
        do {
            try database.write {
                completion(object)
            }

        } catch let error {
            print(error)
        }
    }

    func delete<T: Object>(_ object: T) {
        do {
            try database.write {
                database.delete(object)
                print("Delete Success")
            }

        } catch let error {
            print(error)
        }
    }
    
    func sort<T: Object>(_ object: T.Type, by keyPath: String, ascending: Bool = true) -> Results<T> {
        return database.objects(object).sorted(byKeyPath: keyPath, ascending: ascending)
    }
    
    func refresh() {
        database.refresh()
    }
}
