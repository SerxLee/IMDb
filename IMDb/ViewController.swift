//
//  ViewController.swift
//  IMDb
//
//  Created by Serx on 15/11/1.
//  Copyright © 2015年 serx. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var releasedLable: UILabel!
    @IBOutlet weak var ratingLable: UILabel!
    @IBOutlet weak var plotLable: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonPressed(sender: UIButton) {
        self.searchIMDb("the lion king")
    }
    
    func searchIMDb(forContent: String){
        var spacelessString = forContent.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        
        var urlPath = NSURL(string: "http://www.omdbapi.com/?t=\(spacelessString!)")
        var session = NSURLSession.sharedSession()
        var task = session.dataTaskWithURL(urlPath!) { (data, response, error) -> Void in
            do{
                if error != nil{
                    print(error?.localizedDescription)
                    
                }else{
            
                let jsonResult = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                
                    
                
                }
                
                
                
            }catch{
                print("error")
            }
            
        }
    }
}

