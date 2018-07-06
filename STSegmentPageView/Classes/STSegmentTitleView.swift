//
//  STSegmentTitleView.swift
//  STSegmentPageView
//
//  Created by 万鸿恩 on 2018/6/26.
//  Copyright © 2018年 万鸿恩. All rights reserved.
//

import UIKit


public protocol STSegmentTitleViewDelegate : NSObjectProtocol {
    
    /// 点击选择标题视图item
    ///
    /// - Parameter index: index
    func didSelectedSegmentTitleViewItemAt(atIndex index:Int)
}

public class STSegmentTitleView: UIView {
    
    public weak var delegate : STSegmentTitleViewDelegate?
    
    private var configure = STSegmentPageTitleViewConfigure()
    private var titlesAry : [String]?
    private var titleButtons : [UIButton]?
    private var rightButton : UIButton?
    
    /// 正常颜色的RGB，取值范围 0~1.0
    private var startR : CGFloat = 0.0
    private var startG : CGFloat = 0.0
    private var startB : CGFloat = 0.0
    private var startAlpha : CGFloat = 1.0
    /// 选中颜色的RGB, 取值范围 0~1.0
    private var endR : CGFloat = 0.0
    private var endG : CGFloat = 0.0
    private var endB : CGFloat = 0.0
    private var endAlpha : CGFloat = 1.0
    //记录选中的按钮
    private var selectedBtn : UIButton?
    //总的视图宽度,正常情况长度
    private var totalContentSizeWidthNormalStatus : CGFloat = 0
    
    private var isFirstTime : Bool = false
    
    private lazy var scrollView : UIScrollView = {
        let scroll = UIScrollView(frame: CGRect.zero)
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.alwaysBounceHorizontal = true
        return scroll
    }()
    
    private lazy var indicatorView : UIView = {
        let indicator = UIView(frame: .zero)
        indicator.layer.masksToBounds = true
        return indicator
    }()
    private lazy var bottomSeparatorView : UIView = {
        let bottomSeparator = UIView(frame: .zero)
        return bottomSeparator
    }()
    
    private lazy var shadowView : UIView = {
        let shadow = UIView(frame: .zero)
        return shadow
    }()
    
    /// 初始化方法
    ///
    /// - Parameter config: 标题视图相关设置，如若不赋值或nil时，采用默认值
    ///   - titles: 标题数组
    convenience public init(config : STSegmentPageTitleViewConfigure? = STSegmentPageTitleViewConfigure(), titles : [String]?){
        self.init()
        if let con = config {
            configure = con
        }
        titlesAry = titles
        setUpUIs()
    }
    
    /// 初始化方法
    ///
    /// - Parameters:
    ///   - frame: 标题视图frame
    ///   - config: 标题视图相关设置，如若不赋值或nil时，采用默认值
    ///   - titles: 标题数组
    convenience public init(frame : CGRect, config : STSegmentPageTitleViewConfigure? = STSegmentPageTitleViewConfigure(), titles : [String]?){
        self.init(frame: frame)
        if let con = config {
            configure = con
        }
        titlesAry = titles
        setUpUIs()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        //右侧按钮
        if configure.wouldUseRightButton && configure.rightButton != nil {
            //获取设置进来的按钮的frame
            var btnOldFrame = configure.rightButton!.frame
            if btnOldFrame == .zero{
                btnOldFrame = CGRect(x: 0, y: 0, width: self.height, height: self.height)
            }
            var btnFrame = CGRect(x: self.width - btnOldFrame.width, y: (self.height  - btnOldFrame.height)/2, width: btnOldFrame.width, height: btnOldFrame.height)
            if btnOldFrame.height > self.height {
                let btnW = (self.height ) * (btnOldFrame.width / btnOldFrame.height)
                btnFrame = CGRect(x: self.width - btnW, y: 0, width: btnW, height: self.height )
            }
            rightButton?.frame = btnFrame
            var shadowMargin : CGFloat = 0
            if configure.showRightButtonSeparator {
                shadowView.frame = CGRect(x: self.width - btnFrame.width - 1, y: 15/2, width: 1, height: self.height - 15)
                shadowMargin = 1
            }
            scrollView.frame = CGRect(x: 0, y: 0, width: self.width - btnFrame.width - shadowMargin, height: self.height)
        }
        else{
            scrollView.frame = CGRect(x: 0, y: 0, width: self.width, height: self.height)
        }
        //底线
        if configure.bottomSeparatorStyle == .default {
            bottomSeparatorView.frame = CGRect(x: 0, y: self.height - configure.bottonSeparatorHeight, width: self.width, height: configure.bottonSeparatorHeight)
        }
        //按钮
        layoutTitleButtonsWhenNeedUpdate()
        //指示器
        firstTimeInitButtonLayout()
        //更新滚动视图
        scrollView.isScrollEnabled = (totalContentSizeWidthNormalStatus > scrollView.width)
    }
    
    
    /// 更新标题视图在移动的时候，用于外部更新标题
    ///
    /// - Parameters:
    ///   - progress: 移动的进度 0~1
    ///   - fromIndex: from index
    ///   - endIndex: end index
    public func updateTitleViewWhenContentViewDrag(progress : CGFloat, fromIndex : Int, endIndex:Int){
        if let nameBtns = titleButtons, fromIndex >= 0, endIndex >= 0, fromIndex < nameBtns.count, endIndex < nameBtns.count {
            st_GradientTitleViewWhenContentViewScroll(progress: progress, fromIndex: fromIndex, endIndex: endIndex,sendDelegate: false)
        }
    }
    
