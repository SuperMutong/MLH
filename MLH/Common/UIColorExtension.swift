//
//  UIColorExtension.swift
//
//
//  Created by Haitang on 17/6/24.
//  Copyright © 2017年 Haitang. All rights reserved.
//

import Foundation
import UIKit
public extension UIColor{
    public convenience init(_ r:CGFloat,g:CGFloat,b:CGFloat, a:CGFloat) {
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
    
    public convenience init(_ hex:Int){
        if hex > 0xffffff{
            print("越狱了啊")
        }
        let r:Int = (hex >> 16) & 0xFF
        let g:Int = (hex >> 8) & 0xFF
        let b:Int = (hex) & 0xFF
        self.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1.0)
    }
    
}






















