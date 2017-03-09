//
//  UserData.swift
//  swiftavfcidetector2
//
//  Created by 松浦 雅人 on 2017/02/24.
//  Copyright © 2017年 Yoshihisa Nitta. All rights reserved.
//

import UIKit


class UserData: NSObject {
    
    var user_id:String = ""
    var sns_id:String = ""
    var sns_type:Int = 0
    var gender:Int = 0
    var name:String = ""
    var email:String = ""
    //var token:String = ""

    
    init(user_id:String, sns_id:String, sns_type:Int, gender:Int, name:String, email:String) {
        self.user_id = user_id
        self.sns_id = sns_id
        self.sns_type = sns_type
        self.gender = gender
        self.name = name
        self.email = email
        //self.token = token
        
        super.init()
    }
    
    override init(){
        
    }
    
    
    //Setter
    
    func setUserId(str:String){
        self.user_id = str
    }
    
    func setName(str:String){
        self.name = str
    }
    
    func setGender(num:Int){
        self.gender = num
    }
    
    func setSnsType(num:Int){
        self.sns_type = num
    }
    
    func setSnsId(str:String){
        self.sns_id = str
    }
    
    func setEmail(str:String){
        self.email = str
    }
    
//    func setToken(str:String){
//        self.token = str
//    }
    
    //Getter
    
    func getUserId() -> String {
        return self.user_id
    }
    
    func getName() -> String {
        return self.name
    }
    
    func getGender() -> Int {
        return self.gender
    }
    
    func getSnsType() -> Int {
        return self.sns_type
    }
    
    func getSnsId() -> String {
        return self.sns_id
    }
    
    func getEmail() -> String {
        return self.email
    }
    
//    func getToken() -> String {
//        return self.token
//    }
    
}
