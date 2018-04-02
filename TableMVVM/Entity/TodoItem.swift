//
//  TodoItem.swift
//  TableMVVM
//
//  Created by Romdoni Agung Purbayanto on 02/04/18.
//  Copyright © 2018 romdoni agung purbayanto. All rights reserved.
//

import Foundation
import RealmSwift

class TodoItem: Object {
    
    @objc dynamic var todoId: Int = 0
    @objc dynamic var todoValue: String = ""
    @objc dynamic var isDone: Bool = false
    @objc dynamic var createdAt: Date? = Date()
    @objc dynamic var updatedAt: Date?
    @objc dynamic var deletedAt: Date?
    
    override static func primaryKey() -> String? {
        return "todoId"
    }
    
}
