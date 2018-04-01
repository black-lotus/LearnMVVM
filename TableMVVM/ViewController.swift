//
//  ViewController.swift
//  TableMVVM
//
//  Created by romdoni agung purbayanto on 01/04/18.
//  Copyright © 2018 romdoni agung purbayanto. All rights reserved.
//

import UIKit

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
            self.viewModel = TodoViewModel()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onAddItem(_ sender: UIButton) {
    }
    
}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
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
