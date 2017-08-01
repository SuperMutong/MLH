//
//  HTTPFacade.swift
//  MLH
//
//  Created by Haitang on 17/6/9.
//  Copyright © 2017年 Haitang. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
typealias CompleteBlock = (_ resultObejct:DataResponse<Any>) -> ()
struct HTTPFacade {
 static let shareInstance = HTTPFacade()
 
 
    func loadMagicTVData(_ finished:@escaping CompleteBlock)  {
        self.doHttpRequest(params: [:], url: findmagictv, completeBlock: finished)
    }
    private func doHttpRequest(params:[String:Any] , url:String , completeBlock:@escaping CompleteBlock){
        Alamofire.request(URL(string: requestURLHeader + url)!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: [:]).responseJSON(completionHandler: { (response) in
            completeBlock(response)
        })
    }
}

/*
 let whc = MLHFindMagicTV.deserialize(from: value as? NSDictionary)
 let findmagictv:String = "find/magictv"

 
 */
