//
//  APIConnector.swift
//  swiftavfcidetector2
//
//  Created by 松浦 雅人 on 2017/02/24.
//  Copyright © 2017年 Yoshihisa Nitta. All rights reserved.
//

import UIKit


class APIConnector : NSObject {
    
    var type:Int = 0 //シーン選択
    var object:Any //POSTするデータ
    
    var activity:UIViewController
    var indicator = UIActivityIndicatorView()
    var group = DispatchGroup()
    
    var resultState:Int = -1
    
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var bookArray:[BookListData] = [BookListData]()
    var placeArray:[PlaceListData] = [PlaceListData]()
    var placeInfo:PlaceData = PlaceData()
    
    init(activity: UIViewController, type: Int, object: Any){
        //親アクティビティのインスタンス保持 => グルグル表示
        self.activity = activity
        self.type = type
        self.object = object
        
        super.init()
    }
    
    
    //実行する関数（APIへアクセス＆配列へ格納）
    func execute(){
        
        
        //1回APIを叩く
        //        for i in 0..<countryArray.count {
        //            group.enter()
        //            DispatchQueue.global().async {
        //                self.getRateArray(num: i)
        //            }
        //        }
        
        if(self.type==0){
            return
            
        }else if(self.type==1){
            //会員登録
            
            //処理中のグルグルを表示
            showIndicator()
            //ディスパッチエントリー
            group.enter()
            //非同期通信
            DispatchQueue.global().async {
                self.postUserRegist()
            }
            //非同期処理完了
            group.notify(queue: .global()) {
                print("データ取得完了")
                DispatchQueue.main.async {
                    //let uivc:EnrollViewController = self.activity as! EnrollViewController
                    //uivc.reDicision() //ステータス再判定
                    self.endIndicator()
                }
            }
            
        }else if(self.type==2){
            //マイブック取得
            
            //処理中のグルグルを表示
            showIndicator()
            //ディスパッチエントリー
            group.enter()
            //非同期通信
            DispatchQueue.global().async {
                self.getBookList()
            }
            //非同期処理完了
            group.notify(queue: .global()) {
                print("データ取得完了")
                DispatchQueue.main.async {
                    //let uivc:EnrollViewController = self.activity as! EnrollViewController
                    //uivc.reDicision() //ステータス再判定
                    self.endIndicator()
                }
            }
            
        }else if(self.type==3){
            //マイブック新規作成
            
            //処理中のグルグルを表示
            showIndicator()
            //ディスパッチエントリー
            group.enter()
            //非同期通信
            DispatchQueue.global().async {
                self.makeNewBook()
            }
            //非同期処理完了
            group.notify(queue: .global()) {
                print("データ取得完了")
                DispatchQueue.main.async {
                    //let uivc:EnrollViewController = self.activity as! EnrollViewController
                    //uivc.reDicision() //ステータス再判定
                    self.endIndicator()
                }
            }
        }else if(self.type==4 || self.type==5){
            //店舗リスト取得
            
            //処理中のグルグルを表示
            showIndicator()
            //ディスパッチエントリー
            group.enter()
            //非同期通信
            DispatchQueue.global().async {
                self.getPlaceList()
            }
            //非同期処理完了
            group.notify(queue: .global()) {
                print("データ取得完了")
                DispatchQueue.main.async {
                    //let uivc:EnrollViewController = self.activity as! EnrollViewController
                    //uivc.reDicision() //ステータス再判定
                    self.endIndicator()
                }
            }
            
        }else if(self.type==6){
            //店舗詳細取得
            
            //処理中のグルグルを表示
            showIndicator()
            //ディスパッチエントリー
            group.enter()
            //非同期通信
            DispatchQueue.global().async {
                self.getPlaceInfo()
            }
            //非同期処理完了
            group.notify(queue: .global()) {
                print("データ取得完了")
                DispatchQueue.main.async {
                    //let uivc:EnrollViewController = self.activity as! EnrollViewController
                    //uivc.reDicision() //ステータス再判定
                    self.endIndicator()
                }
            }
        }

            
        

        
    }
    
    
    //会員登録
    func postUserRegist(){
        
        let baseUrl:String = "http://concierge-apps.lovepop.jp/place/user/regist_user.php"
        var request = URLRequest(url: URL(string:baseUrl)!)
        
        let userData:UserData = self.object as! UserData

        // set the method(HTTP-POST)
        request.httpMethod = "POST"
        
        var query = ""
        if(userData.getSnsType()==1){
            //FB
            query = "sns_type=\(userData.getSnsType())&" +
                    "sns_id=\(userData.getSnsId())&" +
                    "name=\(userData.getName())&" +
                    "email=\(userData.getEmail())&" +
                    "gender=\(userData.getGender())"
            
        }else if(userData.getSnsType()==2){
            //Twitter
            query = "sns_type=\(userData.getSnsType())&" +
                "sns_id=\(userData.getSnsId())&" +
                "name=\(userData.getName())"
            
        }
        request.httpBody = query.data(using: String.Encoding.utf8)

        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if error != nil {
                
                print(error!.localizedDescription)
            } else {
                
                do {
    
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:String]

                    print(parsedData)

                    if(parsedData["result"] == "1" || parsedData["result"] == "2"){
                        //会員登録成功
                        self.resultState = 1
                        //会員IDを本体に保存
                        Config.sharedInstance.loginComplete(user_id: parsedData["user_id"]!, sns_type: userData.getSnsType(), sns_id: userData.getSnsId())
                        
                    }else{
                        //エラー
                        self.resultState = -1
                    }
                    
                    self.group.leave()
                } catch {
                    //エラー処理
                    self.resultState = -1
                    self.group.leave()
                }
            }
            
        })
        
        task.resume()
    }
    
    
    
    
    //グルグル生成＆表示
    func showIndicator() {
        
        // UIActivityIndicatorView のスタイルをテンプレートから選択
        indicator.activityIndicatorViewStyle = .whiteLarge
        // 表示位置
        indicator.center = activity.view.center
        // 色の設定
        indicator.color = UIColor.green
        // アニメーション停止と同時に隠す設定
        indicator.hidesWhenStopped = true
        // 画面に追加
        activity.view.addSubview(indicator)
        // 最前面に移動
        activity.view.bringSubview(toFront: indicator)
        // アニメーション開始
        indicator.startAnimating()
        
    }
    
    //マイブック取得
    func getBookList(){
        
        let baseUrl:String = "http://concierge-apps.lovepop.jp/place/book/get_bookList.php"
        var request = URLRequest(url: URL(string:baseUrl)!)
        
        let user_id:String = self.object as! String
        
        // set the method(HTTP-POST)
        request.httpMethod = "POST"
        
        let query = "user_id=\(user_id)"
        request.httpBody = query.data(using: String.Encoding.utf8)
        
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if error != nil {
                
                print(error!.localizedDescription)
            } else {
                
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [[String:String]]
                    
                    print(parsedData)
                    
                    if(parsedData[0]["result"] == "1"){
                        //成功
                        self.resultState = 1
                        
                        for i in 1 ..< parsedData.count {
                            
                            let book:BookListData = BookListData()
                            book.title = parsedData[i]["name"]!
                            book.book_id = parsedData[i]["book_id"]!
                            book.placeNum = Int(parsedData[i]["placeNum"]!)!
                            self.bookArray.append(book)
                        }
                        
                        
                    }else{
                        //エラー
                        self.resultState = -1
                    }
                    
                    self.group.leave()
                } catch {
                    //エラー処理
                    self.resultState = -1
                    self.group.leave()
                }
            }
            
        })
        
        task.resume()
    }

    
    //マイブック新規作成
    func makeNewBook(){
        
        let baseUrl:String = "http://concierge-apps.lovepop.jp/place/book/set_newBook.php"
        var request = URLRequest(url: URL(string:baseUrl)!)
        
        let postData:[String:String] = self.object as! [String:String]
        
        // set the method(HTTP-POST)
        request.httpMethod = "POST"
        
        let query = "user_id=\(postData["user_id"]!)&" +
                    "title=\(postData["title"]!)"
        
        request.httpBody = query.data(using: String.Encoding.utf8)
        
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if error != nil {
                
                print(error!.localizedDescription)
            } else {
                
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:String]
                    
                    print(parsedData)
                    
                    if(parsedData["result"] == "1"){
                        //成功
                        self.resultState = 1
                        
                    }else{
                        //エラー
                        self.resultState = -1
                    }
                    
                    self.group.leave()
                } catch {
                    //エラー処理
                    self.resultState = -1
                    self.group.leave()
                }
            }
            
        })
        
        task.resume()
    }

    
    //店舗取得
    func getPlaceList(){
        
        let baseUrl:String = "http://concierge-apps.lovepop.jp/place/place/get_placeList.php"
        var request = URLRequest(url: URL(string:baseUrl)!)
        
        let postData:[String:String] = self.object as! [String:String]
        
        // set the method(HTTP-POST)
        request.httpMethod = "POST"
        
        var query:String = ""
        if(self.type==4){
            //全件
            query = "user_id=\(postData["user_id"]!)&" +
                    "type=\(self.type)"
        }else if(self.type==5){
            //特定のブック
            query = "user_id=\(postData["user_id"]!)&" +
                    "book_id=\(postData["book_id"]!)&" +
                    "type=\(self.type)"
        }
        request.httpBody = query.data(using: String.Encoding.utf8)
        
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if error != nil {
                
                print(error!.localizedDescription)
            } else {
                
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [[String:String]]
                    
                    print(parsedData)
                    
                    if(parsedData[0]["result"] == "1"){
                        //成功
                        self.resultState = 1
                        
                        for i in 1 ..< parsedData.count {
                            
                            let place:PlaceListData = PlaceListData()
                            place.place_id = parsedData[i]["place_id"]!
                            place.site_id = parsedData[i]["site_id"]!
                            place.site_type = Int(parsedData[i]["site_type"]!)!
                            place.name = parsedData[i]["name"]!
                            place.area = parsedData[i]["area"]!
                            place.station = parsedData[i]["station"]!
                            place.comment = parsedData[i]["comment"]!
                            place.img = UIImage(named: "noimage.png")!
                            self.placeArray.append(place)
                        }
                        
                        
                    }else{
                        //エラー
                        self.resultState = -1
                    }
                    
                    self.group.leave()
                } catch {
                    //エラー処理
                    self.resultState = -1
                    self.group.leave()
                }
            }
            
        })
        
        task.resume()
    }

    
    //店舗情報取得
    func getPlaceInfo(){
        
        let baseUrl:String = "http://concierge-apps.lovepop.jp/place/place/get_placeInfo.php"
        var request = URLRequest(url: URL(string:baseUrl)!)
        
        let postData:[String:String] = self.object as! [String:String]
        
        // set the method(HTTP-POST)
        request.httpMethod = "POST"
        
        let query = "user_id=\(postData["user_id"]!)&" +
                    "place_id=\(postData["place_id"]!)"

        request.httpBody = query.data(using: String.Encoding.utf8)
        
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if error != nil {
                
                print(error!.localizedDescription)
            } else {
                
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:String]
                    
                    print(parsedData)
                    
                    if(parsedData["result"] == "1"){
                        //成功
                        self.resultState = 1
                        
                        self.placeInfo.place_id = parsedData["place_id"]!
                        self.placeInfo.site_id = parsedData["site_id"]!
                        self.placeInfo.site_type = Int(parsedData["site_type"]!)!
                        self.placeInfo.name = parsedData["name"]!
                        self.placeInfo.area = parsedData["area"]!
                        self.placeInfo.station = parsedData["station"]!
                        self.placeInfo.address = parsedData["address"]!
                        self.placeInfo.cat = parsedData["cat"]!
                        self.placeInfo.open_time = parsedData["open_time"]!
                        
                        
                    }else{
                        //エラー
                        self.resultState = -1
                    }
                    
                    self.group.leave()
                } catch {
                    //エラー処理
                    self.resultState = -1
                    self.group.leave()
                }
            }
            
        })
        
        task.resume()
    }


    
    func endIndicator() {
        
        if(self.type==1){
            self.indicator.stopAnimating()
            
            if(self.resultState==1){
                //成功
                let alert = UIAlertController(
                    title: "成功",
                    message: "ログインが完了しました。",
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                activity.present(alert, animated: true, completion: {
                
                    //コールバック
                    let vc = self.activity as! ViewController
                    vc.completeLogin()
                })
                
            }else{
                //失敗
                let alert = UIAlertController(
                    title: "通信エラー",
                    message: "再度お試しください。",
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                activity.present(alert, animated: true, completion: nil)
            }
            
        }else if(self.type==2){
            self.indicator.stopAnimating()
            
            if(self.resultState==1){
                //成功

                //コールバック
                let vc = self.activity as! MyBookListViewController
                vc.getBookList(array: self.bookArray)
                
            }else{
                //失敗
                let alert = UIAlertController(
                    title: "通信エラー",
                    message: "再度お試しください。",
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                activity.present(alert, animated: true, completion: nil)
            }
            
        }else if(self.type==3){
            self.indicator.stopAnimating()
            
            if(self.resultState==1){
                //成功

                //コールバック
                let vc = self.activity as! MyBookListViewController
                vc.completeMakeBook()
                
            }else{
                //失敗
                let alert = UIAlertController(
                    title: "通信エラー",
                    message: "再度お試しください。",
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                activity.present(alert, animated: true, completion: nil)
            }
            
        }else if(self.type==4 || self.type==5){
            self.indicator.stopAnimating()
            
            if(self.resultState==1){
                //成功
                
                //コールバック
                if(self.type==4){
                    let vc = self.activity as! PlaceListViewController
                    vc.getPlaceList(array:self.placeArray)
                }else if(self.type==5){
                    let vc = self.activity as! DetailBookViewController
                    vc.getPlaceList(array:self.placeArray)
                }
                
            }else{
                //失敗
                let alert = UIAlertController(
                    title: "通信エラー",
                    message: "再度お試しください。",
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                activity.present(alert, animated: true, completion: nil)
            }
            
        }else if(self.type==6){
            self.indicator.stopAnimating()
            
            if(self.resultState==1){
                //成功
                
                //コールバック
                let vc = self.activity as! DetailPlaceViewController
                vc.getPlaceInfo(data:self.placeInfo)
                
            }else{
                //失敗
                let alert = UIAlertController(
                    title: "通信エラー",
                    message: "再度お試しください。",
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                activity.present(alert, animated: true, completion: nil)
            }

        }

        
    }
    
    
}
