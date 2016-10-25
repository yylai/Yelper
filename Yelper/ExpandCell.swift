//
//  ExpandCell.swift
//  Yelper
//
//  Created by YINYEE LAI on 10/24/16.
//  Copyright © 2016 Yin Yee Lai. All rights reserved.
//

import UIKit

@objc protocol ExpandCellDelegate {
    @objc optional func expandCell(expandCell: ExpandCell, didTap: Bool)
}

class ExpandCell: UITableViewCell {

    @IBOutlet weak var expandButton: UIButton!
    @IBOutlet weak var expandLabel: UILabel!
    
     weak var delegate: ExpandCellDelegate?
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        expandButton.setTitle("", for: .normal)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onExpand(_ sender: AnyObject) {
        print("expand")
        delegate?.expandCell?(expandCell: self, didTap: true)
    }
}
