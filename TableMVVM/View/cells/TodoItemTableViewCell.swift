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
        
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: viewModel.textValue ?? "")
        if viewModel.isDone! {
            let range: NSRange = NSMakeRange(0, attributeString.length)
            attributeString.addAttribute(NSAttributedStringKey.strikethroughColor, value: UIColor.lightGray, range: range)
            attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: range)
            attributeString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.lightGray, range: range)
        }
        
        self.itemLabel.attributedText = attributeString
    }
    
}
