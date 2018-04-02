//
//  TodoViewModel.swift
//  TableMVVM
//
//  Created by romdoni agung purbayanto on 01/04/18.
//  Copyright © 2018 romdoni agung purbayanto. All rights reserved.
//

import Foundation
import RxSwift

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
    var items: Variable<[TodoItemPresentable]> = Variable([])
    
    init() {
        let item1 = TodoItemViewModel(id: "1", textValue: "aaa", parentViewModel: self)
        let item2 = TodoItemViewModel(id: "2", textValue: "bbb", parentViewModel: self)
        let item3 = TodoItemViewModel(id: "3", textValue: "ccc", parentViewModel: self)
        
        self.items.value.append(contentsOf: [item1, item2, item3])
    }
    
}

extension TodoViewModel: TodoViewDelegate {
    
    func onAddTodoItem() {
        guard let newValue = self.newTodoItem, !newValue.isEmpty else {
            return
        }
        
        let index = self.items.value.count + 1
        let newItem = TodoItemViewModel(id: "\(index)", textValue: newValue, parentViewModel: self)
        self.items.value.append(newItem)
        
        // reset
        self.newTodoItem = nil
    }
    
    func onDeleteTodoItem(id: String) {
        guard let index = self.items.value.index(where: { ($0.id ?? "") == id }) else { return }
        self.items.value.remove(at: index)
    }
    
    func onDoneTodoItem(id: String) {
        guard let index = self.items.value.index(where: { ($0.id ?? "") == id }) else { return }
        
        var item = self.items.value[index]
        item.isDone = !(item.isDone!)
        
        if var doneMenuItem = item.menuItems?.filter({ (menuItem) -> Bool in
            return menuItem is DoneMenuItemViewModel
        }).first {
            doneMenuItem.title = item.isDone! ? "Undone" : "Done"
        }
        
        self.items.value.sort { (a, b) -> Bool in
            if (a.isDone! && b.isDone!) || (!(a.isDone!) && !(b.isDone!)) {
                return a.id! < b.id!
            }
            
            return !(a.isDone!) && b.isDone!
        }
    }
    
}
