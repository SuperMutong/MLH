//
//  MLHBrightnessView.swift
//  MLH
//
//  Created by Haitang on 17/7/29.
//  Copyright © 2017年 Haitang. All rights reserved.
//

import UIKit

public final class MLHBrightness{
    private static let _shared = MLHBrightness()
    private init(){}
    var playerView:MLHBrightnessView?
    //是否锁定屏幕方向
    var isLockScreen:Bool?
    //是否允许横屏, 来控制只有竖屏的状态
    var isAllowLandscape:Bool?{
        didSet{
            AppDelegateInstance.currentViewController?.setNeedsStatusBarAppearanceUpdate()
        }
    }
    var isStatusBarHidden:Bool?{
        didSet{
            AppDelegateInstance.currentViewController?.setNeedsStatusBarAppearanceUpdate()
        }
    }
    //是否是横屏状态
    var isLandscape:Bool?
    public static var shared:MLHBrightness{
        return _shared
    }
}


class MLHBrightnessView: UIView {

    
    fileprivate var backImage:UIImageView?
    fileprivate var title:UILabel?
    fileprivate var longView:UIView?
    fileprivate var tipArray = [Any]()
    fileprivate var orientationDidChange:Bool?
    override init(frame: CGRect) {
       super.init(frame: frame)
        createSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        UIScreen.main.removeObserver(self, forKeyPath: "brightness")
        NotificationCenter.default.removeObserver(self)
    }
}
extension MLHBrightnessView{
    func createSubViews() {
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        let toolbar:UIToolbar = UIToolbar(frame: self.bounds)
        toolbar.alpha = 0.97
        self.addSubview(toolbar)
        
        self.backImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 79, height: 76))
        self.backImage?.image = UIImage(named: "ZFPlayer_brightness")
        self.addSubview(self.backImage!)
        
        self.title = UILabel(frame: CGRect(x: 0, y: 5, width: self.width, height: 30))
        self.title?.font = UIFont.boldSystemFont(ofSize: 16)
        self.title?.textColor = UIColor(0.25, g: 0.22, b: 0.21, a: 1.0)
        self.title?.textAlignment = .center
        self.title?.text = "亮度"
        self.addSubview(self.title!)
        
        self.longView = UIView(frame: CGRect(x: 13, y: 132, width: self.width-26, height: 7))
        self.longView?.backgroundColor = UIColor(red: 0.25, green: 0.22, blue: 0.21, alpha: 1)
        self.addSubview(self.longView!)
        self.createTips()
        self.addNotification()
        self.addObserver()
        self.alpha = 0.0
    }
    
    //创建 Tips
    private func createTips(){
        let tipW:CGFloat = ((self.longView?.width)!-17)/16.0
        let tipH:CGFloat = 5
        let tipY:CGFloat = 1
        for var i:Int in 0...15 {
            let tipX:CGFloat = CGFloat(i)*(tipW+1)+1
            let image:UIImageView = UIImageView(frame: CGRect(x: tipX, y: tipY, width: tipW, height: tipH))
            image.backgroundColor = UIColor.white
            self.longView?.addSubview(image)
            self.tipArray+=[image]
        
        }
        self.updateLongView(sound:UIScreen.main.brightness)
    }
    
    private func updateLongView(sound:CGFloat){
        let stage:CGFloat = 1.0/15.0
        let level:NSInteger = NSInteger(sound/stage)
        
        for var i:Int in 0...self.tipArray.count {
            let img:UIImageView = self.tipArray[i] as! UIImageView
            if i <= level{
                img.isHidden = false
            }
            else{
                img.isHidden = true
            }
        }
    }
    
    private func addNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(updateLayer(notify:)), name: .UIDeviceOrientationDidChange, object: nil)
    
    }
    func updateLayer(notify:Notification){
        self.orientationDidChange = true
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    
    private func addObserver(){
        UIScreen.main.addObserver(self, forKeyPath: "brightness", options: .new, context: nil)
    }
    private func appearSoundView(){
        if self.alpha == 0.0 {
            self.orientationDidChange = false
            self.alpha = 1.0
            DispatchQueue.main.asyncAfter(deadline: 3.0, execute: { 
                self.disAppearSoundView()
            })
        }
    }
    
    private func disAppearSoundView(){
        if self.alpha == 1.0 {
            UIView.animate(withDuration: 0.8, animations: { 
                self.alpha = 0.0
            })
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        let sound:CGFloat = change![NSKeyValueChangeKey(rawValue: "new")] as! CGFloat
        self.appearSoundView()
        self.updateLongView(sound: sound)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backImage?.center = CGPoint(x: self.width/2.0, y: self.height/2.0)
        self.center = CGPoint(x: KScreenWidth, y: KScreenHeight)
    }

}






















