//
//  ViewController.swift
//  Yelper
//
//  Created by YINYEE LAI on 10/20/16.
//  Copyright © 2016 Yin Yee Lai. All rights reserved.
//

import UIKit
import MBProgressHUD

class BusinessViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, FiltersViewControllerDelegate {
    
    @IBOutlet weak var businessTableView: UITableView!
    
    var businesses: [Business]!
    
    var searchBar: UISearchBar!
    
    var currentFilters: Filters =  Filters(hasDeal: false, distance: Filters.eDistance.Auto, sortBy: Filters.eSortBy.BestMatch, categories: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //default search
        search(term: "")
    
        setupSearchBar()
        
        businessTableView.dataSource = self
        businessTableView.delegate = self
        businessTableView.rowHeight = UITableViewAutomaticDimension
        businessTableView.estimatedRowHeight = 120
        
    }
    
    func search(term: String?) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let searchTerm = term ?? ""
        Business.searchWithTerm(term: searchTerm, completion: completeSearch)
    }
    
    func search(term: String?, withFilter filters: Filters?) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let searchTerm = term ?? ""

        Business.searchWithTerm(term: searchTerm, filter: filters!, completion: completeSearch)
    }
    
    func completeSearch(businesses: [Business]?, error: Error?) {
        if let searchedBusinesses = businesses {
            self.businesses = [Business]()
            
            for business in searchedBusinesses {
                self.businesses.append(business)
            }
        }
        
        self.businessTableView.reloadData()
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    func setupSearchBar() {
        self.searchBar = UISearchBar()
        self.searchBar.sizeToFit()
        self.searchBar.delegate = self
        
        navigationItem.titleView = searchBar
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search(term: searchBar.text)
        searchBar.endEditing(true)
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.setShowsCancelButton(false, animated: true)
        // Remove focus from the search bar.
        searchBar.endEditing(true)
    }
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {

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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        
        let filterViewController = navigationController.topViewController as! FiltersViewController
        filterViewController.delegate = self
    }
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: Filters) {
        
        let term = searchBar.text ?? ""
        
        search(term: term, withFilter: filters)
    }


}

