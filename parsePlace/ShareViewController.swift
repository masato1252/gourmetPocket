//
//  ShareViewController.swift
//  parsePlace
//
//  Created by 松浦 雅人 on 2017/03/07.
//  Copyright © 2017年 松浦 雅人. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices

class ShareViewController: SLComposeServiceViewController, ListViewControllerDelegate {

    let suiteName: String = "group.jp.vex.placeBook"
    
    var loginFlag:Bool = true
    var bookArray:[ShareEXBookListData] = [ShareEXBookListData]()
    
    var indicator = UIActivityIndicatorView()
    
    lazy var bookItem: SLComposeSheetConfigurationItem = {
        let item = SLComposeSheetConfigurationItem()
        item?.title = "追加先ブック"
        item?.value = "未分類"
        item?.tapHandler = self.showListViewControllerOfBook
        return item!
    }()
    
    //ブックリスト取得後にコールされる
    func getBookList(array:[ShareEXBookListData]){
        self.bookArray = array
        
        //self.itemList.removeAll()
        for tmp in self.bookArray {
          //  self.itemList.append(tmp.title)
        }
        
        //self.itemList = ["未分類","AAAA","BBBB"]
        //self.tableView.reloadData()
        //self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    
    func showListViewControllerOfBook() {
        let controller = ShareEXBookListViewController(style: .plain)
        controller.selectedValue = bookItem.value
        controller.delegate  = self
        pushConfigurationViewController(controller)
    }
    
    func listViewController(sender: ShareEXBookListViewController, selectedValue: String) {
        bookItem.value = selectedValue
        popConfigurationViewController()
    }
    
    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return self.loginFlag
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //SNSログイン有無チェック
        let sharedDefaults: UserDefaults = UserDefaults(suiteName: self.suiteName)!
        if let user_id = sharedDefaults.object(forKey: "user_id") as? String {

            loginFlag = true
            
        }else{
            
            loginFlag = false
            
            let alert = UIAlertController(
                title: "SNSログインなし",
                message: "グルメポケットアプリより、SNSログイン実施後に登録可能となります。",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: {
            })
            
        }
        
        self.title = "グルメポケット登録"
        let c: UIViewController = self.navigationController!.viewControllers[0]
        c.navigationItem.rightBarButtonItem!.title = "登録"
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        //self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
        
        let inputItem = self.extensionContext!.inputItems.first as! NSExtensionItem
        let itemProvider = inputItem.attachments![0] as! NSItemProvider
        let outputItem:NSExtensionItem = inputItem.copy() as! NSExtensionItem
        
        if (itemProvider.hasItemConformingToTypeIdentifier("public.url")) {
            itemProvider.loadItem(forTypeIdentifier: "public.url", options: nil, completionHandler: { (urlItem, error) in
                
                let url = urlItem as! NSURL;
                // 取得したURLを表示
                print("\(url.absoluteString!)")
                
                let apiCon:ShareEXAPIConnector = ShareEXAPIConnector(activity:self, type:1, object: "")
                apiCon.execute()
                outputItem.attributedContentText = NSAttributedString(string:self.contentText, attributes:nil);
                
                self.getBookList()
                
                self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
                
            })
        }
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        //return [bookItem]
        return []
    }

    
    
    func getBookList(){
        
        self.showIndicator()
        
        let configName = "jp.co.vex.placeBook.BackgroundSessionConfig"
        let sessionConfig = URLSessionConfiguration.background(withIdentifier: configName)
        // Extensions aren't allowed their own cache disk space. Need to share with application
        sessionConfig.sharedContainerIdentifier = "group.jp.vex.placeBook"
        let session = URLSession(configuration: sessionConfig)
        
        
        let baseUrl:String = "http://concierge-apps.lovepop.jp/place/ex/set_newPlace.php"
        var request = URLRequest(url: URL(string:baseUrl)!)
        
        //let user_id:String = self.object as! String
        
        // set the method(HTTP-POST)
        request.httpMethod = "POST"
        
        let query = "user_id="
        request.httpBody = query.data(using: String.Encoding.utf8)
        
        
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            if error != nil {
                
                print(error!.localizedDescription)
            } else {
                
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [[String:String]]
                    
                    print(parsedData)
                    
                    if(parsedData[0]["result"] == "1"){
                        //成功
                        //self.resultState = 1
                        
                        let book:ShareEXBookListData = ShareEXBookListData()
                        book.title = "未分類"
                        book.book_id = "0"
                        self.bookArray.append(book)
                        for i in 1 ..< parsedData.count {
                            
                            let book:ShareEXBookListData = ShareEXBookListData()
                            book.title = parsedData[i]["name"]!
                            book.book_id = parsedData[i]["book_id"]!
                            self.bookArray.append(book)
                        }
                        
                        if(parsedData.count==1){
                            //self.resultState = 2
                        }
                        
                    }else{
                        //エラー
                        //self.resultState = -1
                    }
                    
  
                } catch {
                    //エラー処理
                    //self.resultState = -1
  
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
        indicator.center = self.view.center
        // 色の設定
        indicator.color = UIColor.green
        // アニメーション停止と同時に隠す設定
        indicator.hidesWhenStopped = true
        // 画面に追加
        self.view.addSubview(indicator)
        // 最前面に移動
        self.view.bringSubview(toFront: indicator)
        // アニメーション開始
        indicator.startAnimating()
        
    }
}
