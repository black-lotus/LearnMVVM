//
//  DoneMenuItemViewModel.swift
//  TableMVVM
//
//  Created by romdoni agung purbayanto on 01/04/18.
//  Copyright © 2018 romdoni agung purbayanto. All rights reserved.
//

import Foundation

class DoneMenuItemViewModel: TodoMenuItemViewModel {
    
    override func onMenuItemSelected() {
        print("Done Menu Item Selected")
        self.parent?.onDoneSelected()
    }
    
}
