//
//  MLHTabBarViewController.swift
//  魔力盒
//
//  Created by Haitang on 17/6/4.
//  Copyright © 2017年 Haitang. All rights reserved.
//

import UIKit

class MLHTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addChildControllers()
        // Do any additional setup after loading the view.
    }
   fileprivate func addChildControllers(){
        addChildController(childController: MLHMainViewController(), title: "魔力盒", imageName: "tabbar_mlh", selectImage: "tabbar_mlh_focus")
        addChildController(childController: MLHFindViewController(), title: "发现", imageName: "tabbar_fx", selectImage: "tabbar_fx_focus")
        addChildController(childController: MLHTVViewController(), title: "魔力TV", imageName: "tabbar_fx", selectImage: "tabbar_fx_focus")
        addChildController(childController: MLHMeViewController(), title: "我", imageName: "tabbar_me", selectImage: "tabbar_me_focus")
    
    }
   fileprivate func addChildController(childController:UIViewController, title:String,imageName:String,selectImage:String)  {
        childController.tabBarItem.image = UIImage(named:imageName)
        childController.tabBarItem.title = title
        childController.tabBarItem.selectedImage = UIImage(named: selectImage)
        let nav = MLHNavigationViewController(rootViewController: childController)
        addChildViewController(nav)
    }
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
