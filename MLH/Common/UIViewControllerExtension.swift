//
//  UIViewControllerExtension.swift
//  MLH
//
//  Created by Haitang on 17/6/19.
//  Copyright © 2017年 Haitang. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    func backAction() {
        guard let nav = self.navigationController, nav.viewControllers.count>1 else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        nav.popViewController(animated: true)
    }
    
}

