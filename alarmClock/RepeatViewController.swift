//
//  RepeatViewController.swift
//  alarmClock
//
//  Created by tangwei on 16/12/9.
//  Copyright © 2016年 tangwei. All rights reserved.
//

import UIKit

typealias sendValueClosure = (_ noticeRepeat: NSString) -> Void

class RepeatViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    open var noticeRepeat : NSString?
    
    fileprivate let cellHeight : NSInteger = 45
    fileprivate let headHeight : NSInteger = 35
    
    fileprivate var tableView : UITableView?
    fileprivate var arrayData : NSArray?
    fileprivate var myClosure : sendValueClosure?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.modify_NavBar()
        self.init_data()
        self.init_ui()
    }
    
    func modify_NavBar() -> Void
    {
        self.navTitle?.text = "重复"
        
        self.btnLeft?.setImage(UIImage.init(named: "navBar_back"), for: UIControlState.normal)
    }
    
    func init_data() -> Void
    {
        self.arrayData = [type_repeat_title.never.rawValue, type_repeat_title.day.rawValue, type_repeat_title.weekday.rawValue, type_repeat_title.weekdayOrdinal.rawValue, type_repeat_title.month.rawValue, type_repeat_title.year.rawValue]
    }
    
    func init_ui() -> Void
    {
        if ( self.tableView == nil ) {
            self.tableView = UITableView.init(frame: CGRect(x: 0, y: 64, width: screenWidth, height: screenHeight - 64), style: UITableViewStyle.grouped)
            self.tableView?.backgroundColor = UIColor.clear
            self.tableView?.delegate = self
            self.tableView?.dataSource = self
            self.tableView?.separatorStyle = UITableViewCellSeparatorStyle.singleLine
            self.tableView?.separatorColor = colorWithHexString(hex: "#232323")
            self.view.addSubview(self.tableView!)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (self.arrayData?.count)!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return CGFloat(self.cellHeight);
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return CGFloat(headHeight)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let view : UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: Int(screenWidth), height:headHeight))
        view.backgroundColor = colorWithHexString(hex: "#0f0f0f")
        
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
        if self.noticeRepeat?.integerValue == indexPath.row {
            return
        }

        let indexPathMark : NSIndexPath = IndexPath.init(row: (self.noticeRepeat?.integerValue)!, section: 0) as NSIndexPath;
        let cellMark : UITableViewCell = tableView.cellForRow(at: indexPathMark as IndexPath)!
        cellMark.accessoryType = UITableViewCellAccessoryType.none
        
        let indexPath : NSIndexPath = IndexPath.init(row: indexPath.row, section: 0) as NSIndexPath;
        let cellSelected : UITableViewCell = tableView.cellForRow(at: indexPath as IndexPath)!
        cellSelected.accessoryType = UITableViewCellAccessoryType.checkmark
        
        self.noticeRepeat = "\(indexPath.row)" as NSString?
    }
    
    func layoutCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    {
        let id = "RepeatCell"
        let cell : UITableViewCell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: id)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let view : UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: Int(screenWidth), height: cellHeight))
        view.backgroundColor = colorWithHexString(hex: "#161616")
        cell.addSubview(view)
        
        let labelTitle : UILabel = UILabel.init(frame: CGRect(x: Int(spacingLayoutLeft), y: 0, width: 80, height: cellHeight))
        labelTitle.font = UIFont.systemFont(ofSize: 17.0)
        labelTitle.textColor = colorWithHexString(hex: "#aeaeae")
        labelTitle.text = self.arrayData?.object(at: indexPath.row) as! String?
        view.addSubview(labelTitle)

        if self.noticeRepeat?.integerValue == indexPath.row {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        
        return cell
    }
    
    override func clickNavLeft() -> Void{
        
        if (myClosure != nil) {
            myClosure!(self.noticeRepeat!)
        }
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    func initWithClosure(closure: sendValueClosure?){
        myClosure = closure
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
