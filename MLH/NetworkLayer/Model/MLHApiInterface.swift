//
//  MLHApiInterface.swift
//  MLH
//
//  Created by Haitang on 17/6/9.
//  Copyright © 2017年 Haitang. All rights reserved.
//


 import Foundation
 import HandyJSON
struct MLHFindMagicTVCates:HandyJSON {
    var id: String?
    var name: String?
}
struct MLHFindMagicTVBackuplink:HandyJSON {
    var resolution: String?
    var video: String?
    var md5: String?
    var type: String?
}
struct MLHFindMagicTVPdownlink:HandyJSON {
    var mult_suit: String?
    var resolution: String?
    var mult_stat: String?
    var video: String?
    var md5: String?
    var type: String?
}
struct MLHFindMagicTVContent_post:HandyJSON {
    
}
struct MLHFindMagicTVRecommend_post:HandyJSON{
    
}
struct MLHFindMagicTVPosts:HandyJSON {
    var series_tag: String?
    var title: String?
    var episode: String?
    var xiangkan_cate: String?
    var sharelink: String?
    var mi_cate: String?
    var content_post : [MLHFindMagicTVContent_post]?
    var intro: String?
    var cates: [MLHFindMagicTVCates]?
    var backuplink : [MLHFindMagicTVBackuplink]?
    var cover: String?
    var source_link: String?
    var pdownlink :  [MLHFindMagicTVPdownlink]?
    var count_comment: String?
    var rank_by_score: String?
    var seriesid: String?
    var publish_time: String?
    var id: String?
    var is_recent_hot: String?
    var duration_int: String?
    var series_title: String?
    var count_view: String?
    var count_share: String?
    var count_like: String?
    var label: String?
    var series_avatar: String?
    var recommend_post :  [MLHFindMagicTVRecommend_post]?
    var is_show_barrage: String?
    var is_magictv: String?
}
struct MLHFindMagicTVParam:HandyJSON {
    var url: String?
}
struct MLHFindMagicTV_head:HandyJSON {
    var param: MLHFindMagicTVParam?
    var id: String?
    var title: String?
    var type: String?
    var cover: String?
    
}

struct MLHFindMagicData:HandyJSON {
    var magictv_head_image:String?
    var pageSize : Int?
    var totalCount : Int?
    var magictv_head : MLHFindMagicTV_head?
    var posts : [MLHFindMagicTVPosts]?
}
struct MLHFindMagicTV:HandyJSON {
    var status: String?
    var data: MLHFindMagicData?
    var msg: String?
}


