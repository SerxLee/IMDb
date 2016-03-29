//
//  HomeViewController.swift
//  IMDb
//
//  Created by Serx on 16/3/29.
//  Copyright © 2016年 serx. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UISearchBarDelegate{
    
    var searchContent: String?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "userTappedInView:")
        self.view.addGestureRecognizer(tapGesture)
        
    }
    
    func userTappedInView(gestrue: UITapGestureRecognizer){
        
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        searchContent = searchBar.text
        searchBar.resignFirstResponder()
        searchBar.text = ""
        
        
        
        performSegueWithIdentifier("toSearchResultList", sender: searchContent)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toSearchResultList"{
            
            let navigationController = segue.destinationViewController as! UINavigationController
            let nextViewController = navigationController.topViewController as! SearchListTableViewController
            
            nextViewController.searchContent = sender as? String
        }
    }
}