    public func didSelectedTitleItemAtIndex(atIndex index : Int){
        if let nameBtns = titleButtons, index >= 0, index < nameBtns.count {
            let sender = nameBtns[index]
            st_changeButtonsStatus(sender: sender, strikeDelegate: true)
        }
    }
    
}

extension STSegmentTitleView{
    
    //MARK: - Setup
    /// 初始化UI
    private func setUpUIs(){
        self.backgroundColor = self.configure.titleViewBackgroundColor
        setupContentView()
        setTitleButtons()
        setupIndicatorView()
        setUIRightbutton()
        setupColor()
    }
    
    
    /// 右侧按钮左侧分割线
    private func setupRightSepartorView(){
        if configure.showRightButtonSeparator {
            shadowView.backgroundColor = UIColor.lightGray
            addSubview(shadowView)
        }
    }
    
    /// 底部分割线
    private func setupBottonSeparatorView(){
        if configure.bottomSeparatorStyle == .default {
            addSubview(bottomSeparatorView)
            bottomSeparatorView.backgroundColor = configure.bottomSeparatorColor
            bottomSeparatorView.height = configure.bottonSeparatorHeight
        }
    }
    
    /// 设置指示器视图
    private func setupIndicatorView(){
        if configure.indicatorStyle != .none {
            scrollView.addSubview(indicatorView)
            indicatorView.backgroundColor = configure.indicatorColor
            indicatorView.layer.cornerRadius = configure.indicatorCornerRadius
        }
        
    }
    
    /// 设置标题视图
    private func setupContentView(){
        addSubview(scrollView)
        scrollView.bounces = configure.shouldBounces
        scrollView.delegate = self
        if configure.bottomSeparatorStyle != .none {
            addSubview(bottomSeparatorView)
            bottomSeparatorView.backgroundColor = configure.bottomSeparatorColor
        }
    }
    
