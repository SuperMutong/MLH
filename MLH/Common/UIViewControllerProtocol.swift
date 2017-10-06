//
//  UIViewControllerProtocol.swift
//  MLH
//
//  Created by Haitang on 17/6/20.
//  Copyright © 2017年 Haitang. All rights reserved.
//

import Foundation
import UIKit
protocol ViewControllerProtocol {
    
}
extension ViewControllerProtocol where Self:UIViewController{
    
    
    /// 默认返回键
    func setDefaultBackItemWithBackArrow() {
        if ((self.navigationController != nil) && self.navigationController?.viewControllers.first != self) || self.navigationController == nil  {
            let leftItem:UIBarButtonItem = setDefaultBackItem(image: UIImage(named: "bc_back")!, selectedImage: UIImage(named: "bc_back")!, vc: self)
            let spaceBar = getLeftBarSpaceButton()
            self.navigationItem.leftBarButtonItems = [spaceBar,leftItem]
        }
    }
    
    /// 自定义返回键
    ///
    /// - Parameters:
    ///   - image: <#image description#>
    ///   - selectedImage: <#selectedImage description#>
    ///   - target: <#target description#>
    ///   - action: <#action description#>
    func setLeftItem(image:UIImage?,selectedImage:UIImage?,target:Any?,action:Selector?){
        let leftItem:UIBarButtonItem = barWith(image: image, selectedImage: selectedImage, backgroundImage: nil, selectedBackgroundImage: nil, target: target, action: action)
        let spaceBar = getLeftBarSpaceButton()
        self.navigationItem.leftBarButtonItems = [spaceBar,leftItem]
    }
    
    /// 自定义右侧键
    ///
    /// - Parameters:
    ///   - image: <#image description#>
    ///   - selectedImage: <#selectedImage description#>
    ///   - target: <#target description#>
    ///   - action: <#action description#>
    func setRightItem(image:UIImage?,selectedImage:UIImage?,target:Any?,action:Selector?){
        let rightItem:UIBarButtonItem = barWith(image: image, selectedImage: selectedImage, backgroundImage: nil, selectedBackgroundImage: nil, target: target, action: action)
        self.navigationItem.rightBarButtonItem = rightItem
    }
    func setNavgationBarImage(image:UIImage?){
        self.navigationController?.navigationBar.setBackgroundImage(image, for: .default)
    }
    
    func closeTranslucent() {
        self.navigationController?.navigationBar.isTranslucent = false
    }
}
func setDefaultBackItem(image:UIImage , selectedImage:UIImage,vc:UIViewController) -> UIBarButtonItem{
    let leftItem:UIBarButtonItem = barWith(image:image, selectedImage:selectedImage, backgroundImage: nil, selectedBackgroundImage: nil, target:vc , action:#selector(vc.backAction))
    return leftItem;
}

func getLeftBarSpaceButton() -> UIBarButtonItem{
    let navigationSpace = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
    navigationSpace.width = spaceOffsetForLeftButton()
    return navigationSpace
}

func spaceOffsetForLeftButton() -> CGFloat{
    return -20.0;
}

func barWith(image:UIImage?,selectedImage:UIImage?,backgroundImage:UIImage?,selectedBackgroundImage:UIImage?,target:Any?,action:Selector?) -> UIBarButtonItem {
    let button:UIButton = UIButton(type: .custom)
    if (image != nil) {
        button.setImage(image, for: .normal)
    }
    if selectedImage != nil {
        button.setImage(selectedImage, for: .highlighted)
        button.setImage(selectedImage, for: .selected)
    }
    if backgroundImage != nil {
        button.setBackgroundImage(backgroundImage, for: .normal)
    }
    if selectedBackgroundImage != nil {
        button.setBackgroundImage(selectedBackgroundImage, for: .highlighted)
        button.setBackgroundImage(selectedBackgroundImage, for: .selected)
    }
    if target != nil && action != nil {
        button.addTarget(target, action:  action!, for: .touchUpInside)
    }
    let w = 44.0
    let h = 44.0
    button.frame = CGRect(x: 0, y: 0, width: w, height: h)
    
    let buttonItem:UIBarButtonItem = UIBarButtonItem(customView: button)
    buttonItem.style = UIBarButtonItemStyle.plain
    return buttonItem
}
