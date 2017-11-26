//
//  CaloriesTableViewCell.swift
//  PapayaMealPlanner
//
//  Created by Kevin on 12/8/16.
//  Copyright © 2016 Papaya LC. All rights reserved.
//

import UIKit

class CaloriesTableViewCell: UITableViewCell {

    @IBOutlet weak var targetCaloriesLabel: UILabel!
    @IBOutlet weak var currentCaloriesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
