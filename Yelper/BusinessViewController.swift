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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Business.searchWithTerm(term: "Restaurants", completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            if let searchedBusinesses = businesses {
                self.businesses = [Business]()
                
                for business in searchedBusinesses {
                    print(business.name!)
                    print(business.address!)
                    self.businesses.append(business)
                }
            }
            
            //setupSearchBar()
            self.businessTableView.reloadData()
            MBProgressHUD.hide(for: self.view, animated: true)
            }
        )
        
        businessTableView.dataSource = self
        businessTableView.delegate = self
        businessTableView.rowHeight = UITableViewAutomaticDimension
        businessTableView.estimatedRowHeight = 120
        
    }
    
    func setupSearchBar() {
        self.searchBar = UISearchBar()
        self.searchBar.sizeToFit()
        self.searchBar.delegate = self
        
        navigationItem.titleView = searchBar
        
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    }
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
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
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Business.searchWithTerm(term: "Restaurants", filter: filters) { (businesses: [Business]?, error: Error?) in
                        if let searchedBusinesses = businesses {
                            self.businesses = [Business]()
            
                            for business in searchedBusinesses {
                                print(business.name!)
                                print(business.address!)
                                self.businesses.append(business)
                            }
                        }
            
                        //setupSearchBar()
                        self.businessTableView.reloadData()
                        MBProgressHUD.hide(for: self.view, animated: true)
            
        }
    }


}

