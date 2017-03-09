//
//  BookCustomCell.swift
//  placeBook
//
//  Created by 松浦 雅人 on 2017/03/08.
//  Copyright © 2017年 松浦 雅人. All rights reserved.
//

import UIKit

class BookCustomCell: UITableViewCell {
    
    
    @IBOutlet weak var label_title: UILabel!
    
    @IBOutlet weak var label_shareUser: UILabel!
    
    @IBOutlet weak var label_num: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCell(book:BookListData, index :Int) {
        
        self.label_title.text = book.title
        if(book.shareUserName.isEmpty){
            self.label_shareUser.text = ""
        }else{
            self.label_shareUser.text = "\(book.shareUserName)さんとシェア"
        }
        self.label_num.text = "\(book.placeNum)件"
        
        //        //背景色設定
        //        if(index%2==0){
        //            self.backgroundColor = UIColor(hexString: "#F5F5F5")
        //        }else{
        //            self.backgroundColor = UIColor(hexString: "#F5FFFA")
        //        }
        //
        //        //レイアウト設定
        //        self.label_equation.translatesAutoresizingMaskIntoConstraints = true
        //        self.label_equation.frame = CGRect(x:10, y:5, width:Int(DeviceSize.screenWidth())-20, height:Int(self.frame.size.height)-10)
    }
    
}

