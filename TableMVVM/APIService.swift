//
//  APIService.swift
//  TableMVVM
//
//  Created by Romdoni Agung Purbayanto on 03/04/18.
//  Copyright © 2018 romdoni agung purbayanto. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RxSwift

protocol APIServiceProtocol {
    associatedtype ResponseData
    func fetchAllTodos() -> Observable<JSON>
}

class APIService: APIServiceProtocol {
    
    public static let shared: APIService = APIService()
    
    typealias ResponseData = Observable<JSON>
    
    private init() {
        
    }
    
    func fetchAllTodos() -> Observable<JSON> {
        let url = URL(string: "http://fucking-api/api/todos")
        
        return Observable.create({ (observable) -> Disposable in
            let request = Alamofire.request(url!).responseJSON { (responseData) in
                switch(responseData.result) {
                case .success(let value):
                    if let statusCode: Int = responseData.response?.statusCode, statusCode == 200 {
                        let responseJSON = JSON(value)
                        observable.onNext(responseJSON)
                        observable.onCompleted()
                    } else {
                        observable.onError(NSError(domain: "Internal Error", code: -1, userInfo: nil))
                    }
                    break
                    
                case .failure(let error):
                    observable.onError(error)
                    break
                }
            }
            
            return Disposables.create {
                request.cancel()
            }
        })
    }
    
}
