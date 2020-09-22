//
//  MLHTVViewController.swift
//  MLH
//
//  Created by Haitang on 17/6/4.
//  Copyright © 2017年 Haitang. All rights reserved.
//

import UIKit
import MJRefresh
import MBProgressHUD
//B2
class MLHTVViewController: MLHBaseViewController {
    var VM:MLHTVVM = MLHTVVM()
    var tableView:UITableView = {
        let tab = UITableView(frame: CGRect(x: 0, y: 0, width: KScreenWidth, height: KScreenHeight-64), style: UITableViewStyle.plain)
        tab.register(UINib(nibName: "MLHTVTableViewCell", bundle: nil), forCellReuseIdentifier: "MLHTVTableViewCell")
        let headerView = Bundle.main.loadNibNamed("MLHTVHeader", owner: self, options: nil)?.last as! MLHTVHeader
        headerView.frame = CGRect(x: 0, y: 0, width: KScreenWidth, height: 165)
   
        tab.tableHeaderView = headerView;
        tab.separatorStyle = .none
        return tab
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "魔力TV"
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(self.tableView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(pushWebView));
        self.tableView.tableHeaderView?.addGestureRecognizer(tap)
        self.loadVM()
        
        let footer = MJRefreshAutoNormalFooter.init { [weak self] ()->Void in
            self?.VM.loadMoreTVData()
        }
        self.tableView.mj_footer = footer
    }
    func pushWebView(){
        
        let webVC:MLHWebViewController = MLHWebViewController()
//        webVC.webUrl = self.VM.whc!.data!.magictv_head!.param?.url!
        webVC.webUrl = self.VM.header?.param?.url!

        webVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(webVC, animated: true)
    }

    fileprivate func loadVM(){
        
        VM.loadTVData()
        VM.reloadSignal.observe {[weak self] (reload) in
            if reload {
                if(self?.VM.requestError != nil){
                    _ = HUD.show(view: (self?.view)!, message: "网络错误")
                }
                else{
                    let headerView =  self?.tableView.tableHeaderView as! MLHTVHeader
                    headerView.headerImageView.setImageWith(URL(string: (self?.VM.header?.cover)!), placeholder: nil)
                    self?.tableView.reloadData()
                }
                self?.tableView.mj_footer.endRefreshing()

            }
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension MLHTVViewController:UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 211
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MLHPlayerViewController()
        vc.videoData = self.VM.post[indexPath.row]
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard self.VM.whc != nil else {
//            return 0
//        }
        return self.VM.post.count
//        return self.VM.whc!.data!.posts!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MLHTVTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MLHTVTableViewCell", for: indexPath) as! MLHTVTableViewCell
        cell.reloadDataWith(data: (self.VM.post[indexPath.row]))
        return cell
    }
}
