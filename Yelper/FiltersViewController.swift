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
        let fil = Filters(hasDeal: true, distance: .Five, sortBy: .BestMatch, categories: [.Japanese, .Korean])
        
        delegate?.filtersViewController?(filtersViewController: self, didUpdateFilters: fil)
    }
    
    
    func switchCell(switchCell: SwitchCell, didChangeValue: Bool) {
        
        let path = filterTableView.indexPath(for: switchCell)!
        
        print("switch cell click section \(path.section) row \(path.row)")
    }
    
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            //deal
            return "Deals"
        case 1:
            //distance
            return "Distance"
        case 2:
            //sortby
            return "Sort By"
        case 3:
            //category
            return "Categories"
        default:
            return nil
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            //deal
            return 1
        case 1:
            //distance
            return 5
        case 2:
            //sortby
            return 3
        case 3:
            //category
            return 4
        default:
            return 0
        }
        
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
        
        cell.delegate = self
        
        switch indexPath.section {
        case 0:
            //deal
            return cell
        case 1:
            //distance
            return cell
        case 2:
            //sortby
            return cell
        case 3:
            //category
            return cell
        default:
            return cell
        }
        
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
