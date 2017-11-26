//
//  MealPlanViewController.swift
//  PapayaMealPlanner
//
//  Created by Norton Gumbo on 10/8/16.
//  Copyright © 2016 Papaya LC. All rights reserved.
//

import UIKit
import EZLoadingActivity
import SwiftKeychainWrapper
import Alamofire
import SwiftyJSON
import Marshal

class MealPlanViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var mealPlanTableView: UITableView!
    @IBOutlet weak var recipeImageFrame: UIView!
    
    var mealPlan: MealPlan?
    
    var meals: [[Meal]] = [[Meal]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // change controller background color
        mealPlanTableView.backgroundColor = UIColor(red: 254.0 / 255, green: 250.0 / 255, blue: 252.0 / 255, alpha: 1)
        
        // load meal plan
        loadMealPlan()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Remove back button navigation bar
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
    
    func loadMealPlan() {
        // Check for token
        guard let token = KeychainWrapper.standard.string(forKey: "authToken") else {
            return
        }
        
        let headers: HTTPHeaders = ["authorization": "Token \(token)", "Content-Type": "application/json"]
        
        getMealPlan(headers: headers) { response in
            switch response.result {
            case .success:
                guard let data = response.data else {
                    // Show error if we don't have any data
                    let alert = UIAlertController(title: "", message: "Network Error. Try Again.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                    return
                }
                
                let json = JSON(data: data),
                results = json["results"][0],
                mealIds = results["meal"].arrayObject,
                name = results["name"].string,
                id = results["id"].intValue,
                user = results["user"].intValue
                
                // Create Nutrient object list
                let nutrientArr:[[String: Any]] = results["nutrients"].arrayValue.map { $0.dictionaryObject!}
                let nutrientDict: [String: Any] = ["nutrients": nutrientArr]
                let nutrients: [Nutrient] = try! nutrientDict.value(for: "nutrients")
                
                self.mealPlan = MealPlan(user: user, id: id, name: name, nutrients: nutrients)
                
                self.getNutrion(id: id, type: "mealPlan") { result in
                    self.mealPlan?.nutritionLabel = result
                }
                
                for mealId in mealIds! {
                    self.getMeals(mealId: mealId as! Int)
                }
                
            case .failure:
                let alert = UIAlertController(title: "Invalid Login Information", message: "Please check your email or password", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func getMeals(mealId: Int) {
        // Check for token
        guard let token = KeychainWrapper.standard.string(forKey: "authToken") else {
            return
        }
        
        let headers: HTTPHeaders = ["authorization": "Token \(token)", "Content-Type": "application/json"]
        
        getMealPlanMeals(headers: headers, id: mealId) { response in
            switch response.result {
            case .success:
                guard let data = response.result.value else {
                    // Show error if we don't have any data
                    let alert = UIAlertController(title: "", message: "Network Error. Try Again.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                    return
                }
                
                let json = JSON(data: data),
                results = json["result"],
                name = results["name"].stringValue,
                user = results["user"].intValue,
                id = results["id"].intValue,
                saved = results["saved"].boolValue
                
                let recipeIds: [[String: Any]] = results["recipes"].arrayValue.map { $0.dictionaryObject!}
            
                // Create a meal object
                let meal = Meal(id: id, name: name, user: user, saved: saved)
                
                // Get meal nutrition Info
                self.getNutrion(id: mealId, type: "meal") { result in
                    meal.nutritionLabel = result
                }
                
                // Update meals when we get more meals
                self.meals.append([meal])
                
                // Get meal recipes
                for recipeId in recipeIds {
                    let recipe = recipeId["recipe"]
                    // Servings the user should eat
                    let servings = recipeId["servings"]
                    
                    self.getRecipes(recipeId: recipe as! Int){ result in
                        result.recommenderServing = servings as! Int
                        meal.recipes.append(result)
                        
                        if meal.recipes.count == recipeIds.count {
                            DispatchQueue.main.async {
                                self.mealPlanTableView.reloadData()
                            }
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
    
    func getNutrion(id: Int, type: String, completion: @escaping (_ result: NutritionLabel) -> Void) {
        // Check for token
        guard let token = KeychainWrapper.standard.string(forKey: "authToken") else {
            return
        }
        
        let headers: HTTPHeaders = ["authorization": "Token \(token)", "Content-Type": "application/json"]
        
        getNutritionInfo(headers: headers, id: id, type: type) { response in
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
                let json = JSON(data: data)
                let nutrientArr = json["result"].dictionaryObject!
                let nutrientDict: [String: Any] = ["nutrients": nutrientArr]
                let nutritionLabel: NutritionLabel = try! nutrientDict.value(for: "nutrients")
                completion(nutritionLabel)
                
            case .failure:
                let alert = UIAlertController(title: "Invalid Login Information", message: "Please check your email or password", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func createNewMealPlan(_ sender: Any) {
        // Check for token
        guard let token = KeychainWrapper.standard.string(forKey: "authToken") else {
            return
        }
        
        let headers: HTTPHeaders = ["authorization": "Token \(token)", "Content-Type": "application/json"]
        let parameters: Parameters = ["action_type": "create_meal_plan"]
        
        EZLoadingActivity.show("Cheffin' a new meal plan...", disableUI: true)
        
        generateMealPlan(parameters: parameters, headers: headers) { response in
            switch response.result {
                case .success:
                    self.meals.removeAll()
                    self.mealPlan = nil
                    self.loadMealPlan()
                    
                    EZLoadingActivity.hide()
                    
                    // Sends notification to grocery page to update
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadGroceryNotification"), object: nil)
                    
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        // Adds calories section
        return meals.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 1
        
        if section != 0 {
            numberOfRows = meals[section-1].first!.recipes.count
        }
        
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CaloriesCell", for: indexPath) as! CaloriesTableViewCell
            
            if let plan = mealPlan {
                let targetCalorieNutrient = plan.nutrients.first(where:{$0.name == "target_energy_kcal"})
                cell.targetCaloriesLabel.text = "\(Int(Double(targetCalorieNutrient!.quantity)!))"
                cell.currentCaloriesLabel.text = "\(plan.nutritionLabel.energyKcal)"
            }
            
            cell.selectionStyle = .none
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! mealTableViewCell
        
        cell.recipeName.text = meals[indexPath.section-1].first!.recipes[indexPath.row].name
        let numServings = meals[indexPath.section-1].first!.recipes[indexPath.row].recommenderServing
        
        if (numServings == 1) {
            cell.recipeServing.text = "\(numServings) Serving"
        } else {
            cell.recipeServing.text = "\(numServings) Servings"
        }
        
        UIViewShadow(view: cell.recipeBorder)
        
        let imageUrl = meals[indexPath.section-1].first!.recipes[indexPath.row].imageUrl
        
        if (imageUrl != ""){
            // Get recipe image
            imageFromServerURL(urlString: imageUrl, completion: { data in
                DispatchQueue.main.async{
                    let image = UIImage(data: data)
                    cell.recipeImage.image = image
                }
            })
        }
        
        // Remove selection highlight
        cell.selectionStyle = .none
        
        return cell
    }
    
    func UIViewShadow(view: UIView) {
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! MealTableViewHeaderCell
        
        // Label for the meal name
        let meal = meals[section-1].first!
        let mealText = meal.name.uppercased()
        cell.mealName.text = mealText
        cell.mealName.textColor = UIColor(red: 203.0 / 255.0, green: 24.0/255.0, blue: 75.0 / 255.0, alpha: 1.0)
        
        //label for the meal calories
        cell.numCalories.text = "\(meal.nutritionLabel.energyKcal)"
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = 110.0
        if indexPath.section == 0 {
            height = 179
        }
        return CGFloat(height)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var height = 50.0
        if section == 0 {
            height = 0
        }
        return CGFloat(height)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
                case "mealplanToRecipe":
                    let recipeVC = segue.destination as! RecipeViewController
                    if let indexPath = self.mealPlanTableView.indexPath(for: sender as! UITableViewCell) {
                        recipeVC.recipe = getRecipeAtIndexPath(indexPath: indexPath)
                    }
                
                default: break
            }
        }
    }
    
    func getRecipeAtIndexPath(indexPath: IndexPath) -> Recipe {
        let meal = meals[indexPath.section-1].first!
        return meal.recipes[indexPath.row]
    }

}
