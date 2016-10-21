//
//  ViewController.swift
//  Yelper
//
//  Created by YINYEE LAI on 10/20/16.
//  Copyright © 2016 Yin Yee Lai. All rights reserved.
//

import UIKit

class BusinessViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var businessTableView: UITableView!
    
    var businesses: [Business]!
    
    var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Business.searchWithTerm(term: "Thai", completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
//            if let businesses = businesses {
//                for business in businesses {
//                    print(business.name!)
//                    print(business.address!)
//                }
//            }
            
            self.businessTableView.reloadData()
            
            }
        )
        
        businessTableView.dataSource = self
        businessTableView.delegate = self
        businessTableView.rowHeight = UITableViewAutomaticDimension
        businessTableView.estimatedRowHeight = 120
        
        setupSearchBar()
        
        /* Example of Yelp search with more search options specified
         Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
         self.businesses = businesses
         
         for business in businesses {
         print(business.name!)
         print(business.address!)
         }
         }
         */
    }
    
    func setupSearchBar() {
        self.searchBar = UISearchBar()
        self.searchBar.sizeToFit()
        self.searchBar.delegate = self
        
        navigationItem.titleView = searchBar
        
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        
//        if searchText == "" {
//            filteredMovies = movies!
//        } else {
//            filteredMovies = movies!.filter({ (movie) -> Bool in
//                let currentTitle = movie["title"] as! String
//                let range = currentTitle.range(of: searchText, options: .caseInsensitive)
//                return range != nil
//            })
//        }
//        
//        self.movieTableView.reloadData()
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        isSearching = true
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.text = nil
        searchBar.setShowsCancelButton(false, animated: true)
//        isSearching = false
//        // Remove focus from the search bar.
  searchBar.endEditing(true)
    }
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        isSearching = true
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        self.movieTableView.reloadData()
    }
    
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return businesses.count
        } else {
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = businessTableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        
        cell.business = businesses[indexPath.row]
        
        return cell
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

