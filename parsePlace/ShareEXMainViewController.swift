//
//  ShareEXMainViewController.swift
//  placeBook
//
//  Created by 松浦 雅人 on 2017/03/10.
//  Copyright © 2017年 松浦 雅人. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices

class ShareEXMainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let suiteName: String = "group.jp.vex.placeBook"
    
    @IBOutlet weak var label_url: UILabel!

    @IBOutlet weak var tv_book: UITableView!
    
    @IBOutlet weak var tf_comment: UITextField!
    
    var loginFlag:Bool = true
    var user_id:String = ""
    var url:String = ""
    
    var bookArray:[ShareEXBookListData] = [ShareEXBookListData]()
    var selectedData:ShareEXBookListData = ShareEXBookListData()
    
    struct TableViewValues {
        static let identifier = "Cell"
    }
    
    @IBAction func pushClose(_ sender: Any) {
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    @IBAction func pushPost(_ sender: Any) {
        
        let postData:ShareEXPostData = ShareEXPostData()
        postData.user_id = self.user_id
        postData.url = self.url
        postData.book_id = self.selectedData.book_id
        postData.comment = self.tf_comment.text!
        
        let apiCon:ShareEXAPIConnector = ShareEXAPIConnector(activity:self, type:2, object: postData)
        apiCon.execute()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        let book = ShareEXBookListData()
        book.title = "未分類"
        book.book_id = "0"
        self.bookArray.append(book)
        self.tv_book.reloadData()
        self.selectedData = book
        
        let sharedDefaults: UserDefaults = UserDefaults(suiteName: self.suiteName)!
        if let user_id = sharedDefaults.object(forKey: "user_id") as? String {
            
            self.user_id = user_id
            loginFlag = true
            
            let apiCon:ShareEXAPIConnector = ShareEXAPIConnector(activity:self, type:1, object: user_id)
            apiCon.execute()
        }else{
            
            loginFlag = false
            
        }

        
        
    }
    
    //ブックリスト取得後にコールされる
    func getBookList(array:[ShareEXBookListData]){
        
        self.bookArray = array
        self.tv_book.reloadData()
        //self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    //登録処理後にコールされる
    func completePost() {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tv_book.delegate = self
        self.tv_book.dataSource = self
        
        if(!loginFlag){
            
            let alert = UIAlertController(
                title: "SNSログインなし",
                message: "グルメポケットアプリより、SNSログイン実施後に登録可能となります。",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: {
            })
        }
        
        
        let inputItem = self.extensionContext!.inputItems.first as! NSExtensionItem
        let itemProvider = inputItem.attachments![0] as! NSItemProvider
        
        if (itemProvider.hasItemConformingToTypeIdentifier("public.url")) {
            itemProvider.loadItem(forTypeIdentifier: "public.url", options: nil, completionHandler: { (urlItem, error) in
                
                let url = urlItem as! NSURL;
                // 取得したURLを表示
                print("\(url.absoluteString!)")
                self.label_url.text = url.absoluteString!
                self.url = url.absoluteString!
                
//                let apiCon:ShareEXAPIConnector = ShareEXAPIConnector(activity:self, type:1, object: "")
                //apiCon.execute()

                
                //self.getBookList()
                
                //self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
                
            })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bookArray.count
    }
    
    
    //セルのセット
    func tableView(_ tableView: UITableView, cellForRowAt indexPath:IndexPath) -> UITableViewCell {
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: TableViewValues.identifier, for: indexPath) as UITableViewCell
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.backgroundColor = UIColor.clear
        
        let tmp: ShareEXBookListData = self.bookArray[indexPath.row]
        
//        // 選択したアイテムにチェックマークをつける
//        if tmp.book_id == selectedData.book_id {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        cell.textLabel!.text = tmp.title
        
        return cell

    }
    
    //リスト選択イベント
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.selectedData = self.bookArray[indexPath.row]
    }


}
