//
//  AlertDataModel.swift
//  alarmClock
//
//  Created by tangwei on 16/12/12.
//  Copyright © 2016年 tangwei. All rights reserved.
//

import UIKit

class AlertDataModel: NSObject {

    var noticeId : NSString = ""        //通知id
    var noticeTime : NSString = ""      //通知时间
    var noticeRepeat : NSString = ""    //重复
    var isOpen : NSString = ""          //是否开启
    var noticeTab : NSString = ""       //通知标签
    
    init( dic: [String:AnyObject] )
    {
        super.init()
        //模型一键赋值这个其实是运用了kvc的原理
        self.setValuesForKeys(dic)
    }
    
    //kvo
    override func setValue(_ value: Any?, forUndefinedKey key: String)
    {
        NSLog("UndefinedKey = \(key)")
    }
    
}
