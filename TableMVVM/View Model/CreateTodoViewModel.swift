//
//  CreateTodoViewModel.swift
//  TableMVVM
//
//  Created by Romdoni Agung Purbayanto on 05/04/18.
//  Copyright © 2018 romdoni agung purbayanto. All rights reserved.
//

import Foundation
import RxSwift

protocol CreateTodoViewDelegate: class {
    func onAddTodoItem()
}

protocol CreateTodoViewPresentable {
    
    var newTodoItem: String? { get }
    var todoItemType: Variable<[String]> { get }
    
}

class CreateTodoViewModel: CreateTodoViewPresentable {
    
    var newTodoItem: String? = ""
    var todoItemType: Variable<[String]> = Variable(["Personal"])
    
    var database: Database?
    
    let disposeBag = DisposeBag()
    
    init(database: Database) {
        self.database = database
        
        self.todoItemType.asObservable().subscribe(onNext: { (items) in
            print("selected todo item type => \(items)")
        }).disposed(by: self.disposeBag)
    }
}

extension CreateTodoViewModel: CreateTodoViewDelegate {
    
    func onAddTodoItem() {
        guard let newValue = self.newTodoItem, !newValue.isEmpty else {
            return
        }
        
        guard let todoType = self.todoItemType.value.first else {
            return
        }
        
        database?.createOrUpdate(todoItem: newValue, todoType: todoType)
        
        // reset
        self.newTodoItem = nil
    }
    
}
