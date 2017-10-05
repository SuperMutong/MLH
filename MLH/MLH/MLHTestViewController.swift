//
//  MLHTestViewController.swift
//  MLH
//
//  Created by Haitang on 17/6/19.
//  Copyright © 2017年 Haitang. All rights reserved.
//

import UIKit






class MLHTestViewController: MLHBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDefaultBackItemWithBackArrow()
        self.navigationController?.navigationBar.isHidden = false
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        
    }
 
    @IBAction func sliderAction(_ sender: UISlider) {

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
