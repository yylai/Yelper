//
//  FiltersViewController.swift
//  Yelper
//
//  Created by YINYEE LAI on 10/22/16.
//  Copyright © 2016 Yin Yee Lai. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    @objc optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: Filters)
}

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate {

    
    @IBOutlet weak var filterTableView: UITableView!
    
    let filterSectionTitle = ["Deals", "Distance", "Sort By", "Categories"]
    let filterSectionLabelsForRow:[[String]] = [["Offering a deal"], ["Auto", "0.3", "1", "5", "20"], ["Best Match", "Distance", "Highest Rated"], ["Japanese", "Korean", "Seafood", "NewAmerican"]]
    
    //default filter state
    let filterState = Filters(hasDeal: false, distance: Filters.eDistance.Auto, sortBy: Filters.eSortBy.HighestRated, categories: [Filters.eCategory.japanese])
    
    weak var delegate: FiltersViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        filterTableView.delegate = self
        filterTableView.dataSource = self
        
        filterTableView.rowHeight = UITableViewAutomaticDimension
        filterTableView.estimatedRowHeight = 120
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelButton(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func onSearchButton(_ sender: AnyObject) {
        
        dismiss(animated: true, completion: nil)
        delegate?.filtersViewController?(filtersViewController: self, didUpdateFilters: filterState)
    }
    
    
    func switchCell(switchCell: SwitchCell, didChangeValue: Bool) {
        
        let path = filterTableView.indexPath(for: switchCell)!
        
        print("switch cell click section \(path.section) row \(path.row)")
    }
    
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return filterSectionTitle.count
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return filterSectionTitle[section]
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return filterSectionLabelsForRow[section].count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
        
        cell.delegate = self
        
        setFilterLabels(cell: cell, section: indexPath.section, row: indexPath.row)
        
        return cell
    }
    
    func setFilterLabels(cell: SwitchCell, section: Int, row: Int) {
        cell.filterLabel.text = filterSectionLabelsForRow[section][row]
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
