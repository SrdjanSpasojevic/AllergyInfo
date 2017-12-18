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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Home"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)]
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        UIApplication.shared.statusBarStyle = .lightContent
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: TableView delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AIAppState.sharedInstance.dataSource.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: Global.homeCellIdentifier) as! HomeTableViewCell
        
        cell.dateLabel.text = formatDate()
        cell.weatherDescriptionLabel.text = AIAppState.sharedInstance.dataSource[indexPath.row].dayDescription
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 211
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
//        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
//        UIView.animate(withDuration: 0.4, animations: {
//            cell.layer.transform = CATransform3DMakeScale(1,1,1)
//        },completion: { finished in
//            UIView.animate(withDuration: 0.2, animations: {
//                cell.layer.transform = CATransform3DMakeScale(1,1,1)
//            })
//        })
        cell.contentView.animateCell(cell: cell)
        
    }
    
    private func formatDate() -> String{
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let myString = formatter.string(from: Date()+1)
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "dd/MMM/yyyy HH:mm"
        // again convert your date to string
        let myStringafd = formatter.string(from: yourDate!)
        
        return myStringafd
    }
    
    func playerDidReachEnd(){
        self.playVideo()
    }
    
    
    private func playVideo() {
        guard let path = Bundle.main.path(forResource: "weatherVideo", ofType:"m4v") else {
            debugPrint("video.m4v not found")
            return
        }
        self.player = AVPlayer(url: URL(fileURLWithPath: path))
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        playerLayer!.frame = self.tableView.frame
        self.view!.layer.addSublayer(playerLayer!)
        
        
        self.view.bringSubview(toFront: self.tableView)
        let seekToTime = CMTime(seconds: 10, preferredTimescale: 1)
        self.player?.currentItem?.seek(to: seekToTime)
        self.player?.volume = 0.0
        self.player?.play()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
}









