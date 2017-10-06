//
//  MLHTVViewController.swift
//  MLH
//
//  Created by Haitang on 17/6/4.
//  Copyright © 2017年 Haitang. All rights reserved.
//

import UIKit
import MBProgressHUD

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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "魔力TV"
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(self.tableView)
        self.loadVM()
    }
    

    fileprivate func loadVM(){
        VM.loadTVData()
    
        VM.reloadSignal.observe {[weak self] (reload) in
            if reload {
                let headerView =  self?.tableView.tableHeaderView as! MLHTVHeader
                headerView.headerImageView.setImageWith(URL(string: (self?.VM.whc!.data!.magictv_head?.cover)!), placeholder: nil)
                self?.tableView.reloadData()
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
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 165;
//    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if ((self.VM.whc?.data) != nil) {
//            let headerView:MLHTVHeader =  Bundle.main.loadNibNamed("MLHTVHeader", owner: self, options: nil)?.last as! MLHTVHeader
//            headerView.headerImageView.setImageWith(URL(string: (self.VM.whc!.data!.magictv_head?.cover)!), placeholder: nil)
//            return headerView;
//        }
//        return nil
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.VM.whc != nil else {
            return 0
        }
        return self.VM.whc!.data!.posts!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MLHTVTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MLHTVTableViewCell", for: indexPath) as! MLHTVTableViewCell
        cell.reloadDataWith(data: (self.VM.whc!.data!.posts?[indexPath.row])!)
        return cell
    }
}
