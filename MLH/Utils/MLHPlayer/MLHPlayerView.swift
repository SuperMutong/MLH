//
//  MLHPlayerView.swift
//  MLH
//
//  Created by Haitang on 17/7/18.
//  Copyright © 2017年 Haitang. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
enum MLHPlayerLayerGravity {
    case MLHPlayerLayerGravityResize //非均匀模式, 两个维度完全填充至整个视图区域
    case MLHPlayerLayerGravityResizeAspect //等比例填充, 直到一个维度达到区域边界
    case MLHPlayerLayerGravityResizeAspectFill //等比例填充, 直到填充满整个视图区域, 其中一个维度的部分区域会被剪裁
}
enum MLHPlayerState {
    case MLHPlayerStateFailed
    case MLHPlayerStateBuffering
    case MLHPlayerStatePlaying
    case MLHPlayerStateStopped
    case MLHPlayerStatePause
}

enum MLHPanDirection{
    case MLHPanDirectionHorizontalMoved
    case MLHPanDirectionVerticalMoved
}

protocol MLHPlayerDelegate {
    
    /// 返回按钮事件
    func playerBackAction()
    /// 下载视频
    func playerDownLoad(downloadUrl:String)
    /// 控制层即将显示
    func playerControlViewWillShow(controller:UIView, isFullScreen:Bool)
    /// 控制层即将隐藏
    func playerControlViewWillHidden(controller:UIView, idFullScreen:Bool)
}

public final class MLHPlayer{
    private static let _shared = MLHPlayer()
    private init(){}
    var playerView:MLHPlayerView?
    public static var shared:MLHPlayer{
        return _shared
    }
}



final class MLHPlayerView:UIView{
    ///设置 playerLayer 的填充模式
    var playerLayerGravity:MLHPlayerLayerGravity?
    /// 是否具有下载功能
    var hasDownload:Bool?
    /// 是否开启预览图
    var hasPreviewView:Bool?
    /// 设置代理
    var delegate:MLHPlayerDelegate?
    /// 是否被用户暂停
    var isPauseByUser:Bool?
    /// 播放器的当前状态
    var state:MLHPlayerState?
    /// 静音 默认为 NO
    var mute:Bool?
    /// 当 cell 划出屏幕的时候停止播放(默认 NO)
    var stopPlayWhileCellNotVisable:Bool?
    /// 当 cell 播放视频由全屏变为小屏的时候, 是否回到中间位置(默认 YES)
    var cellPlayerOnCenter:Bool?
    /// 当 Player 正在播放的时候, 此时 push 或者模态了新视图是否继续播放 默认 NO
    var playerPushedOrPresentd:Bool?
    
    //播放属性
    fileprivate var player:AVPlayer?
    fileprivate var playerItem:AVPlayerItem?
    fileprivate var urlAsset:AVURLAsset?
    fileprivate var imageGenerator:AVAssetImageGenerator?
    // playerLayer
    fileprivate var playerLayer:AVPlayerLayer?
    fileprivate var timeObserve:Any?
    ///滑竿
    fileprivate var volumeViewSlider:UISlider?
    ///总时长
    fileprivate var sumTime:CGFloat?
    ///滑动方向
    fileprivate var panDirection:MLHPanDirection?
    ///播放器的状态
    fileprivate var playerState:MLHPlayerState?
    ///是否全屏
    fileprivate var isFullScreen:Bool?
    ///是否锁定屏幕方向
    fileprivate var isLocked:Bool?
    ///是否在调节音量
    fileprivate var isVolume:Bool?
//    fileprivate var isPauseByUser:Bool?
    ///是否播放本地文件
    fileprivate var isLocalVideo:Bool?
    ///slider 上次的值
    fileprivate var sliderLastValue:CGFloat?
    ///是否再次设置 URL 播放视频
    fileprivate var repeatToPlay:Bool?
    ///是否播放完毕
    fileprivate var playDidEnd:Bool?
    ///是否进入后台
    fileprivate var didEnterBackground:Bool?
    ///是否自动播放
    fileprivate var isAutoPlay:Bool?
    ///单击
    fileprivate var singleTap:UITapGestureRecognizer?
    ///双击
    fileprivate var doubleTap:UITapGestureRecognizer?
    ///亮度 View
    fileprivate var brightnessView:MLHVolumeView?
    ///视频填充模式
    fileprivate var videoGravity:String?
    
    // UITableView
    
    /// palyer 加到 tableView
    fileprivate var scrollView:UIScrollView?
    /// palyer 所在 cell 的 indexpath
    fileprivate var indexPath:NSIndexPath?
    ///VC 是否消失
    fileprivate var viewDisappear:Bool?
    ///是否在 cell 上播放 video
    fileprivate var isCellVideo:Bool?
    ///是否缩小视频在底部
    fileprivate var isBottomVideo:Bool?
    ///是否在拖拽
    fileprivate var isDragged:Bool?
    ///小窗口距离屏幕右下角的距离
    fileprivate var shrinkRightBottomPoint:CGPoint?
    
    fileprivate var shrinkPanGesture:UIPanGestureRecognizer?
    
    fileprivate var controlView:MLHPlayerControlView?
    fileprivate var playerModel:MLHPlayerModel?
    fileprivate var seekTime:NSInteger?
    fileprivate var videoURL:URL?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initiallizerThePlayer()
    }
    
    func player(controlView:UIView,playerModel:MLHPlayerModel){
        
    }
    
    func player(playerModel:MLHPlayerModel){
        
    }
    func autoPlayTheVideo(){
        self.configPlayer()
    }
    func resetPlayer(){
        
    }
    func resetToPlayNewVidel(playerModel:MLHPlayerModel){
        
    }
    func play() {
        
    }
    func pause(){
        
    }
    
    
    func initiallizerThePlayer() {
        self.cellPlayerOnCenter = true
    }
    
    
    
    
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MLHPlayerView{
   fileprivate func configPlayer() {
     urlAsset = AVURLAsset(url: self.videoURL!)
     playerItem = AVPlayerItem(asset: urlAsset!)
     player = AVPlayer(playerItem: playerItem!)
     playerLayer = AVPlayerLayer(player: player!)
     self.backgroundColor = UIColor.clear
     playerLayer?.videoGravity = self.videoGravity!
     isAutoPlay = true
     creatTimer()
     configureVolume()
     state = MLHPlayerState.MLHPlayerStateBuffering
     isLocalVideo = false
    
     self.controlView?.playerDownloadBtn(state: true)
     self.play()
     self.isPauseByUser = false
    }
    
    private func creatTimer(){
        
    }
    private func configureVolume(){
        
    }
}






















