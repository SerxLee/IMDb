//
//  IMDbAPIController.swift
//  IMDb
//
//  Created by Serx on 16/3/28.
//  Copyright © 2016年 serx. All rights reserved.
//

import Foundation
import AFNetworking

protocol IMDbAPIControllerDelegate{
    
    func didFinishIMDbSearch(result: [Dictionary<String, String>], finish: Bool)
}

protocol IMDbAPISearchByIdDelegate{
    
    func didFinishSearchByID(result: Dictionary<String, String>)
}

class IMDbAPIController: NSObject{
    
    let manager = AFHTTPSessionManager()
    
    var delegate: IMDbAPIControllerDelegate?
    
    init(delegate: IMDbAPIControllerDelegate){
        self.delegate = delegate
    }
    
    

    
    func searchIMDbForKeyword(keyWord: String){
        
        let spacelessString = keyWord.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        let urlPath: String =  "http://www.omdbapi.com/?s=\(spacelessString)"
        
        manager.POST(urlPath, parameters: nil, success: { (AFHTTPRequestOperation operation,id responseObject) -> Void in
            
            if responseObject!["Response"] as! String == "False"{
                
                if let apiDelegate = self.delegate {
                    dispatch_async(dispatch_get_main_queue()){
                        
                        var lim = [Dictionary<String, String>]()
                        
                        lim.append(responseObject as! Dictionary<String, String>)
                        
                        apiDelegate.didFinishIMDbSearch(lim, finish: false)
                    }
                }
            }else{
                if let apiDelegate = self.delegate {
                    dispatch_async(dispatch_get_main_queue()){
                        
                        let result = responseObject!["Search"] as! [Dictionary<String, String>]
                        
                        apiDelegate.didFinishIMDbSearch(result, finish: true)
                    }
                }

            }
            
        }, failure: nil)
    }
}


class IMDbAPIControllerSearchByID: NSObject {
    
    let manager = AFHTTPSessionManager()

    
    var delegate: IMDbAPISearchByIdDelegate?
    
    init(delegate: IMDbAPISearchByIdDelegate){
        
        self.delegate = delegate
    }
    
    func searchIMDbByID(forContent: String){
        
        
        let spacelessString = forContent.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        let urlPath: String = "http://www.omdbapi.com/?i=\(spacelessString)"
        
        manager.POST(urlPath, parameters: nil, success: { (AFHTTPRequestOperation operation,id responseObject) -> Void in
            
            if let apiDelegate = self.delegate {
                dispatch_async(dispatch_get_main_queue()){
                    
                    let result = responseObject as! Dictionary<String, String>
                    
                    apiDelegate.didFinishSearchByID(result)
                }
            }

            }, failure: nil)
    }

}