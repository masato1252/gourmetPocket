//
//  ViewController.swift
//  placeBook
//
//  Created by 松浦 雅人 on 2017/03/06.
//  Copyright © 2017年 松浦 雅人. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import TwitterKit


class ViewController: UIViewController {

    @IBAction func btn_FBlogin(_ sender: Any) {
        LoginManager().logIn([.email], viewController: self, completion: {
            result in
            switch result {
            case let .success( permission, declinePemisson, token):
                //FB Outh認証完了時
                print("token:\(token),\(permission),\(declinePemisson)")
                self.getFBUserInfo()
                
            case let .failed(error):
                print("error:\(error)")
                self.showErrorDialog()
                
            case .cancelled:
                print("cancelled")
                self.showErrorDialog()
            }
            
        })
    }
    
    //Facebookのユーザー情報取得
    func getFBUserInfo (){
        
        GraphRequest(graphPath: "me", parameters: ["fields": "name, email, gender, locale"], accessToken: AccessToken.current, httpMethod: .GET, apiVersion: GraphAPIVersion.defaultVersion).start({
            response, result in
            switch result {
            case .success(let response) :
                print("response:\(response)")
                print("id:\(response.dictionaryValue!["id"]!) name:\(response.dictionaryValue!["name"]!)")
                
                let userData = UserData()
                userData.setSnsType(num: 1)
                userData.setName(str: response.dictionaryValue!["name"]! as! String)
                userData.setEmail(str: response.dictionaryValue!["email"]! as! String)
                userData.setSnsId(str: response.dictionaryValue!["id"]! as! String)
                let gender:String = response.dictionaryValue!["gender"]! as! String
                if(gender == "male"){
                    userData.setGender(num: 1)
                }else{
                    userData.setGender(num: 2)
                }
                LoginManager().logOut()
                
                //会員登録API
                let apiCon:APIConnector = APIConnector(activity:self, type:1, object: userData)
                apiCon.execute()
                
                break
            case .failed(let error):
                print("error:\(error.localizedDescription)")
                self.showErrorDialog()
            }
            
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Twitterログイン
        let logInButton = TWTRLogInButton { (session, error) in
            if let unwrappedSession = session {
                //Twitterログイン成功時
                
                let userData = UserData()
                userData.setSnsType(num: 2)
                userData.setName(str: unwrappedSession.userName)
                userData.setSnsId(str: unwrappedSession.userID)

                //会員登録API
                let apiCon:APIConnector = APIConnector(activity:self, type:1, object: userData)
                apiCon.execute()
                
            } else {
                self.showErrorDialog()
            }
        }
        
        // TODO: Change where the log in button is positioned in your view
        if let button:TWTRLogInButton = logInButton {
            button.center = self.view.center
            self.view.addSubview(button)
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        //SNSログイン済みかどうか判定
        if(Config.sharedInstance.isLogin()){
            //ログイン済み => メインメニューへ画面遷移
            let storyboard: UIStoryboard = self.storyboard!
            let nextView = storyboard.instantiateViewController(withIdentifier: "MainViewController")
            present(nextView, animated: true, completion: nil)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //会員登録Orログイン完了時にコール(From APIConnector)
    func completeLogin(){
        //メインメニューへ画面遷移
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "MainViewController")
        present(nextView, animated: true, completion: nil)
    }

    
    //ログイン失敗時のダイアログ表示
    internal func showErrorDialog(){

        let alert = UIAlertController(title: "ログイン失敗",
                                      message: "もう一度お試しください。",
                                      preferredStyle: UIAlertControllerStyle.alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}

