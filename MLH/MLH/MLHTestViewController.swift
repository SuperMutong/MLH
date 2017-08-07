//
//  MLHTestViewController.swift
//  MLH
//
//  Created by Haitang on 17/6/19.
//  Copyright © 2017年 Haitang. All rights reserved.
//

import UIKit






class MLHTestViewController: MLHBaseViewController {
    let volumeView:MLHVolumeView = {
        let view = MLHVolumeView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDefaultBackItemWithBackArrow()
        self.navigationController?.navigationBar.isHidden = false
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.volumeView)
        
    }
 
    @IBAction func sliderAction(_ sender: UISlider) {
        self.volumeView.volumeValue = CGFloat(sender.value)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
