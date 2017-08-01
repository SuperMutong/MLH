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

        // Do any additional setup after loading the view.
        let sing:Singleton = Singleton.shared
        
//        let player:MLHPlayer = MLHPlayer.shared
//        player.playerView = MLHPlayerView()
//        view.addSubview(player.playerView!)
        
        
//        let btn:UIButton = UIButton(type: .custom)
//        btn.backgroundColor = UIColor.red
//        self.view.addSubview(btn)
//
//        btn.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) as! ConstraintOffsetTarget)
//        }

    }
 
    @IBAction func pushAction(_ sender: Any) {
        let vc = MLHTestViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
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
