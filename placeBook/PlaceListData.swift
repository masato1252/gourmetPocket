//
//  PlaceListData.swift
//  placeBook
//
//  Created by 松浦 雅人 on 2017/03/08.
//  Copyright © 2017年 松浦 雅人. All rights reserved.
//

import UIKit

class PlaceListData: NSObject {

    var place_id:String = ""
    var site_type:Int = 0
    var site_id:String = ""
    var name:String = ""
    var area:String = ""
    var station:String = ""
    var comment:String = ""
    var img:UIImage? = nil
    
    init(place_id:String, site_type:Int, site_id:String, name:String, area:String, station:String, comment:String, img:UIImage?) {
        self.place_id = place_id
        self.site_type = site_type
        self.site_id = site_id
        self.name = name
        self.area = area
        self.station = station
        self.comment = comment
        self.img = img
        
        super.init()
    }
    
    override init(){
        
    }
    
    
    
}
