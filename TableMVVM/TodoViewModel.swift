//
//  TodoViewModel.swift
//  TableMVVM
//
//  Created by romdoni agung purbayanto on 01/04/18.
//  Copyright © 2018 romdoni agung purbayanto. All rights reserved.
//

import Foundation

protocol TodoItemDelegate {
    func onTodoItemAdded()
}


class TodoViewModel {
    
    var newTodoItem: String?
    var items: [TodoItemPresentable] = []
    
    init() {
        let item1 = TodoItemViewModel(id: "1", textValue: "aaa")
        let item2 = TodoItemViewModel(id: "2", textValue: "bbb")
        let item3 = TodoItemViewModel(id: "3", textValue: "ccc")
        
        self.items.append(contentsOf: [item1, item2, item3])
    }
    
}

extension TodoViewModel: TodoItemDelegate {
    
    func onTodoItemAdded() {
        
    }
    
}