    /// 右侧按钮
    private func setUIRightbutton(){
        if configure.wouldUseRightButton && configure.rightButton != nil{
            rightButton = configure.rightButton
            addSubview(rightButton!)
            if configure.didClickRightButtonAt != nil{
                rightButton?.addTarget(self, action: #selector(rightButtonAction), for: .touchUpInside)
            }
        }
    }
    
    /// 标题按钮
    private func setTitleButtons(){
        if let titlesBtn = titleButtons {
            titlesBtn.forEach { (btn) in
                btn.removeFromSuperview()
            }
            titleButtons?.removeAll()
        }
        titleButtons = []
        totalContentSizeWidthNormalStatus = configure.spaceBetweenFirstTitleAndLeftSide
        if let names = titlesAry {
            for (i,name) in names.enumerated(){
                let wordSize = name.getStringSize(font: configure.titleFont)
                let btn = UIButton()
                btn.tag = i
                btn.addTarget(self, action: #selector(didSelectedTitleButton(sender:)), for: .touchUpInside)
                btn.setTitleColor(configure.titleNormalColor, for: .normal)
                btn.titleLabel?.font = configure.titleFont
                btn.setTitle(name, for: .normal)
                scrollView.addSubview(btn)
                totalContentSizeWidthNormalStatus += wordSize.width + configure.spaceBetweenTitles
                titleButtons?.append(btn)
                if i == 0{
                    btn.setTitleColor(configure.titleSelectedColor, for: .normal)
                    selectedBtn = btn;
                }
            }
            scrollView.contentSize = CGSize(width: totalContentSizeWidthNormalStatus, height: self.height)
        }
    }
    
    private func setupColor(){
        if let coms = configure.titleNormalColor.getRGBValue() {
            startR = coms[0]
            startG = coms[1]
            startB = coms[2]
            startAlpha = coms[3]
        }
        if let coms = configure.titleSelectedColor.getRGBValue() {
            endR = coms[0]
            endG = coms[1]
            endB = coms[2]
            endAlpha = coms[3]
        }
    }
    //MARK: - 点击事件
    /// 右侧按钮点击事件
    @objc private func rightButtonAction(){
        if let rightClick = configure.didClickRightButtonAt {
            rightClick()
        }
    }
    
    /// 点击标题按钮
    ///
    /// - Parameter sender: sender
    @objc private func didSelectedTitleButton(sender : UIButton){
        st_changeButtonsStatus(sender: sender, strikeDelegate: true)
    }
    
    
    /// 改变按钮状态，是否触发点击代理
    ///
    /// - Parameters:
    ///   - sender: button
    ///   - strikeDelegate: 是否触发代理
    private func st_changeButtonsStatus(sender : UIButton, strikeDelegate : Bool){
        if let btns = titleButtons {
            btns.forEach { (btn) in
                btn.setTitleColor(configure.titleNormalColor, for: .normal)
                if configure.wouldScaledWhenSelected{
                    btn.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
                
            }
        }
        selectedBtn = sender
        sender.setTitleColor(configure.titleSelectedColor, for: .normal)
        if configure.wouldScaledWhenSelected {
            sender.transform = CGAffineTransform(scaleX: 1 + configure.deltaScaleIndex, y: 1 + configure.deltaScaleIndex)
        }
        
        st_changeIndicatorViewStatus(button: sender)
        //滚动标题视图
        st_changeContentViewOffSet(sender: sender)
        
        
        
        if strikeDelegate {
            //回调代理
            if let dele = delegate {
                dele.didSelectedSegmentTitleViewItemAt(atIndex: sender.tag)
            }
        }
    }
    
    /// 移动内容视图到选中的按钮
    ///
    /// - Parameter sender: 选中的按钮
    private func st_changeContentViewOffSet(sender : UIButton){
        if scrollView.isScrollEnabled {
            // 计算偏移量
            var offsetX = sender.center.x - scrollView.width * 0.5;
            if (offsetX < 0) {
                offsetX = 0
            }
            // 获取最大滚动范围
            let maxOffsetX = self.scrollView.contentSize.width - scrollView.width;
            if (offsetX > maxOffsetX){
                offsetX = maxOffsetX;
            }
            // 滚动标题滚动条
            self.scrollView.setContentOffset(CGPoint(x: offsetX, y: scrollView.contentOffset.y), animated: true)
        }
    }
    
    //MARK: - 状态变化
    
    /// 改变指示器状态
    ///
    /// - Parameter atButton: 点击的按钮
    private func st_changeIndicatorViewStatus(button atButton : UIButton){
        scrollView.bringSubview(toFront: indicatorView)
        if configure.indicatorStyle == .shade {
            scrollView.bringSubview(toFront: atButton)
        }
        layoutIndicatorView(button: atButton)
    }
    
    /// 第一次初始化按钮和指示器设置
    private func firstTimeInitButtonLayout(){
        if configure.indicatorStyle != .none && !isFirstTime{
            isFirstTime = true
            //初始化宽高
            layoutIndicatorView(button: selectedBtn)
            if configure.indicatorStyle == .shade {
                scrollView.bringSubview(toFront: selectedBtn!)
            }
            if configure.wouldScaledWhenSelected{
                selectedBtn?.transform = CGAffineTransform(scaleX: 1 + configure.deltaScaleIndex, y: 1 + configure.deltaScaleIndex)
                //缩放
                if (configure.indicatorStyle == .shade || configure.indicatorStyle == .default) {
                    indicatorView.transform = CGAffineTransform(scaleX: 1 + configure.deltaScaleIndex, y: 1 + configure.deltaScaleIndex)
                }
            }
        }
    }
    /// 计算指示器的位置
    ///
    /// - Parameter atButton: 选中按钮
    private func layoutIndicatorView(button atButton : UIButton?){
        //先还原缩放
        if (configure.indicatorStyle == .shade || configure.indicatorStyle == .default) &&  configure.wouldScaledWhenSelected{
            indicatorView.transform = CGAffineTransform(scaleX: 1 , y: 1 )
        }
        
        if let btnSize = atButton?.title(for: .normal)?.getStringSize(font: configure.titleFont){
            if configure.indicatorStyle == .shade{
                indicatorView.y = (self.height - btnSize.height)/2
                indicatorView.height = min(max(btnSize.height, configure.indicatorHeight), self.height)
                indicatorView.width = btnSize.width
            }
            else if configure.indicatorStyle == .default{
                indicatorView.y = self.height - configure.indicatorHeight
                indicatorView.height = configure.indicatorHeight
                indicatorView.width = btnSize.width
            }
            else if configure.indicatorStyle == .fixed{
                indicatorView.y = self.height - configure.indicatorHeight
                indicatorView.height = configure.indicatorHeight
                indicatorView.width = configure.indicatorWidthWhenFixedStyle
            }
            
            indicatorView.center.x = atButton?.center.x ?? 0
        }
        //缩放
        if (configure.indicatorStyle == .shade || configure.indicatorStyle == .default) &&  configure.wouldScaledWhenSelected{
            indicatorView.transform = CGAffineTransform(scaleX: 1 + configure.deltaScaleIndex, y: 1 + configure.deltaScaleIndex)
        }
    }
    
    /// 更新标题位置
    private func layoutTitleButtonsWhenNeedUpdate(){
        if let btns = titleButtons {
            var totalTitleWidth : CGFloat = configure.spaceBetweenFirstTitleAndLeftSide
            var btnX : CGFloat = 0
            let btnY : CGFloat = 0
            var btnW : CGFloat = 0
            var btnH : CGFloat = 0
            for (_,btn) in btns.enumerated(){
                let wordSize = btn.title(for: .normal)?.getStringSize(font: configure.titleFont) ?? CGSize(width: 0, height: 0)
                btnX = totalTitleWidth
                btnW = wordSize.width
                if configure.indicatorStyle == .default || configure.indicatorStyle == .fixed{
                    btnH = scrollView.height - configure.indicatorHeight
                }
                else{
                    btnH = scrollView.height
                }
                btn.frame = CGRect(x: btnX, y: btnY, width: btnW, height: btnH)
                totalTitleWidth += wordSize.width + configure.spaceBetweenTitles
            }
            
        }
    }
    
    /// 渐变标题视图颜色在移动的时候
    ///
    /// - Parameters:
    ///   - progress: 移动的进度 0~1
    ///   - fromIndex: from index
    ///   - endIndex: end index
    private func st_GradientTitleViewWhenContentViewScroll(progress : CGFloat, fromIndex : Int, endIndex:Int, sendDelegate : Bool = false){
        
        if let endBtn = titleButtons?[endIndex], let currentBtn = titleButtons?[fromIndex]{
            if configure.shouldTitleGradientEffect {
                let differenceR = endR - startR
                let differenceG = endG - startG
                let differenceB = endB - startB
                let differenceAlpha = endAlpha - startAlpha
                
                /// 当前选中按钮的渐变颜色
                let currentColorOfNext = UIColor(red: startR + differenceR*progress, green: startG + differenceG*progress, blue: startB + differenceB*progress, alpha: startAlpha + differenceAlpha*progress)
                endBtn.setTitleColor(currentColorOfNext, for: .normal)
            }
            
            let differenceTwoButtonCenter = endBtn.center.x - currentBtn.center.x
            if configure.indicatorStyle != .none{
                
                if progress >= configure.indicatorScrollStyle.rawValue{
                    UIView.animate(withDuration: configure.indicatorAnimationTime) {
                        self.indicatorView.center.x = differenceTwoButtonCenter + currentBtn.center.x
                    }
                    st_changeButtonsStatus(sender: endBtn, strikeDelegate: sendDelegate)
                }
                
                if configure.indicatorStyle == .shade {
                    scrollView.bringSubview(toFront: endBtn)
                    scrollView.bringSubview(toFront: currentBtn)
                }
            }
            else{
                if progress >= 0.8{
                    st_changeButtonsStatus(sender: endBtn, strikeDelegate: sendDelegate)
                }
            }
        }
    }
}

extension STSegmentTitleView : UIScrollViewDelegate{
    
}



