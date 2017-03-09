//
//  MyBookListViewController.swift
//  placeBook
//
//  Created by 松浦 雅人 on 2017/03/08.
//  Copyright © 2017年 松浦 雅人. All rights reserved.
//

import UIKit

class MyBookListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var parentContext:MainViewController? = nil
    

    @IBOutlet weak var tv_book: UITableView!
    
    @IBOutlet weak var btn_addBook: UIButton!
    
    var bookArray:[BookListData] = [BookListData]()
    
    override func viewWillAppear(_ animated: Bool) {
//        var bld:BookListData = BookListData()
//        bld.title = "溜池山王リスト"
//        bld.placeNum = 10
//        bookArray.append(bld)
//        
//        bld = BookListData()
//        bld.title = "品川リスト"
//        bld.placeNum = 5
//        bookArray.append(bld)
        
        let apiCon:APIConnector = APIConnector(activity:self, type:2, object: Config.sharedInstance.user_id)
        apiCon.execute()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tv_book.delegate = self
        self.tv_book.dataSource = self
        
        self.btn_addBook.addTarget(self, action: #selector(self.addBook), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //API通信完了後にコールされる(ブックリスト取得)
    func getBookList(array:[BookListData]){
        
        self.bookArray = array
        self.tv_book.reloadData()
    }
    
    //API通信完了後にコールされる(ブック作成)
    func completeMakeBook(){
        
        let apiCon:APIConnector = APIConnector(activity:self, type:2, object: Config.sharedInstance.user_id)
        apiCon.execute()
    }
    
    
    internal func addBook(sender:UIButton){
        
        let alert = UIAlertController(title: "ブック追加", message: "ブック名を入力してください", preferredStyle: .alert)
        
        // OKボタンの設定
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            
            // OKを押した時入力されていたテキストを表示
            if let textFields = alert.textFields {
                
                // アラートに含まれるすべてのテキストフィールドを調べる
                for textField in textFields {
                    //print(textField.text!)
//                    let bld:BookListData = BookListData()
//                    bld.title = textField.text!
//                    self.bookArray.append(bld)
//                    self.tv_book.reloadData()
                    var postData:[String:String] = [String:String]()
                    postData.updateValue(textField.text!, forKey: "title")
                    postData.updateValue(Config.sharedInstance.user_id, forKey: "user_id")
                    
                    let apiCon:APIConnector = APIConnector(activity:self, type:3, object: postData)
                    apiCon.execute()
                    
                }
            }
        })
        alert.addAction(okAction)
        
        // キャンセルボタンの設定
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        // テキストフィールドを追加
        alert.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
            textField.placeholder = "新規ブック"
        })
        
        // 複数追加したいならその数だけ書く
        // alert.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
        //     textField.placeholder = "テキスト"
        // })
        
        alert.view.setNeedsLayout() // シミュレータの種類によっては、これがないと警告が発生
        
        // アラートを画面に表示
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //-----------------------
    // TableView for History
    //-----------------------
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // セクションの行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookArray.count
    }
    
    //セルのセット
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath:IndexPath) -> UITableViewCell {
        
        let cell: BookCustomCell = tableView.dequeueReusableCell(withIdentifier: "BookCustomCell", for: indexPath) as! BookCustomCell
        cell.setCell(book: bookArray[indexPath.row], index:indexPath.row)
        
        return cell
    }
    
    //リスト選択イベント
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let selectData:BookListData = bookArray[indexPath.row]
        
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "DetailBookViewController") as! DetailBookViewController
        nextView.parentContext = self
        nextView.bookListData = selectData
        present(nextView, animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
