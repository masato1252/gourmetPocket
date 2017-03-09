//
//  ShareEXBookListData.swift
//  placeBook
//
//  Created by 松浦 雅人 on 2017/03/09.
//  Copyright © 2017年 松浦 雅人. All rights reserved.
//

import UIKit

class ShareEXBookListData: NSObject {
    
    var book_id:String = ""
    var title:String = ""

    
    init(book_id:String, title:String) {
        self.book_id = book_id
        self.title = title
        super.init()
    }
    
    override init(){
        
    }
    
    
}
