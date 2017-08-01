//
//  MLHPlayerModel.swift
//  MLH
//
//  Created by Haitang on 17/7/18.
//  Copyright © 2017年 Haitang. All rights reserved.
//

import Foundation
import UIKit
struct MLHPlayerModel {
    
    /// 视频标题
    var title:String?
    /// 视频 URL
    var videoURL:URL?
    /// 视频封面本地图片
    var placeholderImage:UIImage?
    /// 播放器 View 的父视图 (非 cell 播放使用这个)
    var fatherView:UIView?
    /// 视频封面网络图片 URL
    var palceHolderImageURLString:String?
    /// 从 xx 秒开始播放视频 默认 0
    var seekIime:NSInteger?
    /// cell 播放视频, 以下属性必须设置值
    var scrollView:UIScrollView?
    /// cell 所在的 indexPath
    var indexPath:NSIndexPath?
    /// 播放器 View 的父视图 Tag, (根据 tag 值在 cell 里查找 playerView 加到哪里)
    var fatherViewTag:NSInteger?
}
