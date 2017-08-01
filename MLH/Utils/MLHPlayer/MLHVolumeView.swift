//
//  MLHVolumeView.swift
//  MLH
//
//  Created by Haitang on 17/7/12.
//  Copyright © 2017年 Haitang. All rights reserved.
//

import UIKit

class MLHVolumeView: UIView {

    var volumeValue:CGFloat?{
        didSet{
            print(volumeValue)
            let tag = Int(volumeValue!*11.9)
            print(tag)
            for var i:Int  in 0...tag {
                let view:UIView = self.viewWithTag(i+100)!
                view.backgroundColor = UIColor.red
            }
            for var i:Int in tag+1..<12 {
                let view:UIView = self.viewWithTag(i+100)!
                view.backgroundColor = UIColor.green
            }
            
        }
    }
    override init(frame: CGRect) {
       super.init(frame: frame)
         self.addSubViews()
    }
    func addSubViews()  {
        let centerView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        centerView.center = CGPoint(x: self.width/2.0, y: self.height/2.0)
        centerView.backgroundColor = UIColor.red
        self.addSubview(centerView)
        let corner = CGFloat(M_PI)/6.0
        for var i  in 0..<12 {
            let frame =  CGRect(x: self.width/2.0 - 3, y: self.height/2.0 - 25 - 5 - 8 - 8, width: 6, height: 16);
            let progressView:UIView = UIView(frame: frame)
            progressView.backgroundColor = UIColor.green
            progressView.tag = i + 100
            progressView.layer.anchorPoint = CGPoint(x: 0.5, y: (self.height/2.0 - progressView.bottom)/16 + 1)
            progressView.frame = frame;
            progressView.transform = CGAffineTransform(rotationAngle: corner * CGFloat(i))
            self.addSubview(progressView)
        }
        
        //label
        let progressLabel : UILabel = UILabel(frame: CGRect(x: 0, y: self.height-20, width: self.width, height: 20))
        progressLabel.textAlignment = .center
        progressLabel.textColor = UIColor.white
        progressLabel.text = "50%"
        self.addSubview(progressLabel)
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
