//
//  Database.swift
//  TableMVVM
//
//  Created by Romdoni Agung Purbayanto on 02/04/18.
//  Copyright © 2018 romdoni agung purbayanto. All rights reserved.
//

import Foundation
import RealmSwift

class Database {
    
    static let shared: Database = Database()
    
    private init() {
        
    }
    
    func createOrUpdate(todoItem value: String, todoType: String) {
        let realm = try! Realm()
        
        var id: Int = 1
        
        let isEmpty = realm.objects(TodoItem.self).filter({ $0.todoValue.lowercased() == value.lowercased() }).isEmpty
        if !isEmpty {
            return
        }
        
        if let lastEntity = realm.objects(TodoItem.self).last {
            id = lastEntity.todoId + 1
        }
        
        let item = TodoItem()
        item.todoId = id
        item.todoValue = value
        item.todoType = todoType
        
        try! realm.write {
            realm.add(item, update: true)
        }
    }
    
    func fetch() -> Results<TodoItem> {
        let realm = try! Realm()
        let results = realm.objects(TodoItem.self).sorted(byKeyPath: "createdAt")
        
        return results
    }
    
    func delete(primaryKey: Int) {
        let realm = try! Realm()
        
        if let item = realm.object(ofType: TodoItem.self, forPrimaryKey: primaryKey) {
            try! realm.write {
                realm.delete(item)
            }
        }
    }
    
    func saveDelete(primaryKey: Int) {
        let realm = try! Realm()
        
        if let item = realm.object(ofType: TodoItem.self, forPrimaryKey: primaryKey) {
            try! realm.write {
                item.deletedAt = Date()
            }
        }
    }
    
    func isDone(primaryKey: Int) {
        let realm = try! Realm()
        
        if let item = realm.object(ofType: TodoItem.self, forPrimaryKey: primaryKey) {
            try! realm.write {
                item.isDone = !item.isDone
            }
        }
    }
    
}
