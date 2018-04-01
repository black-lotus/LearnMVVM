//
//  TodoItemViewModel.swift
//  TableMVVM
//
//  Created by romdoni agung purbayanto on 01/04/18.
//  Copyright © 2018 romdoni agung purbayanto. All rights reserved.
//

import Foundation

protocol TodoItemViewDelegate {
    func onItemSelected()
}

protocol TodoItemPresentable {
    
    var id: String? { get }
    var textValue: String? { get }
    
}

class TodoItemViewModel: TodoItemPresentable {
    
    var id: String? = "0"
    var textValue: String?
    
    init(id: String?, textValue: String?) {
        self.id = id
        self.textValue = textValue
    }
    
}

extension TodoItemViewModel: TodoItemViewDelegate {
    
    
    /// On Item Selected received in ViewModel on TableView didSelectRowAt
    func onItemSelected() {
        
    }
    
}
