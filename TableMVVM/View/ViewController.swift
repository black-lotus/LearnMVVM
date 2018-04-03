//
//  ViewController.swift
//  TableMVVM
//
//  Created by romdoni agung purbayanto on 01/04/18.
//  Copyright © 2018 romdoni agung purbayanto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var itemTextField: UITextField!
    
    fileprivate lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.dimsBackgroundDuringPresentation = false
        controller.searchBar.sizeToFit()
        controller.searchBar.barStyle = UIBarStyle.black
        controller.searchBar.barTintColor = UIColor.black
        controller.searchBar.backgroundColor = UIColor.clear
        controller.searchBar.placeholder = "Search todos..."
        
        return controller
    }()
    
    var viewModel: TodoViewModel?
    
    let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.register(UINib(nibName: TodoItemTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TodoItemTableViewCell.identifier)

        self.tableView.delegate = self
        
        if self.viewModel == nil {
            self.viewModel = TodoViewModel()
        }
        
        self.viewModel?.filteredItems
            .asObservable()
            .bind(to: self.tableView.rx.items(cellIdentifier: TodoItemTableViewCell.identifier, cellType: TodoItemTableViewCell.self)) { (index, item, cell) in
                cell.configureCell(with: item)
            }.disposed(by: disposeBag)
        
        let searchBar = self.searchController.searchBar
        
        self.tableView.tableHeaderView = searchBar
        self.tableView.contentOffset = CGPoint(x: 0, y: searchBar.frame.size.height)
        
        searchBar.rx
            .text
            .orEmpty
            .distinctUntilChanged()
            .debug()
            .bind(to: (self.viewModel?.searchValue)!)
            .disposed(by: self.disposeBag)
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

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index: Int = indexPath.row
        if let item = self.viewModel?.items.value[index] {
            (item as? TodoItemViewDelegate)?.onItemSelected()
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var actions: [UIContextualAction] = [UIContextualAction]()
        
        let index: Int = indexPath.row
        if let itemViewModel = self.viewModel?.items.value[index] {
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

