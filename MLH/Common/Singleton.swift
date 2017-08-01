//
//  Singleton.swift
//  MLH
//
//  Created by Haitang on 17/6/14.
//  Copyright © 2017年 Haitang. All rights reserved.
//

import Foundation
public final class Singleton{

    private static let _shared = Singleton()
    private init(){}
    
    var locationX:String?
    public static var shared:Singleton{
        print("side effects here")
        return _shared
    }
    func location() {
        
    }
    
    
    
}
