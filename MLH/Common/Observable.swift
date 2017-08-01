//
//  Observable.swift
//  MLH
//
//  Created by Haitang on 17/6/10.
//  Copyright © 2017年 Haitang. All rights reserved.
//

import Foundation


class Observable<T>{
    typealias Observer = (T) -> Void
    var observer:Observer?
    func observe(_ observer: Observer?){
        self.observer = observer
        observer?(value)
    }
    var value:T{
        didSet{
            observer?(value)
        }
    }
    init(_ value:T) {
        self.value = value
    }
}























