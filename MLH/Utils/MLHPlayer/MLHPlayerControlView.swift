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

protocol MLHPlayerControlDelegate {
    ///返回按钮事件
    func controlView(controlView:UIView, backAction:UIButton)
    ///cell 播放中小屏状态 关闭按钮事件
    func controlView(controlView:UIView, closeAction:UIButton)
    ///播放按钮事件
    func controlView(controlView:UIView, playAction:UIButton)
    ///全屏按钮事件
    func controlView(controlView:UIView, fullScreenAction:UIButton)
    ///锁定屏幕方向按钮事件
    func controlView(controlView:UIView, lockScreenAction:UIButton)
    ///重播按钮事件
    func controlView(controlView:UIView, repeatPlayAction:UIButton)
    ///中间播放按钮事件
    func controlView(controlView:UIView, centerPlayAction:UIButton)
    ///加载失败按钮事件
    func controlView(controlView:UIView, failAction:UIButton)
    ///下载按钮事件
    func controlView(controlView:UIView, downLoadVideoAction:UIButton)
    ///切换分辨率按钮事件
    func controlView(controlView:UIView, resolutionAction:UIButton)
    ///slider 的点击事件 (点击 slider 控制进度)
    func controlView(controlView:UIView, progressSliderTapValue:CGFloat)
    ///开始触摸 slider
    func controlView(controlView:UIView, progressSliderTouchBegin:UISlider)
    ///slider 触摸中
    func controlView(controlView:UIView, progressSliderTouchChanged:UISlider)
    ///slider 触摸结束
    func controlView(controlView:UIView, progressSliderTouchEnded:UISlider)
    ///控制层即将显示
    func controlViewWillShow(controlView:UIView, isFullScreen:Bool)
    ///控制层即将隐藏
    func controlViewWillHidden(controlView:UIView, isFullScreen:Bool)
}

