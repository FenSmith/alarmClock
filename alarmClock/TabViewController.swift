//
//  TabViewController.swift
//  alarmClock
//
//  Created by tangwei on 16/12/9.
//  Copyright © 2016年 tangwei. All rights reserved.
//

import UIKit

typealias sendTabValueClosure = (_ noticeTab: NSString) -> Void

class TabViewController: BaseViewController {
    
    open var noticeTab : NSString?
    
    fileprivate var textfield : UITextField?
    fileprivate var myClosure : sendTabValueClosure?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.modify_NavBar()
        self.init_ui()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.textfield != nil {
            self.textfield?.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.textfield != nil {
            self.textfield?.resignFirstResponder()
        }
    }
    
    func modify_NavBar() -> Void
    {
        self.navTitle?.text = "标签"
        
        self.btnLeft?.setImage(UIImage.init(named: "navBar_back"), for: UIControlState.normal)
    }
    
    func init_ui() -> Void
    {
        let scrollView : UIScrollView = UIScrollView.init(frame: CGRect(x: 0, y: 64, width: screenWidth, height: screenHeight - 64))
        scrollView.backgroundColor = UIColor.clear
        self.view.addSubview(scrollView)
        
        let view : UIView = UIView.init(frame: CGRect(x: 0, y: (screenHeight - 64 - 46) / 2 - 50, width: screenWidth, height: 46))
        view.backgroundColor = colorWithHexString(hex: "#161616")
        scrollView.addSubview(view)
        
        let viewTop : UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 0.5))
        viewTop.backgroundColor = colorWithHexString(hex: "#232323")
        view.addSubview(viewTop)
        
        let viewBottom : UIView = UIView.init(frame: CGRect(x: 0, y: 45.5, width: screenWidth, height: 0.5))
        viewBottom.backgroundColor = colorWithHexString(hex: "#232323")
        view.addSubview(viewBottom)
        
        self.textfield = UITextField.init(frame: CGRect(x: 10, y: 1, width: screenWidth - 20, height: 45))
        self.textfield?.textColor = UIColor.white
        self.textfield?.backgroundColor = UIColor.clear
        self.textfield?.clearButtonMode = UITextFieldViewMode.whileEditing
        self.textfield?.font = UIFont.systemFont(ofSize: 16.0)
        self.textfield?.text = self.noticeTab as String?
        view.addSubview(self.textfield!)
    }
    
    override func clickNavLeft() -> Void{
        
        if (myClosure != nil) {
            myClosure!(self.textfield!.text! as NSString)
        }
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    func initWithClosure(closure: sendTabValueClosure?){
        myClosure = closure
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
}
