//
//  TodoItemViewModel.swift
//  TableMVVM
//
//  Created by romdoni agung purbayanto on 01/04/18.
//  Copyright © 2018 romdoni agung purbayanto. All rights reserved.
//

import Foundation

protocol TodoItemPresentable {
    
    var id: String? { get }
    var textValue: String? { get set }
    var isDone: Bool? { get set }
    var menuItems: [TodoMenuItemViewPresentable]? { get }
    
}

protocol TodoItemViewDelegate: class {
    func onItemSelected()
    func onRemoveSelected()
    func onDoneSelected()
}

class TodoItemViewModel: TodoItemPresentable {
   
    var id: String? = "0"
    var textValue: String?
    var isDone: Bool? = false
    var menuItems: [TodoMenuItemViewPresentable]? = [TodoMenuItemViewPresentable]()
    
    weak var parent: TodoViewDelegate?
    
    init(id: String?, textValue: String?, parentViewModel: TodoViewDelegate?) {
        self.id = id
        self.textValue = textValue
        self.parent = parentViewModel
        
        let removeMenuItem = RemoveMenuItemViewModel(parentViewModel: self)
        removeMenuItem.title = "Remove"
        removeMenuItem.backColor = "#ff0000"
        
        let doneMenuItem = DoneMenuItemViewModel(parentViewModel: self)
        doneMenuItem.title = self.isDone! ? "Undone" : "Done"
        doneMenuItem.backColor = "#008800"
        
        menuItems?.append(contentsOf: [removeMenuItem, doneMenuItem])
    }
    
}

extension TodoItemViewModel: TodoItemViewDelegate {
    
    
    /// On Item Selected received in ViewModel on TableView didSelectRowAt
    func onItemSelected() {
        
    }
    
    func onRemoveSelected() {
        self.parent?.onDeleteTodoItem(id: self.id ?? "")
    }
    
    func onDoneSelected() {
        self.parent?.onDoneTodoItem(id: self.id ?? "")
    }
    
}
