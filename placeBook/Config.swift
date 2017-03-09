//
//  Config.swift
//  placeBook
//
//  Created by 松浦 雅人 on 2017/02/24.
//  Copyright © 2017年 Yoshihisa Nitta. All rights reserved.
//

import Foundation


class Config :NSObject {
    
    //シングルトン化
    static let sharedInstance = Config()
    
    var userDefaults = UserDefaults.standard
    
    //ShareExtension用
    var exDefaults: UserDefaults = UserDefaults(suiteName: "group.jp.vex.placeBook")!

    var sns_type:Int = 0
    var sns_id:String = ""
    var user_id:String = ""
    
    
    
    private override init() {
        
    }
    
    //ログイン済みか判定(必ず実行すること)
    func isLogin() -> Bool {
        
        if (userDefaults.object(forKey: "sns_id") == nil) {
            print("Login Not Yet")
            return false
        }else{
            self.user_id = userDefaults.string(forKey: "user_id")!
            self.sns_type = userDefaults.integer(forKey: "sns_type")
            self.sns_id = userDefaults.string(forKey: "sns_id")!
            print(self.sns_id)
            return true
        }
    }
    
    //ログイン完了時に呼び出し
    func loginComplete(user_id:String, sns_type:Int, sns_id:String){
        self.user_id = user_id
        self.sns_type = sns_type
        self.sns_id = sns_id
        syncroData()
    }
    
    //データを本体に保存
    func syncroData() {

        userDefaults.set(self.user_id, forKey: "user_id")
        userDefaults.set(self.sns_type, forKey: "sns_type")
        userDefaults.set(self.sns_id, forKey: "sns_id")
        userDefaults.synchronize()
        
        exDefaults.set(self.user_id, forKey: "user_id")
        exDefaults.synchronize()
    }

    //リセット
    func resetLoginInfo() {
        
        self.sns_type = 0
        self.sns_id = ""
        self.user_id = ""
        userDefaults.removeObject(forKey: "user_id")
        userDefaults.removeObject(forKey: "sns_type")
        userDefaults.removeObject(forKey: "sns_id")
        userDefaults.synchronize()
        
        exDefaults.removeObject(forKey: "user_id")
        exDefaults.synchronize()
    }

}
