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
 
 
    func loadMagicTVData(params:[String:Any],finished:@escaping CompleteBlock)  {
       let newparams = ["femaleId":"859365",
                    "mid":"1859060b90ec4f3624adbdf158fa577097319599",
                  "cversion":"4300",
                  "client":"ios",
                      "Authorization":"token 9428b40ab2f34063a8f50a0b1d919973jacmpr1e"]
        self.doHttpRequest(params: newparams, url: findmagictv, completeBlock: finished)
    
    }
    
    private func doHttpRequest(params:[String:Any] , url:String , completeBlock:@escaping CompleteBlock){
        print(URL(string: requestURLHeader + url)!)
        Alamofire.request(URL(string: requestURLHeader + url)!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: [:]).responseJSON(completionHandler: { (response) in
            completeBlock(response)
        })
    }
}

/*
 let whc = MLHFindMagicTV.deserialize(from: value as? NSDictionary)
 let findmagictv:String = "find/magictv"

 
 */
