//
//  MLHPlayerControlView.swift
//  MLH
//
//  Created by Haitang on 17/7/18.
//  Copyright © 2017年 Haitang. All rights reserved.
//

import UIKit

let MLHPlayerAnimationTimeInterval = 7.0
let MLHPlayerControlBarAutoFadeOutTimeInterval = 0.35

class MLHPlayerControlView: UIView,UIGestureRecognizerDelegate {
    
    open func playerDownloadBtn(state:Bool) {
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubViews()
        self.makeSubViewsConstraints()
    }
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //分辨率的view
    fileprivate var resolutionView:UIView?
    //当前选中的分辨率 btn 按钮
    fileprivate var resoultionCurrentBtn:UIButton?
    // 分辨率的名称
    fileprivate var resolutionArray:NSArray?
    //显示控制层
    fileprivate var showing:Bool?
    //小屏播放
    fileprivate var shrink:Bool?
    //在 cell 上播放
    fileprivate var cellVideo:Bool?
    //是否拖拽 slider 控制播放进度
    fileprivate var dragged:Bool?
    //是否播放结束
    fileprivate var playEnd:Bool?
    //是否全屏播放
    fileprivate var fullScreen:Bool?
    //标题
    fileprivate lazy var titleLabel:UILabel = {
        let label:UILabel = UILabel()
        label.textColor = UIColor.white
        label.text = "测试数据"
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    //开始播放按钮
    fileprivate lazy var startBtn:UIButton = {
        let btn:UIButton = UIButton(type: .custom)
        btn.setImage(UIImage(named: "ZFPlayer_play"), for: .normal)
        btn.setImage(UIImage(named: "ZFPlayer_pause"), for: .selected)
        btn.addTarget(self, action: #selector(playBtnClick), for: .touchUpInside)
        return btn
    }()
    //当前播放时长 label
    fileprivate lazy var currentTimeLabel:UILabel = {
        let label:UILabel = UILabel()
        label.text = "123123"
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()
    //视频总时间 label
    fileprivate lazy var totalTimeLabel:UILabel = {
        let lab:UILabel = UILabel()
        lab.text = "2113234"
        lab.textColor = UIColor.white
        lab.font = UIFont.systemFont(ofSize: 12)
        lab.textAlignment = .center
        return lab
    }()
    //缓冲进度条
    fileprivate lazy var progressView:UIProgressView = {
        let pro:UIProgressView = UIProgressView(progressViewStyle: .default)
        pro.progressTintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        pro.trackTintColor = .clear
        return pro
    }()
    //滑竿
    fileprivate lazy var videoSlider:UISlider = {
        let slider:UISlider = UISlider()
        slider.setThumbImage(UIImage(named:"ZFPlayer_slider"), for: .normal)
        slider.maximumValue = 1
        slider.minimumTrackTintColor = UIColor.white
        slider.maximumTrackTintColor = UIColor(0.5, g: 0.5, b: 0.5, a: 0.5)
        slider.addTarget(self, action: #selector(progressSliderTouchBegin(btn:)), for: .touchDown)
        slider.addTarget(self, action: #selector(progressSliderValueChanged(btn:)), for: .valueChanged)
        slider.addTarget(self, action: #selector(progressSliderTouchEnded(btn:)), for: [.touchUpInside,.touchCancel,.touchUpOutside])
        
        let sliderTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapSliderAction(tap:)))
        slider.addGestureRecognizer(sliderTap)
        
//        let panRecognizer:UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panRecognizer(pan:)))
//        panRecognizer.delegate = self
//        panRecognizer.maximumNumberOfTouches = 1
//        panRecognizer.delaysTouchesBegan = true
//        panRecognizer.delaysTouchesEnded = true
//        panRecognizer.cancelsTouchesInView = true
//        slider.addGestureRecognizer(panRecognizer)
        return slider
    }()
    //全屏按钮
    fileprivate lazy var fullScreenBtn:UIButton = {
        let btn:UIButton = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "ZFPlayer_fullscreen"), for: .normal)
        btn.setImage(UIImage(named: "ZFPlayer_shrinkscreen"), for: .selected)
        btn.addTarget(self, action: #selector(fullScreenBtnClick(btn:)), for: .touchUpOutside)
        return btn
    }()
    //锁定屏幕方向按钮
    fileprivate var lockBtn:UIButton = {
        let  btn:UIButton = UIButton(type: .custom)
        btn.setImage(UIImage(named: "ZFPlayer_unlock-nor"), for: .normal)
        btn.setImage(UIImage(named: "ZFPlayer_lock-nor"), for: .selected)
        btn.addTarget(self, action: #selector(lockScrrenBtnClick(btn:)), for: .touchUpOutside)
        return btn
    }()
    //系统菊花
    fileprivate var activity:MMMaterialDesignSpinner = {
        let activity:MMMaterialDesignSpinner = MMMaterialDesignSpinner()
        activity.lineWidth = 1
        activity.duration = 1
        activity.tintColor = UIColor.white.withAlphaComponent(0.9)
        return activity
    }()
    //返回按钮
    fileprivate var backBtn:UIButton = {
        let backBtn:UIButton = UIButton(type: .custom)
        backBtn.setImage(UIImage(named: "ZFPlayer_back_full"), for: .normal)
        backBtn.addTarget(self, action: #selector(backBtnClick(btn:)), for: .touchUpInside)
        return backBtn
    }()
    //关闭按钮
    fileprivate var closeBtn:UIButton = {
        let btn:UIButton = UIButton(type: .custom)
        btn.setImage(UIImage(named: "ZFPlayer_close"), for: .normal)
        btn.addTarget(self, action: #selector(closeBtnClick(btn:)), for: .touchUpInside)
        btn.isHidden = true
        return btn
    }()
    //重播按钮
    fileprivate var repeatBtn:UIButton = {
        let btn:UIButton = UIButton(type: .custom)
        btn.setImage(UIImage(named: "ZFPlayer_repeat_video"), for: .normal)
        btn.addTarget(self, action: #selector(repeatBtnClick(btn:)), for: .touchUpInside)
        btn.isHidden = true
        return btn
    }()
    //bottomView
    fileprivate var bottomImageView:UIImageView = {
        let imageView:UIImageView = UIImageView(image: UIImage(named: "ZFPlayer_bottom_shadow"))
        imageView.isUserInteractionEnabled = true
//        imageView.alpha = 0.0
        
        return imageView
    }()
    //topView
    fileprivate var topImageView:UIImageView = {
        let imageView:UIImageView = UIImageView(image: UIImage(named: "ZFPlayer_top_shadow"))
        imageView.isUserInteractionEnabled = true
//        imageView.alpha = 0.0
        return imageView
    }()
    //缓存 btn
    fileprivate var downLoadBtn:UIButton = {
        let downBtn:UIButton = UIButton(type: .custom)
        downBtn.setImage(UIImage(named: "ZFPlayer_download"), for: .normal)
        downBtn.setImage(UIImage(named: "ZFPlayer_not_download"), for: .disabled)
        downBtn.addTarget(self, action: #selector(downloadBtnClick(btn:)), for: .touchUpInside)
        return downBtn
    }()
    //切换分辨率按钮
    fileprivate var resolutionBtn:UIButton = {
        let resolutionBtn = UIButton(type: .custom)
        resolutionBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        resolutionBtn.backgroundColor = UIColor(0, g: 0, b: 0, a: 0.7)
        resolutionBtn.addTarget(self, action: #selector(resolutionBtnClick(btn:)), for: .touchUpInside)
        return resolutionBtn
    }()

    //播放按钮
    fileprivate var playBtn:UIButton = {
        let btn:UIButton = UIButton(type: .custom)
        btn.setImage(UIImage(named: "ZFPlayer_play_btn"), for: .normal)
        btn.addTarget(self, action: #selector(centerPlayBtnClick(btn:)), for: .touchUpInside)
        btn.isHidden = true
        return btn
    }()
    //加载失败按钮
    fileprivate var failBtn:UIButton = {
        let failbtn:UIButton = UIButton(type: .system)
        failbtn.setTitle("加载失败,点击重试", for: .normal)
        failbtn.setTitleColor(UIColor.white, for: .normal)
        failbtn.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        failbtn.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        failbtn.addTarget(self, action: #selector(failBtnClick(btn:)), for: .touchUpInside)
        failbtn.isHidden = true
        return failbtn
    }()
    //快进快退 view
    fileprivate var fastView:UIView = {
        let view:UIView = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
//        view.isHidden = true
        return view
    }()
    //快进快退进度 progress
    fileprivate var fastProgressView:UIProgressView = {
        let progressView:UIProgressView = UIProgressView()
        progressView.progressTintColor = UIColor.white
        progressView.trackTintColor = UIColor.lightGray.withAlphaComponent(0.4)
        return progressView
    }()
    //快进快退时间
    fileprivate var fastTimeLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = "123"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    //快退快进 ImageView
    fileprivate var fastImageView:UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    //占位图
    fileprivate var placeholderImageView:UIImageView = {
        let imageView:UIImageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    //控制层消失时在底部显示的播放进度 progress
    fileprivate var bottomProgressView:UIProgressView = {
        let progressView:UIProgressView = UIProgressView()
        progressView.progressTintColor = UIColor.white
        progressView.trackTintColor = UIColor.clear
        return progressView
    }()
}


extension MLHPlayerControlView{
    
    func makeSubViewsConstraints(){
        self.placeholderImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        self.closeBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(self.snp.trailing).offset(7)
            make.top.equalTo(self.snp.top).offset(-7)
            make.width.height.equalTo(20)
        }
        self.topImageView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self)
            make.top.equalTo(self.snp.top).offset(0)
            make.height.equalTo(50)
        }
        self.backBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(self.topImageView.snp.leading).offset(10)
            make.top.equalTo(self.topImageView.snp.top).offset(3)
            make.width.height.equalTo(40)
        }
        self.downLoadBtn.snp.makeConstraints { (make) in
            make.width.equalTo(40)
            make.height.equalTo(49)
            make.trailing.equalTo(self.topImageView.snp.trailing).offset(-10)
            make.centerY.equalTo(self.backBtn.snp.centerY)
        }
        self.resolutionBtn.snp.makeConstraints { (make) in
            make.width.equalTo(40)
            make.height.equalTo(25)
            make.trailing.equalTo(self.downLoadBtn.snp.leading).offset(-10)
            make.centerY.equalTo(self.backBtn.snp.centerY)
        }
        self.titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.backBtn.snp.trailing).offset(5)
            make.centerY.equalTo(self.backBtn.snp.centerY)
            make.trailing.equalTo(self.resolutionBtn.snp.leading).offset(-10)
        }
        self.bottomImageView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(0)
            make.height.equalTo(50)
        }
        self.startBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(self.bottomImageView.snp.leading).offset(5)
            make.bottom.equalTo(self.bottomImageView.snp.bottom).offset(-5)
            make.width.height.equalTo(30)
        }
        self.currentTimeLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.startBtn.snp.trailing).offset(-3)
            make.centerY.equalTo(self.startBtn.snp.centerY)
            make.width.equalTo(43)
        }
        self.fullScreenBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(30)
            make.trailing.equalTo(self.bottomImageView.snp.trailing).offset(-5)
            make.centerY.equalTo(self.startBtn.snp.centerY)
        }
        self.totalTimeLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(self.fullScreenBtn.snp.leading).offset(3)
            make.centerY.equalTo(self.startBtn.snp.centerY)
            make.width.equalTo(43)
        }
        self.progressView.snp.makeConstraints { (make) in
            make.leading.equalTo(self.currentTimeLabel.snp.trailing).offset(4)
            make.trailing.equalTo(self.totalTimeLabel.snp.leading).offset(-4)
            make.centerY.equalTo(self.startBtn.snp.centerY)
        }
        self.videoSlider.snp.makeConstraints { (make) in
            make.leading.equalTo(self.currentTimeLabel.snp.trailing).offset(4)
            make.trailing.equalTo(self.totalTimeLabel.snp.leading).offset(-4)
            make.centerY.equalTo(self.currentTimeLabel.snp.centerY)
            make.height.equalTo(30)
        }
        self.lockBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(self.snp.leading).offset(15)
            make.centerY.equalTo(self.snp.centerY)
            make.height.width.equalTo(32)
        }
        self.repeatBtn.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }
        self.playBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(50)
            make.center.equalTo(self)
        }
        self.activity.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.width.height.equalTo(45)
        }
        self.failBtn.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.width.equalTo(130)
            make.height.equalTo(33)
        }
        self.fastView.snp.makeConstraints { (make) in
            make.width.equalTo(125)
            make.height.equalTo(80)
            make.center.equalTo(self)
        }
        self.fastImageView.snp.makeConstraints { (make) in
            make.width.equalTo(32)
            make.height.equalTo(32)
            make.top.equalTo(5)
            make.centerX.equalTo(self.fastView.snp.centerX)
        }
        self.fastTimeLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(0)
            make.top.equalTo(self.fastImageView.snp.bottom).offset(2)
        }
        self.fastProgressView.snp.makeConstraints { (make) in
            make.leading.equalTo(12)
            make.trailing.equalTo(-12)
            make.top.equalTo(self.fastTimeLabel.snp.bottom).offset(10)
        }
        self.bottomProgressView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(0)
            make.bottom.equalTo(0)
        }
    }
    
    func setupSubViews(){
        self.addSubview(self.placeholderImageView)
        self.addSubview(self.topImageView)
        self.addSubview(self.bottomImageView)
        
        self.bottomImageView.addSubview(self.startBtn)
        self.bottomImageView.addSubview(self.currentTimeLabel)
        self.bottomImageView.addSubview(self.progressView)
        self.bottomImageView.addSubview(self.videoSlider)
        self.bottomImageView.addSubview(self.fullScreenBtn)
        self.bottomImageView.addSubview(self.totalTimeLabel)
        
        self.topImageView.addSubview(self.downLoadBtn)
        self.topImageView.addSubview(self.backBtn)
        self.topImageView.addSubview(self.resolutionBtn)
        self.topImageView.addSubview(self.titleLabel)
        
        self.addSubview(self.lockBtn)
        self.addSubview(self.activity)
        self.addSubview(self.repeatBtn)
        self.addSubview(self.playBtn)
        self.addSubview(self.failBtn)
        
        self.addSubview(self.fastView)
        
        self.fastView.addSubview(self.fastImageView)
        self.fastView.addSubview(self.fastTimeLabel)
        self.fastView.addSubview(self.fastProgressView)
        
 
        self.addSubview(self.closeBtn)
        self.addSubview(self.bottomProgressView)
    }
    func playBtnClick(){
        
    }
    
    func progressSliderTouchBegin(btn:UIButton){
        
    }
    func progressSliderValueChanged(btn:UIButton){
        
    }
    func progressSliderTouchEnded(btn:UIButton){
        
    }
    func tapSliderAction(tap:UITapGestureRecognizer){
        
    }
    func panRecognizer(pan:UIPanGestureRecognizer){
        
    }
    
    func fullScreenBtnClick(btn:UIButton){
        
    }
    
    func lockScrrenBtnClick(btn:UIButton){
        
    }
    
    func closeBtnClick(btn:UIButton){
        
    }
    func backBtnClick(btn:UIButton){
        
    }
    func repeatBtnClick(btn:UIButton){
        
    }
    
    func downloadBtnClick(btn:UIButton){
        
    }
    func resolutionBtnClick(btn:UIButton){
        
    }
    
    func centerPlayBtnClick(btn:UIButton){
        
    }
    
    func failBtnClick(btn:UIButton){
        
    }
}


