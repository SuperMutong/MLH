//
//  MLHWebViewController.swift
//  MLH
//
//  Created by Haitang on 17/10/6.
//  Copyright © 2017年 Haitang. All rights reserved.
//

import UIKit

class MLHWebViewController: MLHBaseViewController {
    var webUrl:String?
    var webView:UIWebView?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpWebView()
        setUpNavigation()
        // Do any additional setup after loading the view.
    }
    func setUpNavigation(){
        self.view.backgroundColor = UIColor.white;
        self.setLeftItem(image: UIImage(named: "bc_back"), selectedImage: UIImage(named: "bc_back"), target: self, action: #selector(customBackAction))
    }
    func customBackAction(){
        if (self.webView?.canGoBack)! {
            self.webView?.goBack()
        }
        else{
           _ = self.navigationController?.popViewController(animated: true)
        }
    }
    func setUpWebView(){
        self.webView = UIWebView(frame:CGRect(x: 0, y: 0, width: KScreenWidth, height: KScreenHeight-64))
        if (self.webUrl == nil){
            self.webUrl = "http://www.baidu.com"
        }
        let URL:NSURL = NSURL(string: self.webUrl!)!
        self.webView?.loadRequest(URLRequest(url: URL as URL))
        self.webView?.delegate = self
        self.view.addSubview(self.webView!)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MLHWebViewController:UIWebViewDelegate{
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.title = webView.stringByEvaluatingJavaScript(from: "document.title")
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
    }
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
//        request.URL.absoluteString
        print("url"+(request.url?.absoluteString)!)
        return true
    }
}
