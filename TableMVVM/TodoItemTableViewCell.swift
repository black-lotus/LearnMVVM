//
//  TodoItemTableViewCell.swift
//  TableMVVM
//
//  Created by romdoni agung purbayanto on 01/04/18.
//  Copyright © 2018 romdoni agung purbayanto. All rights reserved.
//

import UIKit

class TodoItemTableViewCell: UITableViewCell {

    public static let identifier: String = "TodoItemTableViewCell"
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var itemLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    /// Configure cell using View Model
    ///
    /// - Parameter viewModel: Todo Item Presentable
    func configureCell(with viewModel: TodoItemPresentable) {
        self.idLabel.text = viewModel.id ?? ""
        self.itemLabel.text = viewModel.textValue ?? ""
    }
    
}
