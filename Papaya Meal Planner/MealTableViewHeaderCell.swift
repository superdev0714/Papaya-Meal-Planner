//
//  MealTableViewHeaderCell.swift
//  PapayaMealPlanner
//
//  Created by Norton Gumbo on 11/23/16.
//  Copyright © 2016 Papaya LC. All rights reserved.
//

import UIKit

class MealTableViewHeaderCell: UITableViewCell {

    @IBOutlet weak var numCalories: UILabel!
    @IBOutlet weak var mealName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
