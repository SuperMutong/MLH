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
        self.navigationController?.navigationBar.isHidden = true
//        let player:MLHPlayer = MLHPlayer.shared
//        player.playerView = MLHPlayerView()
//        view.addSubview(player.playerView!)
        
//        
//        let btn:UIButton = UIButton(type: .custom)
//        btn.backgroundColor = UIColor.red
//        self.view.addSubview(btn)
//        btn.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(0, 0, 0, 0))
//        }
//        
//        let view:UIView = UIView()
//        view.backgroundColor = UIColor.white
//        btn.addSubview(view)
//        
//        
//        view.snp.makeConstraints { (make) in
//            make.trailing.equalTo(view.snp.trailing).offset(7)
//            make.top.equalTo(view.snp.top).offset(-7)
//            make.width.height.equalTo(20)
//        }
        
        let view:MLHPlayerControlView = MLHPlayerControlView()
         self.view.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.trailing.leading.top.equalTo(0)
            make.height.equalTo(200)
        }

        
//        let slider:UISlider = UISlider(frame: CGRect(x: 0, y: 300, width: KScreenWidth, height: 30))
//        slider.setThumbImage(UIImage(named:"ZFPlayer_slider"), for: .normal)
//        slider.maximumValue = 1
//        slider.minimumTrackTintColor = UIColor.white
//        slider.maximumTrackTintColor = UIColor(0.5, g: 0.5, b: 0.5, a: 0.5)
//     
//        self.view.addSubview(slider)
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
