//
//  SecondViewController.swift
//  AllergyInfo
//
//  Created by Srdjan Spasojevic on 4/26/17.
//  Copyright © 2017 Srdjan Spasojevic. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Firebase

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var player : AVPlayer?
    var playerLayer : AVPlayerLayer?
    var displayedCells = [NSIndexPath]()
    var timer: Timer? = nil
    var indexToPass: IndexPath?
    let refreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Home"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)]
        
        self.refreshControl.attributedTitle = NSAttributedString(string: "Reloading...")
        self.refreshControl.tintColor = UIColor.gray
        
        if #available(iOS 10.0, *)
        {
            self.tableView.refreshControl = refreshControl
        }
        else
        {
            self.tableView.addSubview(refreshControl)
        }
        
        self.refreshControl.addTarget(self, action: #selector(self.getData), for: .valueChanged)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        UIApplication.shared.statusBarStyle = .lightContent
        
        
        if !AIAppState.sharedInstance.dataLoaded
        {
            self.getData()
        }
        
        LocalNotificationManager.engine.createNotification(title: "Hello", body: "Welcome to Allergy Info System. System that will help you overcome allergies. Enjoy!", categoryID: .welcome, fireIn: 5)
    }
    
    @objc private func getData()
    {
        AIAppState.sharedInstance.fetchData { (hasData) in
            if hasData
            {
                print("Data loaded")
                self.refreshControl.endRefreshing()
                self.tableView.backgroundView?.isHidden = true
                self.tableView.reloadData()
                self.addDaysInAdvance()
            }
            else
            {
                print("Error occured")
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
                self.handleEmptyTableView()
            }
            
            Global.stopActivity()
            AIAppState.sharedInstance.dataLoaded = hasData
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func addDaysInAdvance(){
        for i in 0...AIAppState.sharedInstance.dataSource.count-1{
            if i == 0{
                AIAppState.sharedInstance.dataSource[i].date = self.formatDate(date: Date())
            }else{
                let addDate = (Calendar.current as NSCalendar).date(byAdding: .day, value: i, to: Date(), options: [])!
                AIAppState.sharedInstance.dataSource[i].date = self.formatDate(date: addDate)
            }
        }
    }
    
    private func handleEmptyTableView(){
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        messageLabel.text = ":(\nNow info right now, check back later..."
        messageLabel.textColor = UIColor.white
        messageLabel.numberOfLines = 0;
        messageLabel.font = UIFont(name: "Kohinoor Devanagari", size: 35.0)
        messageLabel.textAlignment = .center;
        messageLabel.sizeToFit()
        
        self.tableView.backgroundView = messageLabel;
    }
    
    //MARK: TableView delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AIAppState.sharedInstance.dataSource.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if !AIAppState.sharedInstance.dataSource.isEmpty{
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: Global.homeCellIdentifier) as! HomeTableViewCell
        
        cell.selectionStyle = .none
        
        cell.dateLabel.text = AIAppState.sharedInstance.dataSource[indexPath.row].date
        
        cell.weatherDescriptionLabel.text = AIAppState.sharedInstance.dataSource[indexPath.row].dayDescription
        
        if let icon = AIAppState.sharedInstance.dataSource[indexPath.row].iconType{
            cell.iconImageView.image = UIImage(named: icon)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 211
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.indexToPass = indexPath
        self.performSegue(withIdentifier: "cellToDetailSegue", sender: nil)
        let cell = tableView.cellForRow(at: indexPath) as? HomeTableViewCell
        cell?.isSelected = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cellToDetailSegue"{
            if let infoVC = segue.destination as? CurrentInfoViewController{
                if let index = self.indexToPass{
                    let dataObject = AIAppState.sharedInstance.dataSource[index.row]
                    infoVC.dataObject = dataObject
                }
            }
        }
    }
    
    private func formatDate(date: Date) -> String{
        let formatter = DateFormatter()
        
        // initially set the format based on your datepicker date
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let myString = formatter.string(from: date)
        
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "EEEE"
        
        // again convert your date to string
        var myStringFormated = ""
        if Calendar.current.isDateInToday(date){
            myStringFormated = "Today"
        }else{
            myStringFormated = formatter.string(from: yourDate!)
        }
            
        return myStringFormated
    }
    
    
    //MARK: Maybe not the best idea to add video in background
    //TIP: Add it to the splash screen
//    func playerDidReachEnd(){
//        self.playVideo()
//    }
//
//
//    private func playVideo() {
//        guard let path = Bundle.main.path(forResource: "weatherVideo", ofType:"m4v") else {
//            debugPrint("video.m4v not found")
//            return
//        }
//        self.player = AVPlayer(url: URL(fileURLWithPath: path))
//        playerLayer = AVPlayerLayer(player: player)
//        playerLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
//        playerLayer!.frame = self.tableView.frame
//        self.view!.layer.addSublayer(playerLayer!)
//
//
//        self.view.bringSubview(toFront: self.tableView)
//        let seekToTime = CMTime(seconds: 10, preferredTimescale: 1)
//        self.player?.currentItem?.seek(to: seekToTime)
//        self.player?.volume = 0.0
//        self.player?.play()
//
//        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
//    }
}
