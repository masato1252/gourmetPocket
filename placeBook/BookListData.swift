//
//  BookListData.swift
//  placeBook
//
//  Created by 松浦 雅人 on 2017/03/08.
//  Copyright © 2017年 松浦 雅人. All rights reserved.
//

import UIKit

class BookListData: NSObject {

    var book_id:String = ""
    var title:String = ""
    var shareUserName:String = ""
    var shareUserId:String = ""
    var placeNum:Int = 0
    
    init(book_id:String, title:String, shareUserName:String, shareUserId:String, placeNum:Int) {
        self.book_id = book_id
        self.title = title
        self.shareUserName = shareUserName
        self.shareUserId = shareUserId
        self.placeNum = placeNum
        
        super.init()
    }
    
    override init(){
        
    }


}
