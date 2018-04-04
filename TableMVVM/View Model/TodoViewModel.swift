//
//  TodoViewModel.swift
//  TableMVVM
//
//  Created by romdoni agung purbayanto on 01/04/18.
//  Copyright © 2018 romdoni agung purbayanto. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift
import SwiftyJSON

protocol TodoViewDelegate: class {
    func onAddTodoItem()
    func onDeleteTodoItem(id: String)
    func onDoneTodoItem(id: String)
}

protocol TodoViewPresentable {
    
    var newTodoItem: String? { get }
    var searchValue: Variable<String> { get }
    
}

class TodoViewModel: TodoViewPresentable {
    
    var newTodoItem: String?
    var searchValue: Variable<String> = Variable("")
    
    var items: Variable<[TodoItemPresentable]> = Variable([])
    var filteredItems: Variable<[TodoItemPresentable]> = Variable([])
    var database: Database?
    var notificationToken: NotificationToken? = nil
    
    lazy var searchValueObservable: Observable<String> = self.searchValue.asObservable()
    lazy var itemsObservable: Observable<[TodoItemPresentable]> = self.items.asObservable()
    
    let disposeBag = DisposeBag()
    
    init() {
        database = Database.shared
        
        fetchTodos()
        handleRealmNotifications()
        
        self.searchValueObservable.subscribe(onNext: { (value) in
            print("Search received => \(value)")
            
            self.itemsObservable.map({
                $0.filter({ (todoItem) -> Bool in
                    if value.isEmpty {
                        return true
                    }
                    
                    return (todoItem.textValue?.lowercased().contains(value.lowercased()))!
                })
            })
            .bind(to: self.filteredItems)
            .disposed(by: self.disposeBag)
        }).disposed(by: self.disposeBag)
    }
    
    deinit {
        notificationToken = nil
    }
    
    func fetchTodos() {
        let todosOberservable = APIService.shared.fetchAllTodos()
        
        todosOberservable.subscribe(
            onNext: { [weak self] (response) in
                if let todos = response["todos"].array {
                    todos.forEach({ (itemDict) in
                        if let id = itemDict["id"].int, let value = itemDict["value"].string {
                            self?.database?.createOrUpdate(todoItem: value)
                        }
                    })
                }
            },
            onError: { (error) in
                print("observable error")
            },
            onCompleted: {
                print("observable completed")
            },
            onDisposed: {
                print("observable disposed")
            }).disposed(by: self.disposeBag)
    }
    
    func handleRealmNotifications() {
        let itemResults = database?.fetch()
        notificationToken = itemResults?.observe({ [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial(_):
                itemResults?.forEach({ (item) in
                    // transform entity into view model
                    let newItem = TodoItemViewModel(id: "\(item.todoId)", textValue: item.todoValue, parentViewModel: self)
                    
                    self?.items.value.append(newItem)
                })
                break
                
            case .update(_, let deletions, let insertions, let modifications):
                insertions.forEach({ (index) in
                    let item = itemResults![index]
                    
                    // transform entity into view model
                    let newItem = TodoItemViewModel(id: "\(item.todoId)", textValue: item.todoValue, parentViewModel: self)
                    
                    self?.items.value.append(newItem)
                })
                
                modifications.forEach({ (index) in
                    let item = itemResults![index]
                    
                    guard let index = self?.items.value.index(where: { Int($0.id ?? "") == item.todoId }) else { return }
                    
                    if item.deletedAt != nil {
                        self?.items.value.remove(at: index)
                        self?.database?.delete(primaryKey: item.todoId)
                    } else {
                        if var todoItem = self?.items.value[index] {
                            todoItem.textValue = item.todoValue
                            todoItem.isDone = !item.isDone
                            
                            if var doneMenuItem = todoItem.menuItems?.filter({ (menuItem) -> Bool in
                                return menuItem is DoneMenuItemViewModel
                            }).first {
                                doneMenuItem.title = todoItem.isDone! ? "Undone" : "Done"
                            }
                        }
                    }
                })
                
                break
                
            case .error(let error):
                break
            }
            
            self?.items.value.sort { (a, b) -> Bool in
                if (a.isDone! && b.isDone!) || (!(a.isDone!) && !(b.isDone!)) {
                    return a.id! < b.id!
                }
                
                return !(a.isDone!) && b.isDone!
            }
        })
    }
    
}

extension TodoViewModel: TodoViewDelegate {
    
    func onAddTodoItem() {
        guard let newValue = self.newTodoItem, !newValue.isEmpty else {
            return
        }
        
        database?.createOrUpdate(todoItem: newValue)
        
        // reset
        self.newTodoItem = nil
    }
    
    func onDeleteTodoItem(id: String) {
        self.database?.saveDelete(primaryKey: Int(id)!)
    }
    
    func onDoneTodoItem(id: String) {
        self.database?.isDone(primaryKey: Int(id)!)
    }
    
}
