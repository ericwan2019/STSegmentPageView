//
//  STSegmentContentView.swift
//  Pods
//
//  Created by 万鸿恩 on 2018/7/2.
//

import UIKit


public protocol STSegmentContentViewDelegate : NSObjectProtocol{
    
    /// 内容视图滚动，用于移动标题视图
    ///
    /// - Parameters:
    ///   - progress: 移动的进度
    ///   - originIndex: 初始Index
    ///   - targetIndex: 目标index
    func pageContentViewDidScroll(progress : CGFloat, originIndex : Int, targetIndex : Int)

    func pageContentViewDidScrollToItem(atIndex targetIndex : Int)
}


public class STSegmentContentView: UIView {
    
    public weak var delegate : STSegmentContentViewDelegate?
    
    //默认 0.5, 最大0.8.最好和Configure中的STSegmentTitleViewIndicatorScrollStyle一直
    public var scrollToNextRatio : CGFloat = 0.5{
        didSet{
            if scrollToNextRatio > 0.8 {
                scrollToNextRatio = 0.8
            }
            else if scrollToNextRatio <= 0{
                scrollToNextRatio = 0.5
            }
        }
    }
    
    /// 存储控制器
    private var controllers : [UIViewController]?{
        didSet{
            contentView?.reloadData()
        }
    }
    
    //是否点击标题视图中的按钮
    private var isClickedBtn : Bool = true
    //开始滚动时的x-offset
    private var startOffsetX : CGFloat = 0
    
    private var flowLayout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    private var parentViewController : UIViewController?
    
    private var contentView : UICollectionView?
    
    private var stopDraging = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    /// 初始化方法
    ///
    /// - Parameters:
    ///   - frame: frame
    ///   - childrenControllers: 子视图
    ///   - parentVC: 父视图
    convenience public init(frame: CGRect, childrenControllers : [UIViewController]?, parentVC : UIViewController){
        self.init(frame: frame)
        self.backgroundColor = .white
        controllers = childrenControllers
        parentViewController = parentVC
        setupUIs()
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        contentView?.frame = CGRect(x: 0, y: 0, width: self.width, height: self.height)
        flowLayout.itemSize = self.bounds.size
    }
    
    private func setupUIs(){
        if let parentVC = parentViewController {
            controllers?.forEach({ (vc) in
                parentVC.addChildViewController(vc)
            })
        }
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        contentView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        contentView?.showsVerticalScrollIndicator = false
        contentView?.showsHorizontalScrollIndicator = false
        contentView?.bounces = false
        contentView?.delegate = self
        contentView?.dataSource = self
        contentView?.register(STContentViewCell.self, forCellWithReuseIdentifier: "STContentViewCell")
        addSubview(contentView!)
    }
    
