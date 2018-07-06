//
//  STSegmentPageView.swift
//  STSegmentPageView
//
//  Created by 万鸿恩 on 2018/6/26.
//  Copyright © 2018年 万鸿恩. All rights reserved.
//

import UIKit


/// - 两种初始化方法
///     - 一种使用该VC初始化
///     - 一种使用自定义title和content初始化

public class STSegmentPageViewController : UIViewController{
    
    
    /// 标题视图高度，默认40
    public var titleViewHeight : CGFloat = 40{
        didSet{
            view.setNeedsLayout()
        }
    }
    
    
    /// 标题视图
    private var titleView : STSegmentTitleView?
    // 内容视图
    private var contentView : STSegmentContentView?
    //标题数组
    private var titles : [String]?
    
    /// 控制器数组
    private var titleControllers : [UIViewController]?
    
    private var segmentModels : [STSegmentModel]?
    
    private var configure = STSegmentPageTitleViewConfigure()
    
    /// 将自己添加到视图中
    ///
    /// - Parameter parentController: 父类视图
    public func addSegmentController(toParentController parentController : UIViewController){
        parentController.view.addSubview(self.view)
        parentController.addChildViewController(self)
        self.didMove(toParentViewController: parentController)
    }
    
    /// 初始化
    ///
    /// - Parameters:
    ///   - childrenModels: 数据模型（用于保证标题和控制其数量一致）
    ///   - titleViewH: 标题高度，默认40
    ///   - titleConfig: 标题视图的配置
    convenience public init(childrenModels : [STSegmentModel]?, titleViewH : CGFloat = 40, titleConfig : STSegmentPageTitleViewConfigure = STSegmentPageTitleViewConfigure()) {
        self.init(nibName: nil, bundle: nil)
        titles = childrenModels?.map({ $0.segmentTitle ?? "" })
        titleControllers = childrenModels?.map({$0.segmentController ?? UIViewController()})
        configure = titleConfig
        titleViewHeight = titleViewH
        setupUIs()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        titleView?.frame = CGRect(x: 0, y: 0, width: view.width, height: titleViewHeight)
        contentView?.frame = CGRect(x: 0, y: titleViewHeight, width: view.width, height: view.height - titleViewHeight)
    }
}

extension STSegmentPageViewController {
    private func setupUIs(){
        titleView = STSegmentTitleView( frame: CGRect(x: 0, y: 0, width: view.width, height: titleViewHeight),config: configure, titles: titles)
        titleView?.delegate = self
        contentView = STSegmentContentView(frame: CGRect(x: 0, y: titleViewHeight, width: view.width, height: view.height - titleViewHeight), childrenControllers: titleControllers, parentVC: self)
        contentView?.delegate = self
        
        view.addSubview(titleView!)
        view.addSubview(contentView!)
    }
}



extension STSegmentPageViewController : STSegmentTitleViewDelegate{
    public func didSelectedSegmentTitleViewItemAt(atIndex index: Int) {
        contentView?.didSelectedItemAtIndex(atIndex: index)
    }
}
extension STSegmentPageViewController : STSegmentContentViewDelegate{
    public func pageContentViewDidScrollToItem(atIndex targetIndex: Int) {
        titleView?.didSelectedTitleItemAtIndex(atIndex: targetIndex)
    }
    
    public func pageContentViewDidScroll(progress: CGFloat, originIndex: Int, targetIndex: Int) {
        titleView?.updateTitleViewWhenContentViewDrag(progress: progress, fromIndex: originIndex, endIndex: targetIndex)
    }
    
}
