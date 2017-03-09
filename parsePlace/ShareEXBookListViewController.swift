//
//  ShareEXBookListViewController.swift
//  placeBook
//
//  Created by 松浦 雅人 on 2017/03/09.
//  Copyright © 2017年 松浦 雅人. All rights reserved.
//

import UIKit

@objc(ListViewControllerDelegate)
protocol ListViewControllerDelegate {
    @objc optional func listViewController(sender: ShareEXBookListViewController, selectedValue: String)
}

class ShareEXBookListViewController: UITableViewController {
    
    struct TableViewValues {
        static let identifier = "Cell"
    }
    
    var itemList: [String] = []
    var selectedValue: String = ""
    
    let suiteName: String = "group.jp.vex.placeBook"
    
    var bookArray:[ShareEXBookListData] = [ShareEXBookListData]()
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: TableViewValues.identifier)
        tableView.backgroundColor = UIColor.clear
        
        self.itemList = ["未分類"]
    }
    
    //ブックリスト取得後にコールされる
    func getBookList(array:[ShareEXBookListData]){
        self.bookArray = array
        
        self.itemList.removeAll()
        for tmp in self.bookArray {
            self.itemList.append(tmp.title)
        }
        
        //self.itemList = ["未分類","AAAA","BBBB"]
        //self.tableView.reloadData()
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let sharedDefaults: UserDefaults = UserDefaults(suiteName: self.suiteName)!
        if let user_id = sharedDefaults.object(forKey: "user_id") as? String {

            let apiCon:ShareEXAPIConnector = ShareEXAPIConnector(activity:self, type:1, object: user_id)
            apiCon.execute()
            
            self.itemList = ["未分類","AAAA"]
            self.tableView.reloadData()
        }else{

        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath:IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewValues.identifier, for: indexPath) as UITableViewCell
        cell.backgroundColor = UIColor.clear
        
        let text: String = self.itemList[indexPath.row]
        
        // 選択したアイテムにチェックマークをつける
        if text == selectedValue {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        cell.textLabel!.text = text
        
        return cell
    }
    
    
    var delegate: ListViewControllerDelegate?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let theDelegate = delegate {
            theDelegate.listViewController!(sender: self, selectedValue: self.itemList[indexPath.row])
        }
    }

}
