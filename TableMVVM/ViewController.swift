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
        self.viewModel?.onAddTodoItem()
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
    
}