    /// 点中选择item
    ///
    /// - Parameter index: 选中的item
    public func didSelectedItemAtIndex(atIndex index: Int){
        isClickedBtn = true
        if let vcs = controllers, index >= 0, index < vcs.count {
            contentView?.scrollToItem(at: IndexPath(row: index, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
}

extension STSegmentContentView : UIScrollViewDelegate{
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isClickedBtn = false
        stopDraging = false
        startOffsetX = scrollView.contentOffset.x
//        print("scrollViewWillBeginDragging")
    }
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //当点击标题选中的时候，对滚动进行其他处理
        if isClickedBtn {
//            print("isClickedBtn = true")
            return
        }
//        print("scrollViewDidScroll")
        let currentOffsetX = scrollView.contentOffset.x
        var originalIndex = 0
        var targetIndex = originalIndex + 1
        var progress : CGFloat = 0
        guard let vcs = controllers else { return }
        //从滑动开始，一次只能滑动一个页面
        
        if startOffsetX != currentOffsetX {
            //左滑
            if currentOffsetX > startOffsetX {
                originalIndex = Int(startOffsetX / scrollView.width)
                targetIndex = originalIndex + 1
                if targetIndex >= vcs.count {
                    targetIndex = vcs.count - 1
                }
                //判断当前滚动进度，先以当前offset对视图宽度取余
                //然后将取余后的值除以视图宽度就是滚动的进度
                if currentOffsetX - startOffsetX >= scrollView.width * scrollToNextRatio{
                    progress = 1.0
                }
                else{
                    progress = currentOffsetX.truncatingRemainder(dividingBy: scrollView.width)/scrollView.width
                }
            }
                //右滑
            else{
                originalIndex = Int(startOffsetX / scrollView.width)
                targetIndex = originalIndex - 1
                if targetIndex <= 0{
                    targetIndex = 0
                }
                if startOffsetX - currentOffsetX >= scrollView.width * scrollToNextRatio{
                    progress = 1.0
                }
                else{
                    progress = 1 - currentOffsetX.truncatingRemainder(dividingBy: scrollView.width)/scrollView.width
                }
            }
//            print("originalIndex : \(originalIndex)")
//            print("targetIndex : \(targetIndex)")
            if let contentDelegate = delegate {
                contentDelegate.pageContentViewDidScroll(progress: progress, originIndex: originalIndex, targetIndex: targetIndex)
            }
        }
 
        
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        print("scrollViewDidEndDragging")
        let currentOffsetX = scrollView.contentOffset.x
        var originalIndex = 0
        var targetIndex = originalIndex + 1
        
        guard let vcs = controllers else { return }
        //从滑动开始，一次只能滑动一个页面
        originalIndex = Int(startOffsetX / scrollView.width)
        targetIndex = originalIndex
        if currentOffsetX != startOffsetX {
            //左滑
            if currentOffsetX > startOffsetX {
                //判断当前滚动进度，先以当前offset对视图宽度取余
                //然后将取余后的值除以视图宽度就是滚动的进度
                if currentOffsetX - startOffsetX >= scrollView.width * scrollToNextRatio {
                    targetIndex = originalIndex + 1
                    if targetIndex >= vcs.count {
                        targetIndex = vcs.count - 1
                    }
                }
            }
                //右滑
            else{
                if startOffsetX - currentOffsetX >= scrollView.width * scrollToNextRatio{
                    targetIndex = originalIndex - 1
                    if targetIndex <= 0{
                        targetIndex = 0
                    }
                }
            }
            if scrollView == contentView {
                if let vcs = controllers, originalIndex >= 0, originalIndex < vcs.count {
                    if let contentDelegate = delegate {
                        contentDelegate.pageContentViewDidScrollToItem(atIndex: targetIndex)
                    }
                    contentView?.scrollToItem(at: IndexPath(row: targetIndex, section: 0), at: .centeredHorizontally, animated: true)
                }
            }
        }
    }
    // called when scroll view grinds to a halt
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        print("scrollViewDidEndDecelerating")
        let currentOffsetX = scrollView.contentOffset.x
        var originalIndex = 0
        var targetIndex = originalIndex + 1
        
        guard let vcs = controllers else { return }
        //从滑动开始，一次只能滑动一个页面
        originalIndex = Int(startOffsetX / scrollView.width)
        targetIndex = originalIndex
        if currentOffsetX != startOffsetX {
            //左滑
            if currentOffsetX > startOffsetX {
                //判断当前滚动进度，先以当前offset对视图宽度取余
                //然后将取余后的值除以视图宽度就是滚动的进度
                if currentOffsetX - startOffsetX >= scrollView.width * scrollToNextRatio {
                    targetIndex = originalIndex + 1
                    if targetIndex >= vcs.count {
                        targetIndex = vcs.count - 1
                    }
                }
            }
            //右滑
            else{
                if startOffsetX - currentOffsetX >= scrollView.width * scrollToNextRatio{
                    targetIndex = originalIndex - 1
                    if targetIndex <= 0{
                        targetIndex = 0
                    }
                }
            }
            if scrollView == contentView {
                if let vcs = controllers, originalIndex >= 0, originalIndex < vcs.count {
                    if let contentDelegate = delegate {
                        contentDelegate.pageContentViewDidScrollToItem(atIndex: targetIndex)
                    }
                    contentView?.scrollToItem(at: IndexPath(row: targetIndex, section: 0), at: .centeredHorizontally, animated: true)
                }
            }
        }
    }
}
extension STSegmentContentView : UICollectionViewDelegate, UICollectionViewDataSource{
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return controllers?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "STContentViewCell", for: indexPath) as? STContentViewCell
        if cell == nil {
            cell = STContentViewCell()
        }
        if let vcs = controllers, indexPath.row < vcs.count {
            cell?.childVC = vcs[indexPath.row]
        }
        
        return cell!
    }
}



//MARK: - Cell
class STContentViewCell: UICollectionViewCell {
    
    var childVC : UIViewController?{
        didSet{
            guard let child = childVC else { return }
            contentView.subviews.forEach { (v) in
                v.removeFromSuperview()
            }
            child.view.frame = contentView.frame
            contentView.addSubview((child.view)!)
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

