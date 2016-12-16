//
//  SQliteDBMgr.swift
//  alarmClock
//
//  Created by tangwei on 16/12/15.
//  Copyright © 2016年 tangwei. All rights reserved.
//

import UIKit

class SQliteDBMgr: NSObject {

    let db_table_alert = "table_alert"
    
    var db:SQLiteDB!
    
    override init() {
        super.init()
        
        db = SQLiteDB.sharedInstance
        //如果表还不存在则创建表（其中uid为自增主键）
        let result = db.execute(sql: "create table if not exists \(db_table_alert) (noticeId text, time text, repeat text, isOpen text, tab text)")
        print(result)
    }
    
    func add_alert_table_data(noticeId: NSString, time: NSString, repeatStr: NSString, isOpen: NSString, tab: NSString) -> Void
    {
        let sql = "insert into \(db_table_alert) (noticeId, time, repeat, isOpen, tab) values ('\(noticeId)', '\(time)', '\(repeatStr)', '\(isOpen)', '\(tab)')"
        print("sql: \(sql)")
        //通过封装的方法执行sql
        let result = db.execute(sql: sql)
        print(result)
    }
    
    func update_alert_table_data(noticeId: NSString, time: NSString, repeatStr: NSString, isOpen: NSString, tab: NSString) -> Void
    {
        let sql = "update \(db_table_alert) set time = '\(time)', repeat = '\(repeatStr)', isOpen = '\(isOpen)', tab = '\(tab)' where noticeId = '\(noticeId)'"
        print("sql: \(sql)")
        //通过封装的方法执行sql
        let result = db.execute(sql: sql)
        print(result)
    }
    
    func del_table_data(noticeId: NSString) -> Void
    {
        let sql = "delete from \(db_table_alert) where noticeId = '\(noticeId)'"
        print("sql: \(sql)")
        //通过封装的方法执行sql
        let result = db.execute(sql: sql)
        print(result)
    }
    
    func get_table_data() -> NSMutableArray
    {
        let data = db.query(sql: "select * from \(db_table_alert) order by noticeId asc")
        let arrayData : [[String:AnyObject]] = data as [[String : AnyObject]]
        
        let array : NSMutableArray = NSMutableArray.init(capacity: 0)
        for i in 0 ..< arrayData.count
        {
            let dic : NSMutableDictionary = NSMutableDictionary.init(capacity: 0)
            let alert = arrayData[i]
            dic.setValue(alert["noticeId"], forKey: "noticeId")
            dic.setValue(alert["time"], forKey: "time")
            dic.setValue(alert["repeat"], forKey: "repeat")
            dic.setValue(alert["isOpen"], forKey: "isOpen")
            dic.setValue(alert["tab"], forKey: "tab")
            array.add(dic)
        }
        
        return array
    }
}
