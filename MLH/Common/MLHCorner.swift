//
//  tgCorner.swift
//  tg
//
//  Created by Haitang on 17/7/7.
//  Copyright © 2017年 Haitang. All rights reserved.
//

import Foundation
import UIKit
//copy by https://github.com/bestswifter/MySampleCode/tree/master/CornerRadius



extension UIImage{
    
    
    func tg_drawRectWithRounderCorner(radius:CGFloat,
                                       cornerDirection:UIRectCorner,
                                      sizeToFit:CGSize) -> UIImage {
        
        let rect = CGRect(x: 0, y: 0, width: sizeToFit.width, height: sizeToFit.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        UIGraphicsGetCurrentContext()?.addPath(UIBezierPath(roundedRect: rect, byRoundingCorners:cornerDirection, cornerRadii: CGSize(width: radius, height: radius)).cgPath)
        UIGraphicsGetCurrentContext()?.clip()
        self.draw(in: rect)
        UIGraphicsGetCurrentContext()?.drawPath(using: .fillStroke)
        let output = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return output!
    }
    func tg_drawRectWithRounderCorner(radius:CGFloat,
                                       sizeToFit:CGSize) -> UIImage {
        return tg_drawRectWithRounderCorner(radius: radius, cornerDirection: .allCorners, sizeToFit: sizeToFit)
    }
}
extension UIImageView{
    override func tg_addCorner(radius:CGFloat) {
        self.image = self.image?.tg_drawRectWithRounderCorner(radius: radius, cornerDirection: UIRectCorner.allCorners, sizeToFit: self.bounds.size)
    }
    override func tg_addCorner(radius:CGFloat,cornerDirection:UIRectCorner){
        self.image = self.image?.tg_drawRectWithRounderCorner(radius: radius, cornerDirection: cornerDirection, sizeToFit: self.bounds.size)
    }
}
extension UIView{
    func tg_addCorner(radius:CGFloat)  {
        self.tg_addCorner(radius: radius, borderWidth: 1, backGroundColor: UIColor.clear, borderColor: UIColor.clear, cornerDirection: UIRectCorner.allCorners)
    }
    func tg_addCorner(radius:CGFloat,
                       cornerDirection:UIRectCorner){
        self.tg_addCorner(radius: radius, borderWidth: 1, backGroundColor: UIColor.clear, borderColor: UIColor.black, cornerDirection: cornerDirection)
    }
    func tg_addCorner(radius:CGFloat,
                       borderWidth:CGFloat,
                       backGroundColor:UIColor,
                       borderColor:UIColor){
        self.tg_addCorner(radius: radius, borderWidth: borderWidth, backGroundColor: backGroundColor, borderColor: borderColor, cornerDirection: .allCorners)
    }
    func tg_addCorner(radius:CGFloat,
                       borderWidth:CGFloat,
                       backGroundColor:UIColor,
                       borderColor:UIColor,
                       cornerDirection:UIRectCorner){
        let imageView:UIImageView = UIImageView(image: tg_drawRectWithRoundedCorner(radius, borderWidth: borderWidth, backgroundColor: backGroundColor, borderColor: borderColor))
        self.insertSubview(imageView, at: 0)
    }
    func tg_drawRectWithRoundedCorner(_ radius: CGFloat,
                                      borderWidth: CGFloat,
                                      backgroundColor: UIColor,
                                      borderColor: UIColor) -> UIImage {
        let sizeToFit = CGSize(width: Double(self.bounds.size.width), height: Double(self.bounds.size.height))
        let halfBouderWidth = CGFloat(borderWidth/2.0)
        UIGraphicsBeginImageContextWithOptions(sizeToFit, false, UIScreen.main.scale)
        let context:CGContext = UIGraphicsGetCurrentContext()!
        context.setLineWidth(borderWidth)
        context.setStrokeColor(borderColor.cgColor)
        context.setFillColor(backgroundColor.cgColor)
        let width = sizeToFit.width
        let height = sizeToFit.height
        context.move(to: CGPoint(x: width - halfBouderWidth, y: radius+halfBouderWidth))
        //右下角
        context.addArc(tangent1End: CGPoint(x:width-halfBouderWidth,y:height-halfBouderWidth),tangent2End: CGPoint(x:(width-radius-halfBouderWidth),y:(height-halfBouderWidth)),radius: radius)
        //左下角
        context.addArc(tangent1End: CGPoint(x: halfBouderWidth, y: height-halfBouderWidth), tangent2End: CGPoint(x: halfBouderWidth, y: height-radius-halfBouderWidth), radius: radius)
        //
        context.addArc(tangent1End: CGPoint(x: halfBouderWidth, y: halfBouderWidth), tangent2End: CGPoint(x:width-halfBouderWidth, y: halfBouderWidth) , radius: radius)
        //右上角
        context.addArc(tangent1End: CGPoint(x: width-halfBouderWidth, y: halfBouderWidth), tangent2End: CGPoint(x: width - halfBouderWidth, y: radius+halfBouderWidth), radius: radius)
        UIGraphicsGetCurrentContext()?.drawPath(using: .fillStroke)
        let output = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return output!
    }
    
}













