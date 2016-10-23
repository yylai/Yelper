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
    let filterSectionLabelsForRow:[[String]] = [["Offering a deal"], ["Auto", "0.3 miles", "1 mile", "5 miles", "20 miles"], ["Best Match", "Distance", "Highest Rated"], ["Japanese", "Korean", "Seafood", "NewAmerican"]]
    
    let distanceLookup = [Filters.eDistance.Auto, Filters.eDistance.Point3Mile, Filters.eDistance.OneMile, Filters.eDistance.FiveMiles, Filters.eDistance.TwentyMiles]
    let sortLookup = [Filters.eSortBy.BestMatch, Filters.eSortBy.Distance, Filters.eSortBy.HighestRated]
    let categoryLookup = [Filters.eCategory.japanese, Filters.eCategory.korean, Filters.eCategory.seafood, Filters.eCategory.newamerican]
    
    var hasDealState: Bool = false
    var sortedByState: [Filters.eSortBy: Bool] = [Filters.eSortBy.BestMatch: true, Filters.eSortBy.HighestRated: false, Filters.eSortBy.Distance: false]
    var distanceState: [Filters.eDistance: Bool] = [Filters.eDistance.Auto: true, Filters.eDistance.Point3Mile: false, Filters.eDistance.OneMile: false, Filters.eDistance.FiveMiles: false, Filters.eDistance.TwentyMiles: false]
    var categoryState: [Filters.eCategory: Bool] = [Filters.eCategory.japanese: false, Filters.eCategory.korean: false, Filters.eCategory.newamerican: false, Filters.eCategory.seafood: false]
    
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
        
        
        let distance = distanceState.first { (key, value) -> Bool in
            return value
        }?.key
        
        let sortedBy = sortedByState.first { (key, value) -> Bool in
            return value
        }?.key
        
        let categories = categoryState.filter { (key, value) -> Bool in
            return value
        }.map { (key, value) -> Filters.eCategory in
            return key
        }
        
        let filterState = Filters(hasDeal: false, distance: distance, sortBy: sortedBy, categories: categories)
        
        
        delegate?.filtersViewController?(filtersViewController: self, didUpdateFilters: filterState)
    }
    
    
    func switchCell(switchCell: SwitchCell, didChangeValue: Bool) {
        
        let path = filterTableView.indexPath(for: switchCell)!
        let isOn = switchCell.filterSwitch.isOn
        switch path.section {
        case 0:
            setHasDealState(newValue: isOn)
        case 1:
            setDistanceState(distance: distanceLookup[path.row], newValue: isOn)
        case 2:
            setSortByState(sortBy: sortLookup[path.row], newValue: isOn)
        case 3:
            setCategoryState(category: categoryLookup[path.row], newValue: isOn)
        default:
            break
        }
        
        filterTableView.reloadData()
        
        //print("switch cell click section \(path.section) row \(path.row)")
    }
    
    func setDistanceState(distance: Filters.eDistance, newValue: Bool) {
        //reset all
        distanceState.forEach { (key, value) in
            distanceState[key] = false
        }
        
        distanceState[distance] = newValue
    }
    
    func setCategoryState(category: Filters.eCategory, newValue: Bool) {
        categoryState[category] = newValue
    }
    
    func setSortByState(sortBy: Filters.eSortBy, newValue: Bool) {
        //reset all
        sortedByState.forEach { (key, value) in
            sortedByState[key] = false
        }
        
        sortedByState[sortBy] = newValue
    }
    
    func setHasDealState(newValue: Bool) {
        hasDealState = newValue
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
        setFilterValue(cell: cell, section: indexPath.section, row: indexPath.row)
        
        return cell
    }
    
    func setFilterLabels(cell: SwitchCell, section: Int, row: Int) {
        cell.filterLabel.text = filterSectionLabelsForRow[section][row]
    }
    
    func setFilterValue(cell: SwitchCell, section: Int, row: Int) {
        switch section {
        case 0:
            //setHasDealState(newValue: isOn)
            cell.filterSwitch.isOn = hasDealState
        case 1:
            cell.filterSwitch.isOn = distanceState[distanceLookup[row]]!
        case 2:
            cell.filterSwitch.isOn = sortedByState[sortLookup[row]]!
        case 3:
            cell.filterSwitch.isOn = categoryState[categoryLookup[row]]!
        default:
            break
        }
    }

}
