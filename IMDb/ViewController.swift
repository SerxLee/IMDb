//
//  ViewController.swift
//  IMDb
//
//  Created by Serx on 15/11/1.
//  Copyright © 2015年 serx. All rights reserved.
//

import UIKit

class ViewController: UIViewController, IMDbAPIControllerDelegate, UISearchBarDelegate{

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var releasedLable: UILabel!
    @IBOutlet weak var ratingLable: UILabel!
    @IBOutlet weak var plotLable: UILabel!
    @IBOutlet weak var SubTittlelable: UILabel!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    lazy var apiController:IMDbAPIController = IMDbAPIController(delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.apiController.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "userTappedInView:")
        self.view.addGestureRecognizer(tapGesture)
        
        self.formatLable(true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    
    //lable设置
    func formatLable(firstLaunch: Bool){
        
        let lablesArray = [self.titleLable, self.SubTittlelable, self.releasedLable, self.plotLable, self.ratingLable]

        if firstLaunch{
            
            for lable in lablesArray{
                lable.text = ""
            }
        }
        
        for lable in lablesArray{
            
            lable.textAlignment = .Center
            
            switch lable{
                
            case self.titleLable:
                lable.font = UIFont(name: "Kailasa", size: 23)
            case self.SubTittlelable:
                lable.font = UIFont(name: "Kailasa", size: 20)
            case self.releasedLable:
                lable.font = UIFont(name: "Kailasa", size: 16)
            case self.plotLable:
                lable.font = UIFont(name: "Kailasa", size: 12)
            default:
                lable.font = UIFont(name: "Kailasa", size: 14)
            }
            
        }
        
        self.titleLable.font = UIFont(name: "kailase", size: 23)
        self.SubTittlelable.font = UIFont(name: "kailase", size: 20)
        self.releasedLable.font = UIFont(name: "kailase", size: 16)
        self.plotLable.font = UIFont(name: "kailase", size: 12)
        self.ratingLable.font = UIFont(name: "kailase", size: 14)
            
    }
    
    
    //blarbacground虚化
    func blurBackgroundUsingImage(image: UIImage){
        
        let frame = CGRectMake(0, 0, view.frame.width, view.frame.height)

        //显示传进来的image
        let imageView = UIImageView(frame: frame)
        imageView.image = image
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        
        //指定虚化风格
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = frame
        
        //建一个白色的View
        let transparentWhiteView = UIView(frame: frame)
        transparentWhiteView.backgroundColor = UIColor(white: 1.0, alpha: 0.30)
        
        
        var viewArray = [imageView, blurEffectView, transparentWhiteView]
        for index in 0..<viewArray.count{
            if let oldView = self.view.viewWithTag(index + 1){
                oldView.removeFromSuperview()
            }
            let viewToInsert = viewArray[index]
            self.view.insertSubview(viewToInsert, atIndex: index)
            viewToInsert.tag = index + 1
        }
        
        
        for value in self.view.subviews{
            print(value)
            print(value.tag)
        }
    }
    
    
    func parseTittleFromSubtittle(tittle:String){
        let index = tittle.findIndexOf(":")
        
        if let foundIndex = index{
            let newTittle = tittle[0..<foundIndex]
            let subTittle = tittle[foundIndex + 2 ..< tittle.characters.count]
            
            self.titleLable.text = newTittle
            self.SubTittlelable.text = subTittle
        }else{
            self.titleLable.text = tittle
            self.SubTittlelable.text = ""
        }
        
    }
        
    func didFinishIMDbSearch(result: Dictionary<String, String>) {
        
        self.formatLable(false)
        
        if  let foundTitle = result["Title"]{
            self.parseTittleFromSubtittle(foundTitle)
        }
        
        self.releasedLable.text = result["Released"]
        self.ratingLable.text = result["Rated"]
        self.plotLable.text = result["Plot"]
        
        //the iamge url
        if let foundPosterUrl = result["Poster"]{
            formatImageFromPath(foundPosterUrl)
        }
    }
    
    
    //添加图片 json Poster
    func formatImageFromPath(path: String){
        let posterUrl = NSURL(string: path)
        let posterImageData = NSData(contentsOfURL: posterUrl!)
        
        self.posterImageView.layer.cornerRadius = 100.0
        self.posterImageView.clipsToBounds = true
        self.posterImageView.contentMode = .ScaleAspectFill
        self.posterImageView.image = UIImage(data: posterImageData!)
        
        self.blurBackgroundUsingImage(UIImage(data: posterImageData!)!)
    }
    
    
    //Search
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.apiController.searchIMDb(searchBar.text!)
        searchBar.resignFirstResponder()
        searchBar.text = ""

    }
    
    //键盘隐藏 手势识别 方法
    func userTappedInView(recognizer: UITapGestureRecognizer){
        self.searchBar.resignFirstResponder()
    }    
}

