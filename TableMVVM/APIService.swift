//
//  APIService.swift
//  TableMVVM
//
//  Created by Romdoni Agung Purbayanto on 03/04/18.
//  Copyright © 2018 romdoni agung purbayanto. All rights reserved.
//

import Foundation
import Alamofire

protocol APIServiceProtocol {
    associatedtype ResponseData
    func fetchAllTodos(completion: @escaping (ResponseData) -> (Void))
}

class APIService: APIServiceProtocol {
    
    public static let shared: APIService = APIService()
    
    typealias ResponseData = Data
    
    private init() {
        
    }
    
    func fetchAllTodos(completion: @escaping (Data) -> (Void)) {
        let url = URL(string: "http://fucking-api/api/todos")
        Alamofire.request(url!).responseJSON { (response) in
            completion(response.data!)
        }
    }
    
}
