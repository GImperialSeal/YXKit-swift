//
//  TextFieldTableViewCell.swift
//  QianSoSo
//
//  Created by 顾玉玺 on 2017/8/24.
//  Copyright © 2017年 顾玉玺. All rights reserved.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    let textField  = UITextField()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        title.font = KMAIN_FONT(size: 15)
        textField.frame = self.bounds
        textField.font = KMAIN_FONT(size: 15)
        textField.leftView = title
        textField.setValue(10, forKey: "paddingLeft")
        textField.leftViewMode = .always
        textField.textAlignment = .right
        contentView.addSubview(textField)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
