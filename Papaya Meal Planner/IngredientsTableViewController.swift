//
//  IngredientsTableViewController.swift
//  PapayaMealPlanner
//
//  Created by Norton Gumbo on 11/27/16.
//  Copyright © 2016 Papaya LC. All rights reserved.
//

import UIKit

class IngredientsTableViewController: UITableViewController {
    
    var recipe: Recipe?
    var ingredients: [[String]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("I got instantiated 1")
        
        // get the recipe ID
        let recipeId = recipe?.recipeId
        
        // get recipe Ingredients
        getRecipeIngredients(id: recipeId!, completion: { results in
            self.ingredients = [[String]]()
            
            for result in results {
                let ingredientText = result["raw_text"]! as! String
                self.ingredients?.append([ingredientText])
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        
        self.tableView.separatorColor = UIColor.clear
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = ingredients?.count ?? 0
        return count + 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        
        if row == 0 {
            
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "ingredientsHeaderCell", for: indexPath)
            
            return headerCell;
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientsCell", for: indexPath) as! IngredientsTableViewCell
        
        let singleIngredient = ingredients?[row-1]
        cell.lblTitle?.text = singleIngredient?.first
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
