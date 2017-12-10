//
//  MLHPlayerViewController.swift
//  MLH
//
//  Created by Haitang on 17/10/6.
//  Copyright © 2017年 Haitang. All rights reserved.
//

import UIKit
import ZFPlayer
class MLHPlayerViewController: MLHBaseViewController {
    var playerView:ZFPlayerView? = nil
    var videoData:MLHFindMagicTVPosts?
    override func viewDidLoad() {
        super.viewDidLoad()
        configSubViews()
        // Do any additional setup after loading the view.
        configNavigation()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    func configSubViews(){
        self.view.backgroundColor = UIColor.white;
        let playerFatherView = UIView(frame: CGRect(x: 0, y: 0, width: KScreenWidth, height: 230))
        self.view.addSubview(playerFatherView)
        self.playerView = ZFPlayerView()
        self.playerView?.delegate = self
        let playerModel:ZFPlayerModel = ZFPlayerModel()
        playerModel.fatherView = playerFatherView
        playerModel.videoURL = URL(string:(self.videoData?.source_link)!)
        self.playerView?.playerControlView(nil, playerModel: playerModel)
        self.playerView?.autoPlayTheVideo()
    }
    func configNavigation(){
        let rightButton:UIButton = UIButton(frame: CGRect(x: KScreenWidth - 40, y: 10, width: 30, height: 30))
        rightButton.setImage(UIImage(named: "card_share"), for: .normal)
        rightButton.addTarget(self, action: #selector(shareAction), for: .touchUpInside)
        self.view.addSubview(rightButton)
    }
    func back(){
        self.navigationController?.popViewController(animated: true)
    }
    func shareAction(){
        print("分享")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MLHPlayerViewController:ZFPlayerDelegate{
    func zf_playerBackAction() {
        self.navigationController?.popViewController(animated: true)

    }
}
