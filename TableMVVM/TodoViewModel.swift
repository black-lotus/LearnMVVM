//
//  TodoViewModel.swift
//  TableMVVM
//
//  Created by romdoni agung purbayanto on 01/04/18.
//  Copyright © 2018 romdoni agung purbayanto. All rights reserved.
//

import Foundation

protocol TodoViewDelegate: class {
    func onAddTodoItem()
    func onDeleteTodoItem(id: String)
    func onDoneTodoItem(id: String)
}

protocol TodoViewPresentable {
    
    var newTodoItem: String? { get }
    
}

class TodoViewModel: TodoViewPresentable {
    
    var newTodoItem: String?
    var items: [TodoItemPresentable] = []
    
    weak var view: TodoView?
    
    init(view: TodoView?) {
        self.view = view
        
        let item1 = TodoItemViewModel(id: "1", textValue: "aaa", parentViewModel: self)
        let item2 = TodoItemViewModel(id: "2", textValue: "bbb", parentViewModel: self)
        let item3 = TodoItemViewModel(id: "3", textValue: "ccc", parentViewModel: self)
        
        self.items.append(contentsOf: [item1, item2, item3])
    }
    
}

extension TodoViewModel: TodoViewDelegate {
    
    func onAddTodoItem() {
        guard let newValue = self.newTodoItem, !newValue.isEmpty else {
            return
        }
        
        let index = self.items.count + 1
        let newItem = TodoItemViewModel(id: "\(index)", textValue: newValue, parentViewModel: self)
        self.items.append(newItem)
        
        // reset
        self.newTodoItem = nil
        
        // notify view item has been inserted
        self.view?.insertTodoItem()
    }
    
    func onDeleteTodoItem(id: String) {
        guard let index = self.items.index(where: { ($0.id ?? "") == id }) else { return }
        self.items.remove(at: index)
        
        // notify view item has been delted
        self.view?.removeTodoItem(at: index)
    }
    
    func onDoneTodoItem(id: String) {
        
    }
    
}
