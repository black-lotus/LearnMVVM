//
//  ViewController.swift
//  TableMVVM
//
//  Created by romdoni agung purbayanto on 01/04/18.
//  Copyright © 2018 romdoni agung purbayanto. All rights reserved.
//

import UIKit

protocol TodoView: class {
    func insertTodoItem()
    func removeTodoItem(at index: Int)
    func updateTodoItem(at index: Int)
    func reloadTodoItems()
}

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var itemTextField: UITextField!
    
    var viewModel: TodoViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.register(UINib(nibName: TodoItemTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TodoItemTableViewCell.identifier)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        if self.viewModel == nil {
            self.viewModel = TodoViewModel(view: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onAddItem(_ sender: UIButton) {
        guard let text: String = self.itemTextField.text, !text.isEmpty else { return }
        
        self.viewModel?.newTodoItem = text
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.viewModel?.onAddTodoItem()
        }
    }
    
}


extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: TodoItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: TodoItemTableViewCell.identifier, for: indexPath) as? TodoItemTableViewCell else {
            return UITableViewCell()
        }
        
        let index: Int = indexPath.row
        if let item = self.viewModel?.items[index] {
            cell.configureCell(with: item)
        }
        
        return cell
    }
    
}


extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index: Int = indexPath.row
        if let item = self.viewModel?.items[index] {
            (item as? TodoItemViewDelegate)?.onItemSelected()
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var actions: [UIContextualAction] = [UIContextualAction]()
        
        let index: Int = indexPath.row
        if let itemViewModel = self.viewModel?.items[index] {
            itemViewModel.menuItems?.forEach({ (item) in
                let menuAction = UIContextualAction(style: .normal, title: item.title) { (action, sourceView, success: (Bool) -> (Void)) in
                    if let delegate = item as? TodoMenuItemViewDelegate {
                        DispatchQueue.global(qos: .background).async {
                            delegate.onMenuItemSelected()
                        }
                    }
                    
                    success(true)
                }
                
                menuAction.backgroundColor = UIColor(item.backColor ?? "")
                
                actions.append(menuAction)
            })
        }
        
        return UISwipeActionsConfiguration(actions: actions)
    }
    
}


extension ViewController: TodoView {
    
    func insertTodoItem() {
        guard let items = self.viewModel?.items else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.itemTextField.text = self?.viewModel?.newTodoItem
            
            self?.tableView.beginUpdates()
            self?.tableView.insertRows(at: [IndexPath(row: items.count - 1, section: 0)], with: UITableViewRowAnimation.automatic)
            self?.tableView.endUpdates()
        }
    }
    
    func removeTodoItem(at index: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.beginUpdates()
            self?.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: UITableViewRowAnimation.automatic)
            self?.tableView.endUpdates()
        }
    }
    
    func updateTodoItem(at index: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: UITableViewRowAnimation.automatic)
        }
    }
    
    func reloadTodoItems() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
}

