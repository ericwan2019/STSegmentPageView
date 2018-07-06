//
//  ViewController.swift
//  STSegmentPageView
//
//  Created by EricWan on 06/26/2018.
//  Copyright (c) 2018 EricWan. All rights reserved.
//

import UIKit
import STSegmentPageView

class ViewController: UIViewController {
    
    var pageTitleView  : STSegmentTitleView?
    var progress : CGFloat = 0
    var index  = 0
    
    var pageView : STSegmentContentView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view, typically from a nib.
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
        
        var navBarHeight : CGFloat = 64
        //iPhoneX的顶部高度
        if UIScreen.main.bounds.size == CGSize(width: 375, height: 812) {
            navBarHeight = 88
        }
        
        
        pageTitleView = STSegmentTitleView(config:config ,titles: titles)
        pageTitleView!.frame = CGRect(x: 0, y: navBarHeight, width: view.width, height: 48)
        view.addSubview(pageTitleView!)
        pageTitleView?.delegate = self
        
        var vcs = [UIViewController]()
        for (i,_) in titles.enumerated(){
            let controller = SecondViewController()
            controller.label.text = "\(i)"
            if i % 2 == 0{
                controller.view.backgroundColor = .red
            }
            else{
                controller.view.backgroundColor = .blue
            }
            vcs.append(controller)
        }
        
        pageView = STSegmentContentView(frame: CGRect(x: 0, y: (pageTitleView?.frame.maxY ?? 0), width: view.width, height: view.height - (pageTitleView?.frame.maxY  ?? 0) ), childrenControllers: vcs,parentVC:self)
        pageView?.delegate = self
        view.addSubview(pageView!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func rightAction(){
        print("click right button")
    }
    
}

extension ViewController : STSegmentTitleViewDelegate{
    func didSelectedSegmentTitleViewItemAt(atIndex index: Int) {
        pageView?.didSelectedItemAtIndex(atIndex: index)
    }
    
    
}
extension ViewController : STSegmentContentViewDelegate{
    func pageContentViewDidScrollToItem(atIndex targetIndex: Int) {
        pageTitleView?.didSelectedTitleItemAtIndex(atIndex: targetIndex)
    }
    
    func pageContentViewDidScroll(progress: CGFloat, originIndex: Int, targetIndex: Int) {
        pageTitleView?.updateTitleViewWhenContentViewDrag(progress: progress, fromIndex: originIndex, endIndex: targetIndex)
    }
    
}
