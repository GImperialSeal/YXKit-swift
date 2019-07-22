//
//  GBaseSettingCell.swift
//  QianSoSo
//
//  Created by 顾玉玺 on 2017/8/24.
//  Copyright © 2017年 顾玉玺. All rights reserved.
//

import UIKit

class GBaseSettingCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    let signoutLabel = UILabel(frame: CGRect(x: 20, y: 0, width:KW-40 , height: 44))
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        selectionStyle = .none
        signoutLabel.textColor = UIColor.white
        signoutLabel.font = KMAIN_FONT(size: 18)
        signoutLabel.layer.masksToBounds = true
        signoutLabel.layer.cornerRadius = 4
        signoutLabel.textAlignment = .center
        contentView.addSubview(signoutLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addSubview(_ view: UIView) {
        
        let b = view.isKind(of: NSClassFromString("UIButton")!)
        let t = view.isKind(of: NSClassFromString("UITableViewCellContentView")!)
        if !b && !t{
            return
        }
        super.addSubview(view)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
