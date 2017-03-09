//
//  SharedBookListViewController.swift
//  placeBook
//
//  Created by 松浦 雅人 on 2017/03/08.
//  Copyright © 2017年 松浦 雅人. All rights reserved.
//

import UIKit

class SharedBookListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var parentContext:MainViewController? = nil
    
    
    @IBOutlet weak var tv_book: UITableView!
    
    var bookArray:[BookListData] = [BookListData]()
    
    override func viewWillAppear(_ animated: Bool) {
        var bld:BookListData = BookListData()
        bld.title = "シェアリスト１"
        bld.placeNum = 10
        bld.shareUserName = "taro123"
        bookArray.append(bld)
        
        bld = BookListData()
        bld.title = "シェアリスト２"
        bld.placeNum = 5
        bld.shareUserName = "jiro456"
        bookArray.append(bld)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tv_book.delegate = self
        self.tv_book.dataSource = self
        
        //self.btn_addBook.addTarget(self, action: #selector(self.addBook), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

