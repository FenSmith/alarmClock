//
//  UtilHelper.swift
//  alarmClock
//
//  Created by tangwei on 16/12/13.
//  Copyright © 2016年 tangwei. All rights reserved.
//

import UIKit

class UtilHelper: NSObject {
    
    class func addNotification(alertModel: AlertDataModel) {
        
        let formateter : DateFormatter = DateFormatter.init()
        formateter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        // 初始化一个通知
        let localNoti = UILocalNotification()
        // 通知的触发时间，例如即刻起15分钟后
        let fireDate = formateter.date(from: alertModel.noticeTime as String)
        localNoti.fireDate = fireDate as Date?
        // 设置时区
        localNoti.timeZone = NSTimeZone.default
        // 通知上显示的主题内容
        localNoti.alertBody = alertModel.noticeTab as String?
        // 收到通知时播放的声音，默认消息声音
        localNoti.soundName = UILocalNotificationDefaultSoundName
        //待机界面的滑动动作提示
        localNoti.alertAction = alertModel.noticeTab as String?
        // 应用程序图标右上角显示的消息数
        localNoti.applicationIconBadgeNumber = 0
        // 通知上绑定的其他信息，为键值对
        localNoti.userInfo = [alertModel.noticeId: "1"]
        
        //重复时间
        if (alertModel.noticeRepeat.isEqual(to: "1")) {
            localNoti.repeatInterval = NSCalendar.Unit.day
        }
        else if (alertModel.noticeRepeat.isEqual(to: "2")) {
            localNoti.repeatInterval = NSCalendar.Unit.weekday
        }
        else if (alertModel.noticeRepeat.isEqual(to: "3")) {
            localNoti.repeatInterval = NSCalendar.Unit.weekdayOrdinal
        }
        else if (alertModel.noticeRepeat.isEqual(to: "4")) {
            localNoti.repeatInterval = NSCalendar.Unit.month
        }
        else if (alertModel.noticeRepeat.isEqual(to: "5")) {
            localNoti.repeatInterval = NSCalendar.Unit.year
        }
        
        // 添加通知到系统队列中，系统会在指定的时间触发
        UIApplication.shared.scheduleLocalNotification(localNoti)
    }
    
    class func deleteNotification(id: String) {
        if id.isEmpty {
            return
        }
        
        if let locals = UIApplication.shared.scheduledLocalNotifications {
            for localNoti in locals {
                if let dict = localNoti.userInfo {
                    
                    let info = dict[id]
                    if info != nil {
                        UIApplication.shared.cancelLocalNotification(localNoti)
                        break
                    }
                }
            }
        }
    }
    
    class func cancelAllNotification() -> Void {

        UIApplication.shared.cancelAllLocalNotifications()
    }
    
    class func getWeek(noticeRepeat: NSString) -> NSString
    {
        var string : NSString = ""
        
        if noticeRepeat.isEqual(to: "0") {
            string = type_repeat_title.never.rawValue
        }
        else if noticeRepeat.isEqual(to: "1") {
            string = type_repeat_title.day.rawValue
        }
        else if noticeRepeat.isEqual(to: "2") {
            string = type_repeat_title.weekday.rawValue
        }
        else if noticeRepeat.isEqual(to: "3") {
            string = type_repeat_title.weekdayOrdinal.rawValue
        }
        else if noticeRepeat.isEqual(to: "4") {
            string = type_repeat_title.month.rawValue
        }
        else if noticeRepeat.isEqual(to: "5") {
            string = type_repeat_title.year.rawValue
        }
        
        return string
    }
    
    class func getGUID() -> NSString {
        let uuidObj : CFUUID = CFUUIDCreate(nil)
        let uuidString : NSString = CFUUIDCreateString(nil, uuidObj)
        
        return uuidString
    }
    
    class func getDataModel(array: NSMutableArray) -> NSMutableArray
    {
        var arrayModel : NSMutableArray = NSMutableArray.init(capacity: 0)
        if array.count == 0 {
            arrayModel = NSMutableArray.init(capacity: 0)
        }
        
        var alertModel : AlertDataModel?
        for i in 0 ..< array.count {
            let dic : [String:AnyObject] = array.object(at: i) as! [String:AnyObject]
            alertModel = AlertDataModel.init(dic: dic)
            arrayModel.add(alertModel)
        }
        
        return arrayModel
    }
}
