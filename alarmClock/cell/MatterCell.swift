//
//  MatterCell.swift
//  alarmClock
//
//  Created by tangwei on 16/12/15.
//  Copyright © 2016年 tangwei. All rights reserved.
//

import UIKit

class MatterCell: UITableViewCell {
    
    open var view : UIView?
    open var labelTime : UILabel?
    open var labelDescribe : UILabel?
    open var switchAlert : UISwitch?
    open var imageMore : UIImageView?
    
    fileprivate let cellHeight : NSInteger = 90

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: screenWidth, height: CGFloat(cellHeight))
        self.layout()
    }
    
    func layout() -> Void{
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.backgroundColor = colorWithHexString(hex: "#161616")
        
        self.view = UIView.init(frame: CGRect(x: 0, y: 0, width: Int(screenWidth), height: Int(cellHeight)))
        self.view?.backgroundColor = UIColor.clear
        self.addSubview(self.view!)
        
        self.labelTime = UILabel.init(frame: CGRect(x: Int(spacingLayoutLeft), y: 6, width: Int(screenWidth - 70) - Int(spacingLayoutLeft), height: 60))
        self.labelTime?.font = UIFont.systemFont(ofSize: 24.0, weight: UIFontWeightThin)
        self.labelTime?.textColor = UIColor.white
        view?.addSubview(self.labelTime!)
        
        self.labelDescribe = UILabel.init(frame: CGRect(x: Int(spacingLayoutLeft), y: 60, width: Int(screenWidth) - Int(spacingLayoutLeft), height: 17))
        self.labelDescribe?.font = UIFont.systemFont(ofSize: 15.0, weight: UIFontWeightThin)
        self.labelDescribe?.numberOfLines = 1
        self.labelDescribe?.textColor = UIColor.lightGray
        view?.addSubview(self.labelDescribe!)
        
        self.switchAlert = UISwitch.init(frame: CGRect(x: Int(screenWidth - 62), y: 30, width: 50, height: Int(self.frame.size.height)))
        self.switchAlert?.backgroundColor = UIColor.clear
        self.switchAlert?.transform = CGAffineTransform.init(scaleX: 0.9, y: 0.8)
        view?.addSubview(self.switchAlert!)
        
        self.imageMore = UIImageView.init(frame: CGRect(x: Int(screenWidth - 22), y: Int(cellHeight / 2 - 5), width: 6, height: 9))
        self.imageMore?.image = UIImage.init(named: "more")
        self.addSubview(self.imageMore!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
