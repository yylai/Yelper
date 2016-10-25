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

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate, ExpandCellDelegate {

    
    @IBOutlet weak var filterTableView: UITableView!
    
    let filterSectionTitle = ["Deals", "Distance", "Sort By", "Categories"]
    let filterSectionLabelsForRow:[[String]] = [["Offering a deal"], ["Auto", "0.3 miles", "1 mile", "5 miles", "20 miles"], ["Best Match", "Distance", "Highest Rated"], ["Japanese", "Korean", "Seafood", "NewAmerican"]]
    
    let distanceLookup = [Filters.eDistance.Auto, Filters.eDistance.Point3Mile, Filters.eDistance.OneMile, Filters.eDistance.FiveMiles, Filters.eDistance.TwentyMiles]
    let sortLookup = [Filters.eSortBy.BestMatch, Filters.eSortBy.Distance, Filters.eSortBy.HighestRated]
    let categoryLookup = [Filters.eCategory.japanese, Filters.eCategory.korean, Filters.eCategory.seafood, Filters.eCategory.newamerican]
    
    var hasDealState: Bool = false
    var sortedByState: [Filters.eSortBy: Bool] = [Filters.eSortBy.BestMatch: true, Filters.eSortBy.HighestRated: false, Filters.eSortBy.Distance: false]
    var sortedByText: [Filters.eSortBy: String] = [Filters.eSortBy.BestMatch: "Best Match", Filters.eSortBy.HighestRated: "Highest Rate", Filters.eSortBy.Distance: "Distance"]
    var distanceState: [Filters.eDistance: Bool] = [Filters.eDistance.Auto: true, Filters.eDistance.Point3Mile: false, Filters.eDistance.OneMile: false, Filters.eDistance.FiveMiles: false, Filters.eDistance.TwentyMiles: false]
    var distanceText: [Filters.eDistance: String] = [Filters.eDistance.Auto: "Auto", Filters.eDistance.Point3Mile: "0.3 miles", Filters.eDistance.OneMile: "1 mile", Filters.eDistance.FiveMiles: "5 miles", Filters.eDistance.TwentyMiles: "20 miles"]
    var categoryState: [Filters.eCategory: Bool] = [Filters.eCategory.japanese: false, Filters.eCategory.korean: false, Filters.eCategory.newamerican: false, Filters.eCategory.seafood: false]
    
    var isDistanceExpanded: Bool = false
    var isSortedByExpanded: Bool = false
    
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
        
        let filterState = Filters(hasDeal: hasDealState, distance: distance, sortBy: sortedBy, categories: categories)
        
        
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
        
        if section == 1 {
            return isDistanceExpanded ? filterSectionLabelsForRow[1].count : 1
            
        }
        
        if section == 2 {
            return isSortedByExpanded ? filterSectionLabelsForRow[2].count : 1
        }
        
        return filterSectionLabelsForRow[section].count
       
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExpandCell", for: indexPath) as! ExpandCell
            cell.delegate = self
            
            if isDistanceExpanded {
                cell.expandLabel.text = filterSectionLabelsForRow[1][indexPath.row]
            } else {
                let newDistance = distanceState.first(where: { (k, v) -> Bool in
                    return v
                })!.key
                cell.expandLabel.text = distanceText[newDistance]
            }
            
            return cell
            
        }
        
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExpandCell", for: indexPath) as! ExpandCell
            cell.delegate = self
            
            if isSortedByExpanded {
                cell.expandLabel.text = filterSectionLabelsForRow[2][indexPath.row]
            } else {
                let newSortedBy = sortedByState.first(where: { (k, v) -> Bool in
                    return v
                })!.key
                cell.expandLabel.text = sortedByText[newSortedBy]
            }
            
            return cell
            
        }
        
        //else regular cells
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
        
        cell.delegate = self
        
        setFilterLabels(cell: cell, section: indexPath.section, row: indexPath.row)
        setFilterValue(cell: cell, section: indexPath.section, row: indexPath.row)
        
        return cell
    
        
        
    }
    
    func expandCell(expandCell: ExpandCell, didTap: Bool) {
        let path = filterTableView.indexPath(for: expandCell)!
        
        switch path.section {
        case 1:
            if isDistanceExpanded {
                //save value and collapse
                setDistanceState(distance: distanceLookup[path.row], newValue: true)
                isDistanceExpanded = false
            } else {
                //expand section
                isDistanceExpanded = true
            }
        case 2:
            if isSortedByExpanded {
                //save value and collapse
                setSortByState(sortBy: sortLookup[path.row], newValue: true)
                isSortedByExpanded = false
            } else {
                //expand section
                isSortedByExpanded = true
            }
        default:
            break
            
        }
        
        
        filterTableView.reloadData()
    }
    
    func setFilterLabels(cell: SwitchCell, section: Int, row: Int) {
        cell.filterLabel.text = filterSectionLabelsForRow[section][row]
    }
    
    func setFilterValue(cell: SwitchCell, section: Int, row: Int) {
        switch section {
        case 0:
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
