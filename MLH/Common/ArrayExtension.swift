//
//  ArrayExtension.swift
//  MLH
//
//  Created by Haitang on 17/6/15.
//  Copyright © 2017年 Haitang. All rights reserved.
//

import Foundation
extension Array {
   public subscript (safe index:Int) -> Element? {
        guard (0..<count).contains(index) else {
            print("数据取值越界了")
            return nil;
        }
        return self[index]
    }
}
 
