//
//  EditAlertViewController.swift
//  alarmClock
//
//  Created by tangwei on 16/12/7.
//  Copyright © 2016年 tangwei. All rights reserved.
//

import UIKit

class EditAlertViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    open var editAlertFlag : NSInteger?   //0:编辑 1:添加
    open var dataModel : AlertDataModel?
    
    fileprivate let cellHeight : NSInteger = 45
    fileprivate let headHeight : NSInteger = 200
    fileprivate var tableView  : UITableView?
    fileprivate var clockDatePicker : UIDatePicker?
    fileprivate var arrayTitle   : NSArray?
    fileprivate var selectedDate : NSDate?
    fileprivate var noticeRepeat : NSString?
    fileprivate var noticeTab    : NSString?
    fileprivate var dbMgr : DBMgr?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if ( editAlertFlag == nil ){
            return
        }

        self.modify_NavBar()
        self.init_data()
        self.init_ui()
    }
    
    func modify_NavBar() -> Void
    {
        self.btnLeft?.setImage(UIImage.init(named: "navBar_back"), for: UIControlState.normal)
        
        if ( editAlertFlag == type_modify_alert.edit_alert.rawValue ){
            self.navTitle?.text = "编辑事项"
            self.btnRight?.setTitle("保存", for: UIControlState.normal)
        }
        else if ( editAlertFlag == type_modify_alert.add_alert.rawValue ){
            self.navTitle?.text = "添加事项"
            self.btnRight?.setTitle("保存", for: UIControlState.normal)
        }
    }
    
    func init_data() -> Void
    {
        self.dbMgr = DBMgr.sharedInstance()
        self.arrayTitle = ["重复", "标签"]
        
        if dataModel == nil {
            self.noticeRepeat = "0"
            self.noticeTab = "提醒事项"
        }
        else {
            let formateter : DateFormatter = DateFormatter.init()
            formateter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            self.selectedDate = formateter.date(from: dataModel?.noticeTime as! String) as NSDate?
            
            self.noticeRepeat = dataModel?.noticeRepeat
            self.noticeTab = dataModel?.noticeTab
        }
    }
    
    func init_ui() -> Void
    {
        if ( self.tableView == nil ) {
            self.tableView = UITableView.init(frame: CGRect(x: 0, y: 64, width: screenWidth, height: screenHeight - 64), style: UITableViewStyle.grouped)
            self.tableView?.backgroundColor = UIColor.clear
            self.tableView?.delegate = self
            self.tableView?.dataSource = self
            self.tableView?.allowsSelectionDuringEditing = true
            self.tableView?.separatorStyle = UITableViewCellSeparatorStyle.singleLine
            self.tableView?.separatorColor = colorWithHexString(hex: "#232323")
            self.view.addSubview(self.tableView!)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if ( editAlertFlag == type_modify_alert.edit_alert.rawValue ){
            return 2
        }
        else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if( section == 0 ){
            return (self.arrayTitle?.count)!
        }
        else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return CGFloat(self.cellHeight);
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if( section == 0 ){
            return CGFloat(self.headHeight)
        }
        else{
            return 30
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let view : UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: Int(screenWidth), height:headHeight))
        view.backgroundColor = colorWithHexString(hex: "#0f0f0f")
        
        if ( section == 0 ){
            if self.clockDatePicker == nil {
                self.clockDatePicker = UIDatePicker.init()
                self.clockDatePicker?.frame = CGRect(x: 0.0, y: 20.0, width: CGFloat(screenWidth), height: 160.0)
                self.clockDatePicker?.datePickerMode = UIDatePickerMode.dateAndTime
                self.clockDatePicker?.setValue(colorWithHexString(hex: "#c7c7c7"), forKey: "textColor")
                self.clockDatePicker?.setValue(colorWithHexString(hex: "#c7c7c7"), forKey: "highlightColor")
                self.clockDatePicker?.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: UIControlEvents.valueChanged)
            }
            view.addSubview(self.clockDatePicker!)
            
            if (self.selectedDate == nil) {
                self.clockDatePicker?.date = NSDate.init() as Date
                self.selectedDate = self.clockDatePicker?.date as NSDate?
            }
            else
            {
                self.clockDatePicker?.date = self.selectedDate as! Date;
            }
            
            let viewTop : UIView = UIView.init(frame: CGRect(x: 0.0, y: CGFloat(83.5), width: CGFloat(screenWidth), height: 0.5))
            viewTop.backgroundColor = colorWithHexString(hex: "#232323")
            view.addSubview(viewTop)
            
            let viewBottom : UIView = UIView.init(frame: CGRect(x: 0.0, y: CGFloat(118.0), width: CGFloat(screenWidth), height: 0.5))
            viewBottom.backgroundColor = colorWithHexString(hex: "#232323")
            view.addSubview(viewBottom)
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        return self.layoutCell(tableView: tableView, indexPath: indexPath);
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if ( indexPath.section == 0 ){
            if ( indexPath.row == 0 ){
                let vc : RepeatViewController = RepeatViewController()
                vc.noticeRepeat = self.noticeRepeat
                vc.initWithClosure(closure: getRepeatAClosure)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if ( indexPath.row == 1 ){
                let vc : TabViewController = TabViewController()
                vc.noticeTab = self.noticeTab
                vc.initWithClosure(closure: getTabAClosure)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if indexPath.section == 1 {
            self.dbMgr?.del_table_data(self.dataModel?.noticeId as String!)
            UtilHelper.deleteNotification(id: self.dataModel?.noticeId as! String)
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
    func layoutCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    {
        let id = "editAlertCell"
        let cell : UITableViewCell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: id)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let view : UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: Int(screenWidth), height: cellHeight))
        view.backgroundColor = colorWithHexString(hex: "#161616")
        cell.addSubview(view)
        
        if ( indexPath.section == 0 ){
            
            let labelTitle : UILabel = UILabel.init(frame: CGRect(x: Int(spacingLayoutLeft), y: 0, width: 40, height: cellHeight))
            labelTitle.font = UIFont.systemFont(ofSize: 17.0)
            labelTitle.textColor = UIColor.white
            labelTitle.text = self.arrayTitle?.object(at: indexPath.row) as! String?
            view.addSubview(labelTitle)
            
            let labelValue : UILabel = UILabel.init(frame: CGRect(x: Int(spacingLayoutLeft + 40), y: 0, width: (Int(screenWidth) - Int(spacingLayoutLeft + 40) - 30), height: cellHeight))
            labelValue.font = UIFont.systemFont(ofSize: 17.0, weight: UIFontWeightThin)
            labelValue.textColor = UIColor.lightGray
            labelValue.textAlignment = NSTextAlignment.right
            view.addSubview(labelValue)
            
            let imageMore : UIImageView = UIImageView.init(frame: CGRect(x: Int(screenWidth - 22), y: Int(cellHeight / 2 - 5), width: 9, height: 10))
            imageMore.image = UIImage.init(named: "more")
            imageMore.tag = 104
            view.addSubview(imageMore)
            
            if ( indexPath.row == 0 ){
                labelValue.text = UtilHelper.getWeek(noticeRepeat: self.noticeRepeat!) as String
            }
            else if ( indexPath.row == 1 ){
                labelValue.text = self.noticeTab as String?
            }
        }
        else{
            let labelTitle : UILabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: Int(screenWidth), height: cellHeight))
            labelTitle.font = UIFont.systemFont(ofSize: 17.0, weight: UIFontWeightThin)
            labelTitle.textColor = colorWithHexString(hex: "#fc332b")
            labelTitle.text = "删除事项"
            labelTitle.textAlignment = NSTextAlignment.center
            view.addSubview(labelTitle)
        }
        
        return cell
    }
    
    override func clickNavLeft() -> Void{
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func clickNavRight() -> Void{
        
        let formateter : DateFormatter = DateFormatter.init()
        formateter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dbMgr : DBMgr = DBMgr.sharedInstance()
        
        if dataModel == nil {
            let dic : [String:AnyObject] = ["noticeId": UtilHelper.getGUID(), "noticeTime": formateter.string(from: (self.selectedDate as? Date)!) as NSString, "noticeRepeat": self.noticeRepeat!, "isOpen": "1" as AnyObject, "noticeTab": self.noticeTab!]
            self.dataModel = AlertDataModel.init(dic: dic)
            
            dbMgr.add_alert_table_data((dataModel?.noticeId)! as String, time: (dataModel?.noticeTime)! as String, repeat: (dataModel?.noticeRepeat)! as String, isOpen: (dataModel?.isOpen)! as String, tab: (dataModel?.noticeTab)! as String)
        }
        else {
            
            dataModel?.noticeRepeat = self.noticeRepeat!
            dataModel?.noticeTab = self.noticeTab!
            dataModel?.noticeTime = formateter.string(from: (self.selectedDate as? Date)!) as NSString
            
            UtilHelper.deleteNotification(id: dataModel?.noticeId as! String)
            dbMgr.update_alert_table_data((dataModel?.noticeId)! as String, time: (dataModel?.noticeTime)! as String, repeat: (dataModel?.noticeRepeat)! as String, isOpen: (dataModel?.isOpen)! as String, tab: (dataModel?.noticeTab)! as String)
        }
        
        UtilHelper.addNotification(alertModel: dataModel!)
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    func getRepeatAClosure(noticeRepeat: NSString) -> Void {
        self.noticeRepeat = noticeRepeat
        self.tableView?.reloadData()
    }
    
    func getTabAClosure(noticeTab: NSString) -> Void {
        self.noticeTab = noticeTab
        self.tableView?.reloadData()
    }
    
    func datePickerValueChanged(_ datePicker : UIDatePicker) -> Void
    {
        self.selectedDate = datePicker.date as NSDate?;
        
        NSLog("selectedDate2-------\(self.selectedDate)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}
