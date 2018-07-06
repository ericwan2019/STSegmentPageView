//
//  STSegment+extension.swift
//  Pods
//
//  Created by 万鸿恩 on 2018/6/27.
//

import Foundation
import UIKit

public extension UIColor{
    
    /// 将UIColor转换为R,G,B,Alpha数组,取值范围0~1.0
    ///
    /// - Returns: RGB,Alpha值
    public func getRGBValue() -> [CGFloat]?{
        var components : [CGFloat]?
        if let coms = self.cgColor.components {
            //极个别系统预设颜色，RGB相等只有两个数值: 色值，alpha
            if coms.count == 2{
                components = [coms[0],coms[0],coms[0],coms[1]]
            }
            else if coms.count == 4{
                components = coms
            }
            else{
                print("what color is it?")
            }
        }
        return components
    }
}


public extension String{
    
    /// 获取文本的Size
    ///
    /// - Parameter font: 文本字体
    public func getStringSize(font : UIFont) -> CGSize{
        return NSString(string: self).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : font], context: nil).size
    }
}

public extension UIView {
    
    var x: CGFloat {
        get {
            return self.frame.origin.x
        } set (value) {
            self.frame = CGRect (x: value, y: self.y, width: self.width, height: self.height)
        }
    }
    
    var y: CGFloat {
        get {
            return self.frame.origin.y
        } set (value) {
            self.frame = CGRect (x: self.x, y: value, width: self.width, height: self.height)
        }
    }
    
    var width: CGFloat {
        get {
            return self.frame.size.width
        } set (value) {
            self.frame = CGRect (x: self.x, y: self.y, width: value, height: self.height)
        }
    }
    
    var height: CGFloat {
        get {
            return self.frame.size.height
        } set (value) {
            self.frame = CGRect (x: self.x, y: self.y, width: self.width, height: value)
        }
    }
    
    var left: CGFloat {
        get {
            return self.x
        } set (value) {
            self.x = value
        }
    }
    
    var right: CGFloat {
        get {
            return self.x + self.width
        } set (value) {
            self.x = value - self.width
        }
    }
    
    var top: CGFloat {
        get {
            return self.y
        } set (value) {
            self.y = value
        }
    }
    
    var bottom: CGFloat {
        get {
            return self.y + self.height
        } set (value) {
            self.y = value - self.height
        }
    }
    
    var centerX: CGFloat {
        get {
            return self.frame.center.x + self.width/2
        } set (value) {
            let newOrigin = CGPoint(x: value - self.width/2, y: self.frame.origin.y)
            self.frame = CGRect (origin: newOrigin, size: self.frame.size)
        }
    }
    
    var centerY: CGFloat {
        get {
            return self.frame.origin.y + self.height/2
        } set (value) {
            let newOrigin = CGPoint(x: self.frame.origin.x, y: value - self.height/2)
            self.frame = CGRect (origin: newOrigin, size: self.frame.size)
        }
    }
    
    var position: CGPoint {
        get {
            return self.frame.origin
        } set (value) {
            self.frame = CGRect (origin: value, size: self.frame.size)
        }
    }
    
    var size: CGSize {
        get {
            return self.frame.size
        } set (value) {
            self.frame = CGRect (origin: self.frame.origin, size: value)
        }
    }
    
    func leftWithOffset (_ offset: CGFloat) -> CGFloat {
        return self.left - offset
    }
    
    func rightWithOffset (_ offset: CGFloat) -> CGFloat {
        return self.right + offset
    }
    
    func topWithOffset (_ offset: CGFloat) -> CGFloat {
        return self.top - offset
    }
    
    func bottomWithOffset (_ offset: CGFloat) -> CGFloat {
        return self.bottom + offset
    }
}



public extension CGRect {
    
    /// 返回 Rect 的 Center 位置
    var center: CGPoint {
        get {
            return CGPoint(x: size.width / 2, y: size.height / 2)
        }
        set {
            self.origin = CGPoint(x: newValue.x - size.width / 2, y: newValue.y - size.height / 2)
        }
    }
    
    var bottom: CGFloat {
        return self.origin.y + self.size.height
    }
    
    var x: CGFloat {
        return self.origin.x
    }
    
    var y: CGFloat {
        return self.origin.y
    }
    
    var width: CGFloat {
        return self.size.width
    }
    
    var height: CGFloat {
        return self.size.height
    }
    
}

