//
//  IMDbAPIController.swift
//  IMDb
//
//  Created by Serx on 16/3/28.
//  Copyright © 2016年 serx. All rights reserved.
//

import Foundation

protocol IMDbAPIControllerDelegate{
    
    func didFinishIMDbSearch(result: Dictionary<String, String>)
}

class IMDbAPIController: NSObject{
    
    var delegate: IMDbAPIControllerDelegate?
    
    init(delegate: IMDbAPIControllerDelegate){
        self.delegate = delegate
    }
    
    func searchIMDb(forContent: String){
        
        let spacelessString = forContent.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        let urlPath = NSURL(string: "http://www.omdbapi.com/?t=\(spacelessString)")
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(urlPath!, completionHandler: {(data, reponse, error) in
            
            let jsonResults : AnyObject
            
            do {
                jsonResults = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                
                if let apiDelegate = self.delegate {
                    
                    dispatch_async(dispatch_get_main_queue()){

                        apiDelegate.didFinishIMDbSearch(jsonResults as! Dictionary<String, String>)
                    }
                }
            } catch let error as NSError {
                // failure
                print("Fetch failed: \(error.localizedDescription)")
            }
            
        })
        
        task.resume()
    }
    
}