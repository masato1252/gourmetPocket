//
//  ShareEXPostData.swift
//  placeBook
//
//  Created by 松浦 雅人 on 2017/03/10.
//  Copyright © 2017年 松浦 雅人. All rights reserved.
//

import UIKit

class ShareEXPostData: NSObject {
    
    var url:String = ""
    var user_id:String = ""
    var book_id:String = ""
    var comment:String = ""
    
    init(url:String, user_id:String, book_id:String, comment:String) {
        self.url = url
        self.user_id = user_id
        self.book_id = book_id
        self.comment = comment
        super.init()
    }
    
    override init(){
        
    }
    
    
}
