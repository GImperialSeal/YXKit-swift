//
//  GBaseSettingController.swift
//  QianSoSo
//
//  Created by 顾玉玺 on 2017/8/24.
//  Copyright © 2017年 顾玉玺. All rights reserved.
//

import UIKit

class GBaseSettingController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var group: [GSettingGroup] = []
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 10
        tableView.rowHeight = 44
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
    }
    
    func g_settingItem(indexPath:IndexPath)->GSettingItem {
        let g  = group[indexPath.section]
        let item = g.items[indexPath.row]
        return item
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return group[section].items.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return group.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let g  = group[indexPath.section]
        let item = g.items[indexPath.row]
        
        switch item.type {
        case .Value1:
            var cell = tableView.dequeueReusableCell(withIdentifier: "value1")
            if cell == nil {
                cell = UITableViewCell(style: .value1, reuseIdentifier: "value1")
            }
            cell?.textLabel?.text = item.title
            cell?.detailTextLabel?.text = item.subtitle
            cell?.textLabel?.font = item.titleFont
            cell?.detailTextLabel?.font = item.subtitleFont
            cell?.textLabel?.textColor = item.titleColor
            cell?.detailTextLabel?.textColor = item.subTitleColor
            if item.showDisclosureIndicator {
                cell?.accessoryView = UIImageView(image: UIImage(named: "arrow"))
            }else{
                cell?.accessoryType = .none
            }
            return cell!
        case .Custom:
            return g_tableView(tableView:tableView,cellForRowAt:indexPath)
        case .Signout:
            var cell = tableView.dequeueReusableCell(withIdentifier: "Signout") as? GBaseSettingCell
            if cell == nil {
                cell = GBaseSettingCell(style: .value1, reuseIdentifier: "Signout")
                cell?.separatorInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
            }
            cell?.signoutLabel.text = item.title
            cell?.signoutLabel.backgroundColor = item.signoutColor
            return cell!
        case .TextField:
            var cell = tableView.dequeueReusableCell(withIdentifier: "textField") as? TextFieldTableViewCell
            if cell == nil {
                cell = TextFieldTableViewCell(style: .default, reuseIdentifier: "textField")
            }
            if item.showDisclosureIndicator {
                let temp = tableViewCell_AccessView()
                cell?.accessoryView = temp?.0
                temp?.1.addTarget(self, action: #selector(clicked_g_acessoryView(sender:)), for: .touchUpInside)
            }else{
                cell?.accessoryView = nil
            }
            
            let title = cell?.textField.leftView as! UILabel
            title.text = item.title
            title.sizeToFit()
            cell?.textField.keyboardType = item.keyType ?? .default
            cell?.textField.placeholder = item.placeholder
            cell?.textField.text = item.subtitle
            cell?.textField.limitLength = item.limitEditLength
            cell?.textField.complecionEditing = { text in
                if let op = item.finishedEdited {
                    op(text)
                    item.subtitle = text
                }
            }
            return cell!

        default:
            var cell = tableView.dequeueReusableCell(withIdentifier: "default")
            if cell == nil {
                cell = UITableViewCell(style: .value1, reuseIdentifier: "default")
            }
            cell?.textLabel?.text = item.title
            cell?.textLabel?.font = item.titleFont
            cell?.textLabel?.textColor = item.titleColor
            cell?.imageView?.image = UIImage(named: item.icon!)
            if item.showDisclosureIndicator { cell?.accessoryType = .disclosureIndicator }
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let g  = group[indexPath.section]
        let item = g.items[indexPath.row]
        if let op = item.operation {op(item,indexPath)}
    }
    
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return group[section].footer
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return group[section].heightForFooter
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return group[section].header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return group[section].heightForHeader

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let g  = group[indexPath.section]
        let item = g.items[indexPath.row]
        return item.rowHeight
    }

    // 子类实现的方法
    func tableViewCell_AccessView() -> (UIView,UIButton)?{
        return nil
    }
    
    func g_tableView(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCell(withIdentifier: "default")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "default")
        }
        return cell!
    }
    
    @objc func clicked_g_acessoryView(sender: UIButton)  {
    let indexPath = tableView.indexPath(for: getCell(sender: sender))
    let g  = group[(indexPath?.section)!]
    let item = g.items[(indexPath?.row)!]
    if let operation = item.clickedAccessoryView {operation(item,indexPath!,sender)}
    }
    
    func getCell(sender: UIView)->TextFieldTableViewCell  {
        if (sender.superview?.isKind(of: TextFieldTableViewCell.self))! {
            return sender.superview as! TextFieldTableViewCell
        }else{
            return getCell(sender: sender.superview!)
        }
    }    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
