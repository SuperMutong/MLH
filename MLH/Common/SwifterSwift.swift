
//
//  SwifterSwift.swift
//  MLH
//
//  Created by Haitang on 17/6/24.
//  Copyright © 2017年 Haitang. All rights reserved.
//

import Foundation
import UIKit

let KScreenWidth = UIScreen.main.bounds.width
let KScreenHeight = UIScreen.main.bounds.height
let KeyWindow = UIApplication.shared.keyWindow
let AppDelegateInstance:AppDelegate = (UIApplication.shared.delegate) as! AppDelegate

public struct SwifterSwift{

    public static var mostTopViewController:UIViewController?{
        get {
            
            return UIApplication.shared.keyWindow?.rootViewController
        }
        set {
            UIApplication.shared.keyWindow?.rootViewController = newValue
        }
    }
}
