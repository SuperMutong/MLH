//
//  HUD.swift
//  MLH
//
//  Created by Haitang on 17/10/9.
//  Copyright © 2017年 Haitang. All rights reserved.
//

import UIKit
import MBProgressHUD
class HUD{
    static func show(view:UIView,message:String) -> MBProgressHUD{
        let hud:MBProgressHUD = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .text
        hud.label.text = message
        hud.show(animated: true)
        hud.hide(animated: true, afterDelay: 1.5)
        return hud
    }
}

































