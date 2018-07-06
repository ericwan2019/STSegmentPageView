//
//  HomeViewController.swift
//  STSegmentPageView_Example
//
//  Created by 万鸿恩 on 2018/7/5.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}

extension HomeViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellInditenfier = "customeCell"
        if indexPath.row == 0 {
            cellInditenfier = "cell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellInditenfier, for: indexPath)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 1 {
            let vc = ViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 0 {
            let vc = UseVCViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
