//
//  SectionViewModel.swift
//  TableMVVM
//
//  Created by Romdoni Agung Purbayanto on 05/04/18.
//  Copyright © 2018 romdoni agung purbayanto. All rights reserved.
//

import Foundation
import RxDataSources

struct SectionViewModel {
    var header: String
    var items: [Item]
}

extension SectionViewModel: AnimatableSectionModelType {
    typealias Identity = String
    typealias Item = TodoItemViewModel
    
    var identity: String {
        return header
    }
    
    init(original: SectionViewModel, items: [Item]) {
        self = original
        self.items = items
    }
}
