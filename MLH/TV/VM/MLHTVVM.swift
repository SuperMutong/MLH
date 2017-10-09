//
//  MLHTVVM.swift
//  MLH
//
//  Created by Haitang on 17/6/10.
//  Copyright © 2017年 Haitang. All rights reserved.
//

import Foundation
import SwiftyJSON
import HandyJSON
class MLHTVVM {
    var whc:MLHFindMagicTV?
    var post:[MLHFindMagicTVPosts]
    var header:MLHFindMagicTV_head?
    var requestError:Error?
    var reloadSignal:Observable<Bool>
    init() {
        post = []
        reloadSignal = Observable(false)
    }
    func loadTVData() {
     
        HTTPFacade.shareInstance.loadMagicTVData(params:["lastid":"0"]) {[weak self] (response) in
            switch response.result {
            case .success(let value):
                let whc = MLHFindMagicTV.deserialize(from: value as? NSDictionary)
//                self?.whc = whc
                
                self?.post += (whc?.data?.posts)!
                self?.header = (whc?.data?.magictv_head)!
            case .failure(let error):
                self?.requestError  = error
                 print(error)
            }
            self?.reloadSignal.value = true

        }
    }
    func loadMoreTVData(){
        if(self.post.count == 0){
            return;
        }
        let post:MLHFindMagicTVPosts = (self.post.last)!
        HTTPFacade.shareInstance.loadMagicTVData(params:["lastid":post.id ?? "0"]) {[weak self] (response) in
            switch response.result {
            case .success(let value):
                let whc = MLHFindMagicTV.deserialize(from: value as? NSDictionary)
//                self?.whc = whc
                self?.post += (whc?.data?.posts)!

                self?.reloadSignal.value = true
            case .failure(let error):
                print(error)
            }
        }
    }
}


/*
 var series_tag: String!
 var title: String!
 var episode: String!
 var xiangkan_cate: String!
 var sharelink: String!
 var mi_cate: String!
 var content_post: [NULLModel]!
 var intro: String!
 var cates: [Cates]!
 var backuplink: [Backuplink]!
 var cover: String!
 var source_link: String!
 var pdownlink: [Pdownlink]!
 var count_comment: String!
 var rank_by_score: String!
 var seriesid: String!
 var publish_time: String!
 var id: String!
 var is_recent_hot: String!
 var duration_int: String!
 var series_title: String!
 var count_view: String!
 var count_share: String!
 var count_like: String!
 var label: String!
 var series_avatar: String!
 var recommend_post: [NULLModel]!
 var is_show_barrage: String!
 var is_magictv: String!
 */
