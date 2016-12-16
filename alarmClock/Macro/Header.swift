//
//  Header.swift
//  alarmClock
//
//  Created by tangwei on 16/12/5.
//  Copyright © 2016年 tangwei. All rights reserved.
//
import UIKit
import Foundation

enum type_modify_alert: NSInteger {
    case edit_alert = 0
    case add_alert = 1
}

enum type_repeat_mark: NSString {
    case not_mark = "0"
    case mark = "1"
}

enum type_repeat_title: NSString {
    case never = "从不"
    case day = "每天"
    case weekday = "每周"
    case weekdayOrdinal = "每两周"
    case month = "每月"
    case year = "每年"
}

//ui布局最左距离
let spacingLayoutLeft = 15.0

//屏幕宽度
let screenWidth = UIScreen.main.bounds.size.width

//屏幕高度
let screenHeight = UIScreen.main.bounds.size.height

//当前系统版本
let version = UIDevice.current.systemVersion as NSString

//3色设置
func RGB ( red:CGFloat, green:CGFloat, blue:CGFloat ) -> UIColor { return UIColor.init(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1) }
func RGBA ( red:CGFloat, green:CGFloat, blue:CGFloat, alpha:CGFloat ) -> UIColor { return UIColor.init(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha) }

//传入16进制色值
func colorWithHexString (hex: String) -> UIColor {

     var cString: String = hex.uppercased()

     if (cString.hasPrefix("#")) {
             cString = (cString as NSString).substring(from: 1)
     }

     if (cString.characters.count != 6) {
             return UIColor.gray
     }

     let rString = (cString as NSString).substring(to: 2)
     let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
     let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)

     var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
    
     Scanner.init(string: rString).scanHexInt32(&r)
     Scanner.init(string: gString).scanHexInt32(&g)
     Scanner.init(string: bString).scanHexInt32(&b)

     return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
}

func colorWithHexStringA (hex: String, alpha:CGFloat) -> UIColor {
    
    var cString: String = hex.uppercased()
    
    if (cString.hasPrefix("#")) {
        cString = (cString as NSString).substring(from: 1)
    }
    
    if (cString.characters.count != 6) {
        return UIColor.gray
    }
    
    let rString = (cString as NSString).substring(to: 2)
    let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
    let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
    
    var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
    
    Scanner.init(string: rString).scanHexInt32(&r)
    Scanner.init(string: gString).scanHexInt32(&g)
    Scanner.init(string: bString).scanHexInt32(&b)
    
    return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(alpha))
}
