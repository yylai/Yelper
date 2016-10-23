//
//  SwitchCell.swift
//  Yelper
//
//  Created by YINYEE LAI on 10/22/16.
//  Copyright © 2016 Yin Yee Lai. All rights reserved.
//

import UIKit

@objc protocol SwitchCellDelegate {
    @objc optional func switchCell(switchCell: SwitchCell, didChangeValue: Bool)
}

class SwitchCell: UITableViewCell {
    
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var filterSwitch: UISwitch!
    
    weak var delegate: SwitchCellDelegate?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onValueChange(_ sender: AnyObject) {
        
        delegate?.switchCell?(switchCell: self, didChangeValue: filterSwitch.isOn)
    }
}
