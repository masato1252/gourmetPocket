//
//  PlaceListViewController.swift
//  placeBook
//
//  Created by 松浦 雅人 on 2017/03/08.
//  Copyright © 2017年 松浦 雅人. All rights reserved.
//

import UIKit

class PlaceListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var parentContext:MainViewController? = nil
    
    @IBOutlet weak var tv_place: UITableView!
    
    var placeArray:[PlaceListData] = [PlaceListData]()
    
    override func viewWillAppear(_ animated: Bool) {
//        var pld:PlaceListData = PlaceListData()
//        pld.name = "いざかや"
//        pld.area = "千代田区"
//        pld.station = "溜池山王駅"
//        pld.img = UIImage(named: "noimage.png")!
//        placeArray.append(pld)
        
        var postData:[String:String] = [String:String]()
        postData.updateValue(Config.sharedInstance.user_id, forKey: "user_id")
        
        let apiCon:APIConnector = APIConnector(activity:self, type:4, object: postData)
        apiCon.execute()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tv_place.delegate = self
        self.tv_place.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //API後にコール
    func getPlaceList(array:[PlaceListData]){
        self.placeArray = array
        self.tv_place.reloadData()
    }
    
    //-----------------------
    // TableView for History
    //-----------------------
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // セクションの行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeArray.count
    }
    
    //セルのセット
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath:IndexPath) -> UITableViewCell {
        
        let cell: PlaceCustomCell = tableView.dequeueReusableCell(withIdentifier: "PlaceCustomCell", for: indexPath) as! PlaceCustomCell
        cell.setCell(place: placeArray[indexPath.row], index:indexPath.row)
        
        return cell
    }
    
    //リスト選択イベント
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let selectData:PlaceListData = placeArray[indexPath.row]
        
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "DetailPlaceViewController") as! DetailPlaceViewController
        nextView.parentContext = self
        nextView.placeListData = selectData
        present(nextView, animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
}
