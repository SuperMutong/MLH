//
//  ImageTint.swift
//  MLH
//
//  Created by Haitang on 17/7/4.
//  Copyright © 2017年 Haitang. All rights reserved.
//
import Foundation
import UIKit

// copy by 王 巍
extension UIImage{
    func getImage(tintColor:UIColor) -> UIImage {
        return getImage(tintColor: tintColor, blendModel: .destinationIn)
    }
    func getImage(gradientTintColor:UIColor) -> UIImage{
        return getImage(tintColor: gradientTintColor, blendModel: .overlay)
    }
    func getImage(tintColor:UIColor,blendModel:CGBlendMode) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        tintColor.setFill()
        let bounds : CGRect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        UIRectFill(bounds)
        
        self.draw(in: bounds, blendMode: blendModel, alpha: 1.0)
        if  blendModel != .destinationIn {
            self.draw(in: bounds, blendMode: .destinationIn, alpha: 1.0)
        }
        let tintedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return tintedImage
    }
  
    class func createImage(color:UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context:CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
















