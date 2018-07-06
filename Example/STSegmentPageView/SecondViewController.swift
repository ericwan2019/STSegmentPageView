//
//  SecondViewController.swift
//  STSegmentPageView_Example
//
//  Created by 万鸿恩 on 2018/7/3.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    var label : UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 25)
        lab.textColor = .white
        return lab
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        view.addSubview(label)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        label.sizeToFit()
        label.center.x = view.center.x
        label.center.y = view.center.y
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
