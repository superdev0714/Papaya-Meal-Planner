//
//  NutritionTableViewController.swift
//  PapayaMealPlanner
//
//  Created by Norton Gumbo on 11/27/16.
//  Copyright © 2016 Papaya LC. All rights reserved.
//

import UIKit

class NutritionTableViewController: UITableViewController {

    var recipe: Recipe?
    var nutritionInfo: [String : AnyObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // get the recipe ID
        let recipeId = recipe?.recipeId
        
        print("I got instantiated 3")
        
        getRecipeNutritionInfo(id: recipeId!, completion: { results in
            self.nutritionInfo = [String : AnyObject]()
            
            let nutrition: [String: AnyObject] = ["Calories": results["energy_kcal"]!, "Total Fat": results["total_fat"]!, "Cholesterol": results["cholesterol"]!, "Sodium": results["sodium"]!, "Total Carbohydrate": results["total_carbohydrate"]!, "Dietary Fiber": results["dietary_fiber"]!, "Protein": results["protein"]!]
            
            
            self.nutritionInfo = nutrition
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        })
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = nutritionInfo?.count ?? 0
        return count+1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        
        if row == 0 {
            
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "nutritionFactsHeaderCell", for: indexPath)
            
            return headerCell;
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "nutritionFactsCell", for: indexPath) as! NutritionTableViewCell
        
        let keys = Array((self.nutritionInfo?.keys)!)
        let values = Array((self.nutritionInfo?.values)!)
        cell.lblTitle?.text = keys[row-1]
        let detail = String.init(format: "%.2f", values[row-1] as! Float)
        cell.lblDetail.text = detail
        
        
        if row == 1 {
            let pinkColor = UIColor.init(colorLiteralRed: 210/255.0, green: 57/255.0, blue: 101/255.0, alpha: 1.0)
            cell.imgPoint.image = UIImage(named: "point_green")
            cell.lblTitle.textColor = pinkColor
            cell.lblDetail.textColor = pinkColor
        }
        
        
        return cell
    }

    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    

}
