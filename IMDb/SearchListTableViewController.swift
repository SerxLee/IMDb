//
//  SearchListTableViewController.swift
//  IMDb
//
//  Created by Serx on 16/3/29.
//  Copyright © 2016年 serx. All rights reserved.
//

import UIKit

class SearchListTableViewController: UITableViewController, IMDbAPIControllerDelegate{
    
    var refreshController = UIRefreshControl()
    
    lazy var apiController:IMDbAPIController = IMDbAPIController(delegate: self)
    
    var dataSource = [Dictionary<String, String>]()
    var isFinish: Bool = false
    
    var searchContent: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshController.attributedTitle = NSAttributedString(string: "下拉刷新")
        refreshController.addTarget(self, action: "reloadHomeTableView", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshController)
        
    }
    
    override func viewWillAppear(animated: Bool) {

        super.viewWillAppear(animated)
        self.apiController.delegate = self
        startSearching()
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSource.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = "movieCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! SearchListTableViewCell
        
        if isFinish{
            let row = indexPath.row
            
            
            cell.searchResultTitle.text = dataSource[row]["Title"]
            
            if homePosterImages.count > row {
                cell.searchResultImage.image = homePosterImages[row]
            }
        }
        else{
            cell.searchResultImage.image = nil
            cell.searchResultTitle.text = ""
        }
        
        return cell
    }
    
    
    var homePosterImages = [UIImage]()
    func cacheHomePosterImage() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            for i in 0 ..< self.dataSource.count {
                let singerMovie: NSDictionary! = self.dataSource[i] as NSDictionary
                let urlString: String! = singerMovie["Poster"] as! String

                let url = NSURL(string: urlString)
                if let imageData = NSData(contentsOfURL: url!) {
                    self.homePosterImages.append(UIImage(data: imageData)!)
                }
            }
        }
    }
    
    
    func reloadHomeTableView() {
        NSLog("reload")
        if self.dataSource.count != 0 {
            cacheHomePosterImage()
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        }
        refreshController.endRefreshing()
    }
    
    
    //add the image to the cell's iamgeView
    func formatImageFromPath(path: String) -> UIImage{
        
        let posterUrl = NSURL(string: path)
        let posterImageData = NSData(contentsOfURL: posterUrl!)
        
        let image = UIImage(data: posterImageData!)!
        
        return image
    }
    
    func startSearching(){
        
        self.apiController.searchIMDbForKeyword(searchContent!)
    }
    
    func didFinishIMDbSearch(result: [Dictionary<String, String>], finish: Bool) {
        
        self.dataSource = result
        self.isFinish = finish
        
        self.tableView.reloadData()
    }
    @IBAction func getBack(sender: AnyObject) {

        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        NSLog("here")
        print(self.dataSource[indexPath.row]["imdbID"])

        movieID = self.dataSource[indexPath.row]["imdbID"]!
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//        if segue.identifier == "toDetailView"{
//            let nextController = segue.destinationViewController as! ViewController
////
//            nextController.movieID = sender as! String
//        }
//    }
    
}
