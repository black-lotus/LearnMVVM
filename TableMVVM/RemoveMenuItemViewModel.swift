//
//  RemoveMenuItemViewModel.swift
//  TableMVVM
//
//  Created by romdoni agung purbayanto on 01/04/18.
//  Copyright © 2018 romdoni agung purbayanto. All rights reserved.
//

import Foundation

class RemoveMenuItemViewModel: TodoMenuItemViewModel {
    
    override func onMenuItemSelected() {
        print("Remove Menu Item Selected")
        self.parent?.onRemoveSelected()
    }
    
}