class MLHPlayerControlView: UIView,UIGestureRecognizerDelegate {
    
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubViews()
        self.addNotification()
        self.listeningRotation()
        self.makeSubViewsConstraints()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var delegate:MLHPlayerControlDelegate?
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
        btn.addTarget(self, action: #selector(playBtnClick(btn:)), for: .touchUpInside)
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
        slider.addTarget(self, action: #selector(progressSliderTouchBegin(slider:)), for: .touchDown)
        slider.addTarget(self, action: #selector(progressSliderValueChanged(slider:)), for: .valueChanged)
        slider.addTarget(self, action: #selector(progressSliderTouchEnded(slider:)), for: [.touchUpInside,.touchCancel,.touchUpOutside])
        
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
    fileprivate lazy var lockBtn:UIButton = {
        let  btn:UIButton = UIButton(type: .custom)
        btn.setImage(UIImage(named: "ZFPlayer_unlock-nor"), for: .normal)
        btn.setImage(UIImage(named: "ZFPlayer_lock-nor"), for: .selected)
        btn.addTarget(self, action: #selector(lockScrrenBtnClick(btn:)), for: .touchUpOutside)
        return btn
    }()
    //系统菊花
    fileprivate lazy var activity:MMMaterialDesignSpinner = {
        let activity:MMMaterialDesignSpinner = MMMaterialDesignSpinner()
        activity.lineWidth = 1
        activity.duration = 1
        activity.tintColor = UIColor.white.withAlphaComponent(0.9)
        return activity
    }()
    //返回按钮
    fileprivate lazy var backBtn:UIButton = {
        let backBtn:UIButton = UIButton(type: .custom)
        backBtn.setImage(UIImage(named: "ZFPlayer_back_full"), for: .normal)
        backBtn.addTarget(self, action: #selector(backBtnClick(btn:)), for: .touchUpInside)
        return backBtn
    }()
    //关闭按钮
    fileprivate lazy var closeBtn:UIButton = {
        let btn:UIButton = UIButton(type: .custom)
        btn.setImage(UIImage(named: "ZFPlayer_close"), for: .normal)
        btn.addTarget(self, action: #selector(closeBtnClick(btn:)), for: .touchUpInside)
        btn.isHidden = true
        return btn
    }()
    //重播按钮
    fileprivate lazy var repeatBtn:UIButton = {
        let btn:UIButton = UIButton(type: .custom)
        btn.setImage(UIImage(named: "ZFPlayer_repeat_video"), for: .normal)
        btn.addTarget(self, action: #selector(repeatBtnClick(btn:)), for: .touchUpInside)
        btn.isHidden = true
        return btn
    }()
    //bottomView
    fileprivate lazy var bottomImageView:UIImageView = {
        let imageView:UIImageView = UIImageView(image: UIImage(named: "ZFPlayer_bottom_shadow"))
        imageView.isUserInteractionEnabled = true
//        imageView.alpha = 0.0
        
        return imageView
    }()
    //topView
    fileprivate lazy var topImageView:UIImageView = {
        let imageView:UIImageView = UIImageView(image: UIImage(named: "ZFPlayer_top_shadow"))
        imageView.isUserInteractionEnabled = true
//        imageView.alpha = 0.0
        return imageView
    }()
    //缓存 btn
    fileprivate lazy var downLoadBtn:UIButton = {
        let downBtn:UIButton = UIButton(type: .custom)
        downBtn.setImage(UIImage(named: "ZFPlayer_download"), for: .normal)
        downBtn.setImage(UIImage(named: "ZFPlayer_not_download"), for: .disabled)
        downBtn.addTarget(self, action: #selector(downloadBtnClick(btn:)), for: .touchUpInside)
        return downBtn
    }()
    //切换分辨率按钮
    fileprivate lazy var resolutionBtn:UIButton = {
        let resolutionBtn = UIButton(type: .custom)
        resolutionBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        resolutionBtn.backgroundColor = UIColor(0, g: 0, b: 0, a: 0.7)
        resolutionBtn.addTarget(self, action: #selector(resolutionBtnClick(btn:)), for: .touchUpInside)
        return resolutionBtn
    }()

    //播放按钮
    fileprivate lazy var playBtn:UIButton = {
        let btn:UIButton = UIButton(type: .custom)
        btn.setImage(UIImage(named: "ZFPlayer_play_btn"), for: .normal)
        btn.addTarget(self, action: #selector(centerPlayBtnClick(btn:)), for: .touchUpInside)
        btn.isHidden = true
        return btn
    }()
    //加载失败按钮
    fileprivate lazy var failBtn:UIButton = {
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
    fileprivate lazy var fastView:UIView = {
        let view:UIView = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        view.isHidden = true
        return view
    }()
    //快进快退进度 progress
    fileprivate lazy var fastProgressView:UIProgressView = {
        let progressView:UIProgressView = UIProgressView()
        progressView.progressTintColor = UIColor.white
        progressView.trackTintColor = UIColor.lightGray.withAlphaComponent(0.4)
        return progressView
    }()
    //快进快退时间
    fileprivate lazy var fastTimeLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = "123"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    //快退快进 ImageView
    fileprivate lazy var fastImageView:UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    //占位图
    fileprivate lazy var placeholderImageView:UIImageView = {
        let imageView:UIImageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    //控制层消失时在底部显示的播放进度 progress
    fileprivate lazy var bottomProgressView:UIProgressView = {
        let progressView:UIProgressView = UIProgressView()
        progressView.progressTintColor = UIColor.white
        progressView.trackTintColor = UIColor.clear
        return progressView
    }()
}
//通知
fileprivate extension MLHPlayerControlView{
    func addNotification(){
        //进入到后台
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackgroud), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        //进入到前台
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
    }
    func listeningRotation(){
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(onDeviceOrientationChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    @objc func onDeviceOrientationChange(){
        if MLHBrightness.shared.isLockScreen == true {
            return
        }
        self.lockBtn.isHidden = !self.fullScreen!
        self.fullScreenBtn.isSelected = self.fullScreen!
        let orientataion:UIDeviceOrientation = UIDevice.current.orientation
        if orientataion == .faceUp || orientataion == .faceDown || orientataion == .unknown || orientataion == .portraitUpsideDown {
            return
        }
        if !self.shrink! && !self.playEnd! && !self.showing! {
            self.playerShowOrHideControlView()
        }
    }
    @objc func appDidEnterBackgroud(){
        self.playerCancelAutoFadeOutControlView()
    }
    @objc func appDidBecomeActive(){
        if self.shrink! {
            self.playerShowControlView()
        }
    }
}

//外部接口
extension MLHPlayerControlView{
    
    /// 设置播放模型
    ///
    /// - Parameter playerModel: <#playerModel description#>
    func player(playerModel:MLHPlayerModel){
        if (playerModel.title != nil) {
            self.titleLabel.text = playerModel.title
        }
        //设置网络占位图
        if playerModel.palceHolderImageURLString != nil {
            self.placeholderImageView.setImageWith(URL(string: playerModel.palceHolderImageURLString!), placeholder: UIImage(named: "ZFPlayer_loading_bgView"))
        }
        else{
            self.placeholderImageView.image = playerModel.placeholderImage
        }
        //设置分辨率
//        if playerModel {
//            <#code#>
//        }
    }
    func playerShowOrHideControlView(){
        if self.showing == true {
            self.playerHidenControlView()
        }
        else{
            self.playerShowControlView()
        }
    }
    
    /// 显示控制层
    func playerShowControlView(){
        self.delegate?.controlViewWillShow(controlView: self, isFullScreen: self.fullScreen!)
        self.playerCancelAutoFadeOutControlView()
        UIView.animate(withDuration: MLHPlayerControlBarAutoFadeOutTimeInterval, animations: { 
            self.showControlView()
        }) { (finished) in
            self.showing = true
            self.autoFadeOutControlView()
        }
    }
    
    /// 隐藏控制层
    func playerHidenControlView(){
        self.delegate?.controlViewWillHidden(controlView: self, isFullScreen: self.fullScreen!)
        self.playerCancelAutoFadeOutControlView()
        UIView.animate(withDuration: MLHPlayerAnimationTimeInterval, animations: { 
            self.hideControlView()
        }) { (finished) in
            self.showing = false
        }
    }
    
    /// 重置 controlView
    func playerResetControlView(){
        self.activity.stopAnimating()
        self.videoSlider.value = 0.0
        self.bottomProgressView.progress = 0.0
        self.progressView.progress = 0.0
        self.currentTimeLabel.text = "00:00"
        self.totalTimeLabel.text = "00:00"
        self.fastView.isHidden = true
        self.repeatBtn.isHidden = true
        self.playBtn.isHidden = true
        self.resolutionView?.isHidden = true
        self.failBtn.isHidden = true
        self.backgroundColor = UIColor.clear
        self.downLoadBtn.isEnabled = true
        self.shrink = false
        self.showing = false
        self.playEnd = false
        self.lockBtn.isHidden = !self.fullScreen!
        self.failBtn.isHidden = !self.fullScreen!
        self.placeholderImageView.alpha = 1.0
        self.hideControlView()
    }
    
    /// 切换分辨率时重置 controlView
    func playerResetControlViewForResolution(){
        self.fastView.isHidden = true
        self.repeatBtn.isHidden = true
        self.resolutionView?.isHidden = true
        self.playBtn.isHidden = true
        self.downLoadBtn.isHidden = true
        self.failBtn.isHidden = true
        self.backgroundColor = UIColor.clear
        self.shrink = false
        self.showing = false
        self.playEnd = false
    }
    /// 取消自动隐藏控制层 view
    func playerCancelAutoFadeOutControlView(){
        //取消延迟执行
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    }
    
    /// 开始播放 (用来隐藏 placeholerImageView)
    func playerItemPlaying(){
        UIView.animate(withDuration: 1.0) { 
            self.placeholderImageView.alpha = 0.0
        }
    }
    
    /// 播放完了
    func playerPlayEnd(){
        self.repeatBtn.isHidden = false
        self.playEnd = true
        self.showing = false
        //隐藏 controlView
        self.hideControlView()
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        MLHBrightness.shared.isStatusBarHidden = false
        self.bottomProgressView.alpha = 0.0
    }
    
    /// 是否具有下载功能
    ///
    /// - Parameter sender:
    func playerHasDownloadFunction(sender:Bool){
        self.downLoadBtn.isHidden = !sender
    }
    
    /// 是否具有切换分辨率功能
    ///
    /// - Parameter resolutionArrar:
    func playerResolutionArray(resolutionArrar:NSArray){
        
    }
    
    /// 播放按钮状态 (播放, 暂停状态)
    ///
    /// - Parameter state:
    func playerPlayBtn(state:Bool){
        self.startBtn.isSelected = state
    }
    
    /// 锁定屏幕方向按钮状态
    ///
    /// - Parameter state:
    func playerLockBtn(state:Bool){
        self.lockBtn.isSelected = state
    }
    
    /// 下载按钮状态
    ///
    /// - Parameter state:
    func palyerDownLoadBtn(state:Bool){
        self.downLoadBtn.isEnabled = state
    }
    
    /// 加载的菊花
    ///
    /// - Parameter animated:
    func playerActivity(animated:Bool){
        if animated == true {
            self.activity.startAnimating()
            self.fastView.isHidden = true
        }
        else{
            self.activity.stopAnimating()
        }
    }
    
    /// 设置预览图
    ///
    /// - Parameters:
    ///   - graggedTiem: 拖拽的时长
    ///   - sliderImage: 预览图
    func player(draggedTime:NSInteger,sliderImage:UIImage){
//        let proMin:NSInteger = draggedTime/60
//        let proSec:NSInteger = draggedTime%60
//        let currentTimeStr:String = "\(proMin):\(proSec)"
//        @LTP
//        self.videoSlider
        self.fastView.isHidden = true
    }
    
    /// 拖拽快进快退
    ///
    /// - Parameters:
    ///   - draggedTime: 拖拽的时长
    ///   - totalTime: 视频总时长
    ///   - forward: 是否是快进
    ///   - hasPreView: 是否有预览图
    func player(draggedTime:NSInteger, totalTime:NSInteger,forward:Bool,hasPreView:Bool){
        //快进快退停止菊花
        self.activity.stopAnimating()
        //拖拽的时长
        let proMin:NSInteger = draggedTime/60
        let proSec:NSInteger = draggedTime%60
        
        //总时长
        let durMin:NSInteger = totalTime/60
        let durSec:NSInteger = totalTime%60
        
        let currentTimeStr:String = String(format: "%02zd:%02zd",proMin,proSec)
        let totalTimeStr:String = String(format: "%02zd:%02zd",durMin,durSec)
        
        let draggedValue:CGFloat = CGFloat(draggedTime)/CGFloat(totalTime)
        let timeStr:String = "\(currentTimeStr)/\(totalTimeStr)"
//        @LTP
        //更新 slider 的值
        self.videoSlider.value = Float(draggedValue)
        //更新 bottomProgressView 的值
        self.bottomProgressView.progress = Float(draggedValue)
        //更新当前时间
        self.currentTimeLabel.text = currentTimeStr
        //正在拖动控制播放进度
        self.dragged = true
        if forward {
            self.fastImageView.image = UIImage(named: "ZFPlayer_fast_forward")
        }
        else{
            self.fastImageView.image = UIImage(named: "ZFPlayer_fast_backward")
        }
        self.fastView.isHidden = hasPreView
        self.fastTimeLabel.text = timeStr
        self.fastProgressView.progress = Float(draggedValue)
    }
    
    /// 滑动调整进度结束
    func playerDraggedEnd(){
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(1)) {
            self.fastView.isHidden = true
        }
        self.dragged = false
        self.startBtn.isSelected = true
        self.autoFadeOutControlView()
    }
    
    /// 正常播放
    ///
    /// - Parameters:
    ///   - currentTime: 当前播放时长
    ///   - totalTime: 视频总时长
    ///   - sliderValue: slider 的 value(0.0~1.0)
    func player(currentTime:NSInteger, totalTime:NSInteger, sliderValue:CGFloat){
        let proMin:NSInteger = currentTime/60
        let proSec:NSInteger = currentTime%60
        let durMin:NSInteger = totalTime/60
        let durSec:NSInteger = totalTime%60
        if self.dragged == false {
            self.videoSlider.value = Float(sliderValue)
            self.bottomProgressView.progress = Float(sliderValue)
            self.currentTimeLabel.text = String(format: "%02zd:%02zd",proMin,proSec)
        }
        self.totalTimeLabel.text = String(format: "%02zd:%02zd",durMin,durSec)
    }
    
    /// progress 显示缓冲进度
    ///
    /// - Parameter setProgress:
    func player(setProgress:CGFloat){
        self.progressView.setProgress(Float(setProgress), animated: false)
    }
    
    /// 视屏加载失败
    ///
    /// - Parameter error:
    func playerItemStatusFailed(error:NSError){
        self.failBtn.isHidden = false
    }
    
    /// 小屏播放
    func playerBottomShrinkPlay(){
        self.shrink = true
        self.hideControlView()
    }
    
    /// 在 cell 播放
    func playerCellPlay(){
        self.cellVideo = true
        self.shrink = false
        self.backBtn.setImage(UIImage(named: "ZFPlayer_close"), for: .normal)
    }
    
    /// 下载按钮状态
    ///
    /// - Parameter state:
    func playerDownloadBtn(state:Bool) {
        self.downLoadBtn.isEnabled = state
    }
}
//内部接口
extension MLHPlayerControlView{
    fileprivate func autoFadeOutControlView(){
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(playerHidenControlView), object: nil)
        self.perform(#selector(playerHidenControlView), with: nil, afterDelay: MLHPlayerAnimationTimeInterval)
    }
    fileprivate func showControlView(){
        self.showing = true
        if self.lockBtn.isSelected == true {
            self.topImageView.alpha = 0
            self.bottomImageView.alpha = 0
        }
        else{
            self.topImageView.alpha = 1
            self.bottomImageView.alpha = 1
        }
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        self.lockBtn.alpha = 1
        if self.cellVideo == true {
            self.shrink = true
        }
        self.bottomProgressView.alpha = 0
        MLHBrightness.shared.isStatusBarHidden = false
    }
    fileprivate func hideControlView(){
        self.showing = false
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        if self.playEnd == true {
             self.topImageView.alpha = 1.0
        }
        else{
            self.topImageView.alpha = 0.0
        }
        self.bottomImageView.alpha = 0
        self.lockBtn.alpha = 0
        self.bottomProgressView.alpha = 1
        //隐藏 resolutionView
        self.resolutionBtn.isSelected = true
        self.resolutionBtnClick(btn: self.resolutionBtn)
        if self.fullScreen! && !self.playEnd! && self.shrink! {
            //@LTP
            MLHBrightness.shared.isStatusBarHidden = true
        }
    }
    
    @objc fileprivate func playBtnClick(btn:UIButton){
        btn.isSelected = !btn.isSelected
        self.delegate?.controlView(controlView: self, playAction: btn)
    }
    
    @objc fileprivate func progressSliderTouchBegin(slider:UISlider){
        self.delegate?.controlView(controlView: self, progressSliderTouchBegin: slider)
    }
    @objc fileprivate func progressSliderValueChanged(slider:UISlider){
        self.delegate?.controlView(controlView: self, progressSliderTouchChanged: slider)
    }
    @objc fileprivate func progressSliderTouchEnded(slider:UISlider){
        self.showing = true
        self.delegate?.controlView(controlView: self, progressSliderTouchEnded: slider)
    }
    @objc fileprivate func tapSliderAction(tap:UITapGestureRecognizer){
        if (tap.view is UISlider){
            let slider:UISlider = tap.view as! UISlider
            let point:CGPoint = tap.location(in: slider)
            let length:CGFloat = slider.frame.size.width
            let tapValue:CGFloat = point.x / length
            self.delegate?.controlView(controlView: self, progressSliderTapValue: tapValue)
        }
    }
    // 其实没有用到
    //不做处理, 只是为了滑动 slider 其他地方不响应手势
    @objc fileprivate func panRecognizer(pan:UIPanGestureRecognizer){
        
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let rect:CGRect = self.thumbRect()
        let point:CGPoint = touch.location(in: self.videoSlider)
        if (touch.view is UISlider) {
            if point.x <= rect.origin.x + rect.size.width && point.x >= rect.origin.x {
                return false
            }
        }
        return true
    }
    @objc fileprivate func fullScreenBtnClick(btn:UIButton){
        btn.isSelected = !btn.isSelected
        self.delegate?.controlView(controlView: self, fullScreenAction: btn)
    }
    
    @objc fileprivate func lockScrrenBtnClick(btn:UIButton){
        btn.isSelected = !btn.isSelected
        self.showing = true
        self.playerShowControlView()
        self.delegate?.controlView(controlView: self, lockScreenAction: btn)
    }
    
    @objc fileprivate func closeBtnClick(btn:UIButton){
        self.delegate?.controlView(controlView: self, closeAction: btn)
    }
    @objc fileprivate func backBtnClick(btn:UIButton){
        let orientation:UIInterfaceOrientation = UIApplication.shared.statusBarOrientation
        if (self.cellVideo == true) && orientation == .portrait {
            self.delegate?.controlView(controlView: self, closeAction: btn)
        }
        else{
            self.delegate?.controlView(controlView: self, backAction: btn)
        }
    }
    @objc fileprivate func repeatBtnClick(btn:UIButton){
        self.playerResetControlView()
        self.playerShowControlView()
        self.delegate?.controlView(controlView: self, repeatPlayAction: btn)
    }
    
    @objc fileprivate func downloadBtnClick(btn:UIButton){
        self.delegate?.controlView(controlView: self, downLoadVideoAction: btn)
    }
    @objc fileprivate func resolutionBtnClick(btn:UIButton){
        btn.isSelected = !btn.isSelected
        self.resolutionView?.isHidden = !btn.isSelected
    }
    
    @objc fileprivate func centerPlayBtnClick(btn:UIButton){
        self.delegate?.controlView(controlView: self, centerPlayAction: btn)
    }
    
    @objc fileprivate func failBtnClick(btn:UIButton){
        self.failBtn.isHidden = true
        self.delegate?.controlView(controlView: self, failAction: btn)
    }
    
    fileprivate func thumbRect() -> CGRect{
        return self.videoSlider.thumbRect(forBounds: self.videoSlider.bounds, trackRect: self.videoSlider.trackRect(forBounds: self.videoSlider.bounds), value: self.videoSlider.value)
    }
    
}
//布局
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
}


