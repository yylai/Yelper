//
//  ViewController.swift
//  Yelper
//
//  Created by YINYEE LAI on 10/20/16.
//  Copyright © 2016 Yin Yee Lai. All rights reserved.
//

import UIKit
import MBProgressHUD

class BusinessViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, FiltersViewControllerDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var businessTableView: UITableView!
    
    var searchBar: UISearchBar!
    var businesses: [Business]!
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    var currentFilters: Filters?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //default search
        search(term: "")
    
        setupSearchBar()
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRect(x: 0, y: businessTableView.contentSize.height, width: businessTableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        businessTableView.addSubview(loadingMoreView!)
        
        var insets = businessTableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        businessTableView.contentInset = insets
        
        self.businessTableView.delegate = self
        
        
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
    
    func loadMore(term: String?, withFilter filters: Filters?, offset: Int) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let searchTerm = term ?? ""
        
        Business.loadMoreWithTerm(term: searchTerm, filter: filters, offset: offset, completion: completeSearch)
    }
    
    func completeSearch(businesses: [Business]?, error: Error?) {
        if let searchedBusinesses = businesses {
            
            if !isMoreDataLoading {
                self.businesses = [Business]()
            }
            
            for business in searchedBusinesses {
                self.businesses.append(business)
            }
        }
        
        // Stop the loading indicator
        self.loadingMoreView!.stopAnimating()
        
        isMoreDataLoading = false
        self.businessTableView.reloadData()
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    func setupSearchBar() {
        self.searchBar = UISearchBar()
        self.searchBar.sizeToFit()
        self.searchBar.delegate = self
        self.searchBar.placeholder = "e.g. tacos, delivery, Max's"
        
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
        
        currentFilters = filters
        search(term: term, withFilter: filters)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = businessTableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - businessTableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && businessTableView.isDragging) {
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: businessTableView.contentSize.height, width: businessTableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                 let term = searchBar.text ?? ""
                
                loadMore(term: term, withFilter: currentFilters, offset: businesses.count)
                
                // ... Code to load more results ...
            }
            
            
        }
    }

}

