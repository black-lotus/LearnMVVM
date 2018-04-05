//
//  AppCoordinator.swift
//  TableMVVM
//
//  Created by Romdoni Agung Purbayanto on 05/04/18.
//  Copyright © 2018 romdoni agung purbayanto. All rights reserved.
//

import UIKit

class AppCoordinator {
    
    var window: UIWindow?
    
    lazy var navigationController: UINavigationController = {
        let nvc = UINavigationController()
        nvc.isNavigationBarHidden = true
        
        return nvc
    }()
    
    init(window: UIWindow) {
        self.window = window
        self.window?.makeKeyAndVisible()
        
        self.window?.rootViewController = self.navigationController
    }
    
    func launchTodos() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TodosViewController") as! TodosViewController
        
        self.navigationController.viewControllers = [vc]
    }
    
    func launchCreateTodo() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CreateTodoViewController") as! CreateTodoViewController
     
        self.navigationController.viewControllers = [vc]
    }
    
}
