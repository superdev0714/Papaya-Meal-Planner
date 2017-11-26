//
//  FavoritesViewController.swift
//  Papaya Meal Planner
//
//  Created by Norton Gumbo on 12/19/16.
//  Copyright © 2016 Papaya LC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftKeychainWrapper
import SwiftyJSON

class FavoritesViewController: UITableViewController {

    var favoriteRecipes: [Recipe] = [Recipe]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       loadFavoriteRecipes()
    }
    
    func loadFavoriteRecipes() {
        // Check for token
        guard let token = KeychainWrapper.standard.string(forKey: "authToken") else {
            return
        }
        
        let headers: HTTPHeaders = ["authorization": "Token \(token)", "Content-Type": "application/json"]
        
        getFavorites(headers: headers) { response in
            switch response.result {
            case .success:
                guard let data = response.result.value else {
                    // Show error if we don't have any data
                    let alert = UIAlertController(title: "", message: "Network Error. Try Again.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                    return
                }
                
                // Parse JSON
                let json = JSON(data: data),
                results = json["results"]
                
                for result in results {
                    let recipeId = result.1["recipe"].intValue
                    
                    self.getRecipes(recipeId: recipeId) { recipe in
                        self.favoriteRecipes.append(recipe)
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
                
            case .failure:
                let alert = UIAlertController(title: "Invalid Login Information", message: "Please check your email or password", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    
    }
    
    func getRecipes(recipeId: Int, completion: @escaping (_ result: Recipe) -> Void) {
        // Check for token
        guard let token = KeychainWrapper.standard.string(forKey: "authToken") else {
            return
        }
        
        let headers: HTTPHeaders = ["authorization": "Token \(token)", "Content-Type": "application/json"]
        
        getMealRecipes(headers: headers, id: recipeId) { response in
            switch response.result {
            case .success:
                guard let data = response.result.value else {
                    // Show error if we don't have any data
                    let alert = UIAlertController(title: "", message: "Network Error. Try Again.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                    return
                }
                
                // Parse JSON
                let json = JSON(data: data),
                results = json["result"],
                url = results["url"].stringValue,
                name = results["name"].stringValue,
                imageAttribution = results["image_attribution"].stringValue,
                description = results["descriptions"].stringValue,
                prepTime = results["prep_time"].stringValue,
                id = results["id"].intValue,
                image = results["image"].stringValue,
                cookTime = results["cook_time"].stringValue,
                servings = results["servings"].intValue
                
                // Create Tag object list
                let tagArr:[[String: Any]] = results["tags"].arrayValue.map { $0.dictionaryObject!}
                let tagDict: [String: Any] = ["tags": tagArr]
                let tags: [Tag] = try! tagDict.value(for: "tags")
                
                // Create Instruction object list
                let instructionArr:[[String: Any]] = results["instructions"].arrayValue.map { $0.dictionaryObject!}
                let instructionDict: [String: Any] = ["instructions": instructionArr]
                let instructions: [Instruction] = try! instructionDict.value(for: "instructions")
                
                let recipe = Recipe(name: name, imageUrl: image, description: description, tags: tags, prepTime: prepTime, cookTime: cookTime, recipeId: id, servings: servings, url: url, instructions: instructions, imageAttribution: imageAttribution)
                
                completion(recipe)
                
            case .failure:
                let alert = UIAlertController(title: "Invalid Login Information", message: "Please check your email or password", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func imageFromServerURL(urlString: String, completion: @escaping (_ data: Data) -> Void) {
        URLSession.shared.dataTask(with: URL(string: urlString)!, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error!)
                return
            }
            
            completion(data!)
            
        }).resume()
    }
    
    func UIViewShadow(view: UIView) {
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 2
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteRecipes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoritesCell", for: indexPath) as! favoritesTableViewCell
        cell.recipeNameLabel.text = favoriteRecipes[indexPath.row].name
        UIViewShadow(view: cell.recipeBorderView)
        
        let imageUrl = favoriteRecipes[indexPath.row].imageUrl
        
        if (imageUrl != ""){
            // Get recipe image
            imageFromServerURL(urlString: imageUrl, completion: { data in
                DispatchQueue.main.async{
                    let image = UIImage(data: data)
                    cell.recipeImageView.image = image
                }
            })
        }
        
        return cell
    }

}
