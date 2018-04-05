//
//  CreateTodoViewController.swift
//  TableMVVM
//
//  Created by Romdoni Agung Purbayanto on 05/04/18.
//  Copyright © 2018 romdoni agung purbayanto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CreateTodoViewController: UIViewController {

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var newTodoTextField: UITextField!
    @IBOutlet weak var todoAddButton: UIButton!
    
    let disposeBag: DisposeBag = DisposeBag()
    
    var viewModel: CreateTodoViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if viewModel == nil {
            self.viewModel = CreateTodoViewModel(database: Database.shared)
        }
        
        Observable.just(["personal", "work"]).bind(to: self.pickerView.rx.itemTitles) { dataSource, item in
            return "\(item)"
        }.disposed(by: self.disposeBag)
        
        if let todoItemType = self.viewModel?.todoItemType {
            self.pickerView.rx
                .modelSelected(String.self)
                .bind(to: todoItemType)
                .disposed(by: self.disposeBag)
        }
        
        self.todoAddButton.rx.tap.bind { [weak self] in
            guard let text: String = self?.newTodoTextField.text, !text.isEmpty else { return }
            
            self?.viewModel?.newTodoItem = text
            
            DispatchQueue.global(qos: .background).async { 
                self?.viewModel?.onAddTodoItem()
            }
        }.disposed(by: self.disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
