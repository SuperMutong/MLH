//
//  MLHMainViewController.swift
//  MLH
//
//  Created by Haitang on 17/6/4.
//  Copyright © 2017年 Haitang. All rights reserved.
//

import UIKit
import SnapKit




class MLHMainViewController: MLHBaseViewController {
    var hs:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
    }
    func singleTapAction(tap:UITapGestureRecognizer){
        
        if tap is NSNumber.Type {
            print(tap)
        }
        else{
            print(tap)
        }
    }
    
    @IBAction func pushAction(_ sender: Any) {
        self.perform(#selector(singleTapAction(tap:)), with:true)
        
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
