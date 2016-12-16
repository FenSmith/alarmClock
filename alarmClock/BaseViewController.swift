//
//  BaseViewController.swift
//  alarmClock
//
//  Created by tangwei on 16/12/8.
//  Copyright © 2016年 tangwei. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    open var btnLeft : UIButton?
    open var btnRight : UIButton?
    open var navTitle : UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = colorWithHexString(hex: "#0f0f0f")
        self.navigationController?.navigationBar.isHidden = true
        
        self.init_NavBar()
    }
    
    func init_NavBar() -> Void
    {
        let navBarView : UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 64))
        navBarView.backgroundColor = colorWithHexString(hex: "#171717")
        self.view.addSubview(navBarView)
        
        if ( self.btnLeft == nil ){
            self.btnLeft = UIButton.init(frame: CGRect(x: 5, y: 20, width: 60, height: 44))
            self.btnLeft?.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
            self.btnLeft?.setTitleColor(UIColor.orange, for: UIControlState.normal)
            self.btnLeft?.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 25)
            self.btnLeft?.addTarget(self, action: #selector(clickLeft(_:)), for: UIControlEvents.touchUpInside)
            self.view.addSubview(self.btnLeft!)
        }
        
        if ( self.navTitle == nil ){
            self.navTitle = UILabel.init(frame: CGRect(x: 75, y: 20, width: screenWidth - 150, height: 44))
            self.navTitle?.textAlignment = NSTextAlignment.center
            self.navTitle?.textColor = UIColor.white
            self.navTitle?.font = UIFont.systemFont(ofSize: 19.0, weight: UIFontWeightLight)
            self.view.addSubview(self.navTitle!)
        }
        
        if ( self.btnRight == nil ){
            self.btnRight = UIButton.init(frame: CGRect(x: screenWidth - 65, y: 20, width: 60, height: 44))
            self.btnRight?.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
            self.btnRight?.setTitleColor(UIColor.orange, for: UIControlState.normal)
            self.btnRight?.addTarget(self, action: #selector(clickRight(_:)), for: UIControlEvents.touchUpInside)
            self.view.addSubview(self.btnRight!)
        }
        
        let line : UIView = UIView.init(frame: CGRect(x: 0, y: 63.5, width: screenWidth, height: 0.5))
        line.backgroundColor = colorWithHexString(hex: "#232323")
        self.view.addSubview(line)
    }
    
    func clickLeft(_ button : UIButton) -> Void
    {
        self.clickNavLeft()
    }
    
    open func clickNavLeft() -> Void{
        
    }
    
    func clickRight(_ button : UIButton) -> Void
    {
        self.clickNavRight()
    }
    
    open func clickNavRight() -> Void{
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}