// struct Cates {
// var id: String?
// var name: String?
//    init(_ dic:[String:Any]) {
//        id = dic["id"] as? String
//        name = dic["name"] as? String
//    }
// }
// struct Backuplink {
// var resolution: String?
// var video: String?
// var md5: String?
// var type: String?
//    init(_ dic:[String:Any]) {
//        resolution = dic["resolution"] as? String
//        video  = dic["video"] as? String
//        md5  = dic["md5"] as? String
//        type  = dic["type"] as? String
//    }
// }
// struct Pdownlink {
// var mult_suit: String?
// var resolution: String?
// var mult_stat: String?
// var video: String?
// var md5: String?
// var type: String?
//        init(_ dic:[String:Any]) {
//            mult_suit = dic["mult_suit"] as? String
//            resolution = dic["resolution"] as? String
//            mult_stat = dic["mult_stat"] as? String
//            video = dic["video"] as? String
//            md5 = dic["md5"] as? String
//            type = dic["type"] as? String
//        }
// }
//struct Content_post {
//    
//}
//struct Recommend_post{
//    
//}
// struct Posts {
// var series_tag: String?
// var title: String?
// var episode: String?
// var xiangkan_cate: String?
// var sharelink: String?
// var mi_cate: String?
// var content_post = [Content_post]()
// var intro: String?
// var cates: [Cates]?
// var backuplink = [Backuplink]()
// var cover: String?
// var source_link: String?
// var pdownlink =  [Pdownlink]()
// var count_comment: String?
// var rank_by_score: String?
// var seriesid: String?
// var publish_time: String?
// var id: String?
// var is_recent_hot: String?
// var duration_int: String?
// var series_title: String?
// var count_view: String?
// var count_share: String?
// var count_like: String?
// var label: String?
// var series_avatar: String?
// var recommend_post =  [Recommend_post]()
// var is_show_barrage: String?
// var is_magictv: String?
//init(_ dic:[String:Any]) {
//    series_tag = dic["series_tag"] as? String
//    title = dic["title"] as? String
//    episode = dic["episode"] as? String
//    xiangkan_cate = dic["xiangkan_cate"] as? String
//    sharelink = dic["sharelink"] as? String
//    mi_cate = dic["mi_cate"] as? String
//    intro = dic["intro"] as? String
//    
//    for item in (dic["cates"] as? [Any])! {
//        if let value = item as? [String:Any] {
//            let p = Cates(value)
//            cates?.append(p)
//        }
//    }
//    for item in (dic["backuplink"] as? [Any])! {
//        for value in (item as? [Any])! {
//            if let pvalue = value as? [String:Any] {
//                let p = Backuplink(pvalue)
//                backuplink.append(p)
//            }
//        }
//    }
////    backuplink = dic["backuplink"] as? [Backuplink]
//    cover = dic["cover"] as? String
//    source_link = dic["source_link"] as? String
////    pdownlink = dic["pdownlink"] as? [Pdownlink]
//    for item in (dic["pdownlink"] as? [Any])! {
//        if let value = item as? [String:Any] {
//            let p = Pdownlink(value)
//            pdownlink.append(p)
//        }
//    }
//    count_comment = dic["count_comment"] as? String
//    rank_by_score = dic["rank_by_score"] as? String
//    seriesid = dic["seriesid"] as? String
//    publish_time = dic["publish_time"] as? String
//    id = dic["id"] as? String
//    is_recent_hot = dic["is_recent_hot"] as? String
//    duration_int = dic["duration_int"] as? String
//    series_title = dic["series_title"] as? String
//    count_view = dic["count_view"] as? String
//    count_share = dic["count_share"] as? String
//    count_like = dic["count_like"] as? String
//    label = dic["label"] as? String
//    series_avatar = dic["series_avatar"] as? String
//    is_show_barrage = dic["is_show_barrage"] as? String
//    is_magictv = dic["is_magictv"] as? String
//}
// }
// 
// struct Magictv_head {
// var param: Param?
// var id: String?
// var title: String?
// var type: String?
// var cover: String?
//    init(_ dic:[String:Any]) {
//        param = Param((dic["param"] as? [String:String])!)
//        id = dic["id"] as? String
//        title = dic["title"] as? String
//        type = dic["type"] as? String
//        cover = dic["cover"] as? String
//    }
// }
//struct Param {
//    var url: String?
//    init(_ dic:[String:Any]) {
//        url = dic["url"] as? String
//    }
//}
//struct Data {
//    var magictv_head_image:String?
//    var pageSize : Int?
//    var totalCount : Int?
//    var magictv_head : Magictv_head?
//    var posts = [Posts]()
//    init(_ dic:[String:Any]) {
//        magictv_head_image = dic["magictv_head_image"] as? String
//        pageSize = dic["pageSize"] as? Int
//        totalCount = dic["totalCount"] as? Int
//        magictv_head = Magictv_head((dic["magictv_head"] as? Dictionary)!)
//        for item in (dic["posts"] as? [Any])! {
//            if let value = item as? [String:Any] {
//                let p = Posts(value)
//                posts.append(p)
//            }
//        }
//    }
//}
// struct WHC {
// var status: String?
// var data: Data?
// var msg: String?
// init(_ dic:[String:Any]) {
//    status = dic["status"] as? String
//    msg = dic["msg"] as? String
//    data = Data((dic["data"] as? [String : Any])!)
// }
//   
//    
//}

