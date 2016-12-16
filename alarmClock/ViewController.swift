//
//  ViewController.swift
//  alarmClock
//
//  Created by tangwei on 16/12/5.
//  Copyright © 2016年 tangwei. All rights reserved.
//

import UIKit

class ViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    fileprivate let cellHeight : NSInteger = 90
    
    fileprivate var bFirst : Bool = true
    fileprivate var arrayData : NSMutableArray?
    fileprivate var tableView : UITableView?
    fileprivate var dbMgr : DBMgr?
    fileprivate var switchAlert : UISwitch?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.init_data()
        self.init_ui()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.btnLeft?.setTitle("编辑", for: UIControlState.normal)
        self.tableView?.setEditing(false, animated: true)
        
        if ( self.tableView != nil ){
            self.restoreTableViewCell(tableView: self.tableView!)
        }
        
        if bFirst == false {
            self.arrayData = UtilHelper.getDataModel(array: (self.dbMgr?.get_table_data())!)
            self.tableView?.reloadData()
        }
        
        if bFirst {
            bFirst = false
        }
    }
    
    func init_data() -> Void
    {
        self.dbMgr = DBMgr.sharedInstance()
        self.arrayData = NSMutableArray.init(capacity: 0)
        self.arrayData = UtilHelper.getDataModel(array: (self.dbMgr?.get_table_data())!)
    }
    
    func init_ui() -> Void
    {
        self.navTitle?.text = "提醒事项"
        
        self.btnLeft?.setTitle("编辑", for: UIControlState.normal)
        self.btnRight?.setTitle("添加", for: UIControlState.normal)
        
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
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arrayData!.count;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return CGFloat(self.cellHeight);
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        return self.layoutCell(tableView: tableView, indexPath: indexPath);
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if( self.tableView?.isEditing )!{
            let deleteModel : AlertDataModel = self.arrayData?.object(at: indexPath.row) as! AlertDataModel
            let vc : EditAlertViewController = EditAlertViewController()
            vc.editAlertFlag = type_modify_alert.edit_alert.rawValue
            vc.dataModel = deleteModel
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let deleteModel : AlertDataModel = self.arrayData?.object(at: indexPath.row) as! AlertDataModel
            self.dbMgr?.del_table_data(deleteModel.noticeId as String!)
            UtilHelper.deleteNotification(id: deleteModel.noticeId as String)
            self.arrayData = UtilHelper.getDataModel(array: (self.dbMgr?.get_table_data())!)
            self.tableView?.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?
    {
        return "删除"
    }
    
    func layoutCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    {
        let id = "alertCell"
        var cell : MatterCell? = tableView.dequeueReusableCell(withIdentifier: id) as! MatterCell?
        if ( cell == nil ){
            cell = MatterCell.init(style: UITableViewCellStyle.default, reuseIdentifier: id)
        }
        
        let dataModel : AlertDataModel = self.arrayData?.object(at: indexPath.row) as! AlertDataModel
    
        cell?.labelTime?.text = dataModel.noticeTime as String
        
        cell?.labelDescribe?.text = dataModel.noticeTab as String

        cell?.switchAlert?.tag = 1000 + indexPath.row
        cell?.switchAlert?.addTarget(self, action: #selector(switchOpen(_:)), for: UIControlEvents.valueChanged)
        if dataModel.isOpen.isEqual(to: "1") {
            cell?.switchAlert?.setOn(true, animated: false)
        }
        else{
            cell?.switchAlert?.setOn(false, animated: false)
        }
        
        if ( self.tableView?.isEditing )! {
            
            UIView.animate(withDuration: 0.2, animations: {
                ()-> Void in
            
                cell?.view?.frame = CGRect(x: 30, y: 0, width: Int(screenWidth - 30), height: self.cellHeight)
                cell?.imageMore?.isHidden = false
                cell?.switchAlert?.isHidden = true;
                
            }, completion: {(finished:Bool) -> Void in
            })
        }
        else
        {
            UIView.animate(withDuration: 0.2, animations: {
                ()-> Void in
            
                cell?.view?.frame = CGRect(x: 0, y: 0, width: Int(screenWidth), height: self.cellHeight)
                cell?.imageMore?.isHidden = true
                cell?.switchAlert?.isHidden = false;
                
            }, completion: {(finished:Bool) -> Void in
                
            })
        }
    
        return cell!;
    }
    
    func restoreTableViewCell(tableView: UITableView) -> Void{
        
        var cell : MatterCell?
        for row in 0 ..< self.arrayData!.count {
            let indexPath : NSIndexPath = IndexPath.init(row: row, section: 0) as NSIndexPath;
            cell = tableView.cellForRow(at: indexPath as IndexPath) as! MatterCell?
            
            if ( cell != nil ){
                
                UIView.animate(withDuration: 0.2, animations: {
                    ()-> Void in
                    
                    cell?.view?.frame = CGRect(x: 0, y: 0, width: Int(screenWidth), height: self.cellHeight)
                    cell?.imageMore?.isHidden = true
                    cell?.switchAlert?.isHidden = false;
                    
                }, completion: {(finished:Bool) -> Void in
                    
                })
            }
        }
    }
    
    func switchOpen(_ switchAlert : UISwitch) -> Void
    {
        let index = switchAlert.tag - 1000
        let dataModel : AlertDataModel = self.arrayData?.object(at: index) as! AlertDataModel
        
        if switchAlert.isOn == true {
            dataModel.isOpen = "1"
            UtilHelper.addNotification(alertModel: dataModel)
        }
        else{
            dataModel.isOpen = "0"
            UtilHelper.deleteNotification(id: dataModel.noticeId as String)
        }
        
        self.dbMgr?.update_alert_table_data((dataModel.noticeId) as String, time: (dataModel.noticeTime) as String, repeat: (dataModel.noticeRepeat) as String, isOpen: (dataModel.isOpen) as String, tab: (dataModel.noticeTab) as String)
    }

    override func clickNavLeft() -> Void{
        
        self.tableView?.reloadData()

        if ( self.tableView?.isEditing )! {
            self.btnLeft?.setTitle("编辑", for: UIControlState.normal)
            self.tableView?.setEditing(false, animated: true)
        }
        else
        {
            if self.arrayData?.count == 0 {
                let vc : EditAlertViewController = EditAlertViewController()
                vc.editAlertFlag = type_modify_alert.add_alert.rawValue
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else {
                self.btnLeft?.setTitle("完成", for: UIControlState.normal)
                self.tableView?.setEditing(true, animated: true)
            }
        }
    }

    override func clickNavRight() -> Void{
        
        let vc : EditAlertViewController = EditAlertViewController()
        vc.editAlertFlag = type_modify_alert.add_alert.rawValue
        self.navigationController?.pushViewController(vc, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

