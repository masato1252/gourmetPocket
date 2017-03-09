//
//  DetailPlaceViewController.swift
//  placeBook
//
//  Created by 松浦 雅人 on 2017/03/08.
//  Copyright © 2017年 松浦 雅人. All rights reserved.
//

import UIKit

class DetailPlaceViewController: UIViewController{
    
    var parentContext:UIViewController? = nil
    var placeListData:PlaceListData = PlaceListData()
    
    
    @IBOutlet weak var label_name: UILabel!
    @IBOutlet weak var label_cat: UILabel!
    @IBOutlet weak var label_openTime: UILabel!
    @IBOutlet weak var label_area: UILabel!
    @IBOutlet weak var label_station: UILabel!
    @IBOutlet weak var label_tel1: UILabel!
    @IBOutlet weak var label_tel2: UILabel!
    @IBOutlet weak var label_address: UILabel!
    
    
    @IBOutlet weak var btn_close: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        
        var postData:[String:String] = [String:String]()
        postData.updateValue(Config.sharedInstance.user_id, forKey: "user_id")
        postData.updateValue(self.placeListData.place_id, forKey: "place_id")
        
        let apiCon:APIConnector = APIConnector(activity:self, type:6, object: postData)
        apiCon.execute()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.btn_close.addTarget(self, action: #selector(self.closeThisView), for: .touchUpInside)
        
        let swipeUpGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeRight))
        swipeUpGesture.numberOfTouchesRequired = 1  // number of fingers
        swipeUpGesture.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeUpGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //右へスワイプで閉じる
    func handleSwipeRight(sender: UITapGestureRecognizer){
        dismiss(animated: true, completion: {
            [presentingViewController] () -> Void in
            // 閉じた時に行いたい処理
            presentingViewController?.viewWillAppear(true)
        })
    }
    
    //API受信後にコールされる
    func getPlaceInfo(data:PlaceData){
        
        label_name.text = data.name
        label_cat.text = data.cat
        label_area.text = data.area
        label_tel1.text = data.tel1
        label_tel2.text = data.tel2
        label_address.text = data.address
        label_station.text = data.station
        label_openTime.text = data.open_time
    }
    
    internal func closeThisView(sender:UIButton){
        
        dismiss(animated: true, completion: {
            [presentingViewController] () -> Void in
            // 閉じた時に行いたい処理
            presentingViewController?.viewWillAppear(true)
        })
    }
    
}
