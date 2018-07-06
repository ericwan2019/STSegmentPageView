//
//  UseVCViewController.swift
//  STSegmentPageView_Example
//
//  Created by 万鸿恩 on 2018/7/5.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import STSegmentPageView

class UseVCViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        
        let btn = UIButton()
        btn.setTitle("+", for: .normal)
        btn.addTarget(self, action: #selector(rightAction), for: .touchUpInside)
        let config = STSegmentPageTitleViewConfigure()
        config.wouldUseRightButton = true
        config.rightButton = btn
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        btn.backgroundColor = .clear
        let titles = ["推荐","热点","视频","娱乐娱乐娱乐娱乐娱乐娱乐娱乐","问答","北京","朝阳","地方","八卦","综艺","推荐","热点","视频","娱乐","问答","北京","朝阳","地方","八卦","综艺"]
        
        var i = 0
        var models = titles.map { (title) -> STSegmentModel in
            let model = STSegmentModel()
            let controller = SecondViewController()
            controller.label.text = title
            if i % 2 == 0{
                controller.view.backgroundColor = .red
            }
            else{
                controller.view.backgroundColor = .blue
            }
            i += 1
            model.segmentTitle = title
            model.segmentController = controller
            return model
        }
        
        let segmentVC = STSegmentPageViewController(childrenModels: models, titleConfig: config)
        //使用自定义高度
//        let segmentVC = STSegmentPageViewController(childrenModels: models, titleViewH: 40, titleConfig: config)
        
        var navBarHeight : CGFloat = 64
        //iPhoneX的顶部高度
        if UIScreen.main.bounds.size == CGSize(width: 375, height: 812) {
            navBarHeight = 88
        }
        
        segmentVC.view.frame = CGRect(x: 0, y: navBarHeight, width: view.width, height: view.height - navBarHeight)
        segmentVC.addSegmentController(toParentController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func rightAction(){
        print("click right button")
    }
    

}
