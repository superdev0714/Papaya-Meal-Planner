//
//  RecipeViewController.swift
//  PapayaMealPlanner
//
//  Created by Norton Gumbo on 10/14/16.
//  Copyright © 2016 Papaya LC. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController {

    var recipe: Recipe?
    
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    
    @IBOutlet weak var btnIngredients: UIButton!
    @IBOutlet weak var btnInstructions: UIButton!
    @IBOutlet weak var btnNutrition: UIButton!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var swipeView: UIView!
    
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // add nav title
        self.navigationItem.title = "Recipe"
        
        // Sets up the views for the tabs
        setupView()
        
        let url = recipe?.imageUrl
        recipeName.text = recipe?.name
        
        if (url != ""){
            imageFromServerURL(urlString: url!)
        }
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeUp))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.view.addGestureRecognizer(swipeUp)
        
        let swipeUp1 = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeUp))
        swipeUp1.direction = UISwipeGestureRecognizerDirection.up
        self.swipeView.addGestureRecognizer(swipeUp1)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeUp))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipeDown)
    }
    
    func respondToSwipeUp(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.up:
                print("Swiped up")
                self.swipeView.isHidden = true
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.topConstraint.constant = 0.0
                    self.view.layoutIfNeeded()
                })
            case UISwipeGestureRecognizerDirection.down:
                print("Swiped down")
                
                self.swipeView.isHidden = false
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.topConstraint.constant = 251.0
                    self.view.layoutIfNeeded()
                })
                
            default:
                break
            }
        }
    }
    
    
    
    func imageFromServerURL(urlString: String) {
        
        URLSession.shared.dataTask(with: URL(string: urlString)!, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async{
                let image = UIImage(data: data!)
                self.recipeImage.image = image
            }
            
        }).resume()
    }
    
    private func setupView(){
        
        let pinkColor = UIColor.init(colorLiteralRed: 210/255.0, green: 57/255.0, blue: 101/255.0, alpha: 1.0)
        self.btnIngredients.layer.borderColor = pinkColor.cgColor
        self.btnInstructions.layer.borderColor = pinkColor.cgColor
        self.btnNutrition.layer.borderColor = pinkColor.cgColor
        
        self.btnIngredients.layer.borderWidth = 1.0
        self.btnInstructions.layer.borderWidth = 1.0
        self.btnNutrition.layer.borderWidth = 1.0
        
        self.btnIngredients.layer.cornerRadius = 20;
        self.btnInstructions.layer.cornerRadius = 20;
        self.btnNutrition.layer.cornerRadius = 20;
        
        selectedIndex = 0
        updateView()
    }
    
    
    
    private lazy var IngredientsController: IngredientsTableViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        let viewController = storyboard.instantiateViewController(withIdentifier: "IngredientsController") as! IngredientsTableViewController
        viewController.recipe = self.recipe
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private lazy var InstructionsController: InstructionsTableViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        let viewController = storyboard.instantiateViewController(withIdentifier: "InstructionsController") as! InstructionsTableViewController
        viewController.recipe = self.recipe
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private lazy var NutritionController: NutritionTableViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        let viewController = storyboard.instantiateViewController(withIdentifier: "NutritionController") as! NutritionTableViewController
        viewController.recipe = self.recipe
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private func add(asChildViewController viewController: UIViewController){
        // Add Child View Controller
        addChildViewController(viewController)
        
        // Add Child View as Subview
        //view.addSubview(viewController.view)
        containerView.addSubview(viewController.view)
        
        // Configure Child View
        let rect = containerView.frame;
        viewController.view.frame = CGRect(x: 0 , y: 0, width: rect.size.width, height: rect.size.height)
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParentViewController: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController){
        // Notify Child View Controller
        viewController.willMove(toParentViewController: nil)
        
        //Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParentViewController()
    }
    
    @IBAction func onIngredients(_ sender: AnyObject) {
        
        let pinkColor = UIColor.init(colorLiteralRed: 210/255.0, green: 57/255.0, blue: 101/255.0, alpha: 1.0)
        btnIngredients.backgroundColor = pinkColor
        btnInstructions.backgroundColor = UIColor.clear
        btnNutrition.backgroundColor = UIColor.clear
        
        btnIngredients.setTitleColor(UIColor.white, for: UIControlState.normal)
        btnInstructions.setTitleColor(UIColor.black, for: UIControlState.normal)
        btnNutrition.setTitleColor(UIColor.black, for: UIControlState.normal)
        
        selectedIndex = 0
        updateView()
    }
    
    @IBAction func onInstructions(_ sender: AnyObject) {
        let pinkColor = UIColor.init(colorLiteralRed: 210/255.0, green: 57/255.0, blue: 101/255.0, alpha: 1.0)
        btnIngredients.backgroundColor = UIColor.clear
        btnInstructions.backgroundColor = pinkColor
        btnNutrition.backgroundColor = UIColor.clear
        
        btnIngredients.setTitleColor(UIColor.black, for: UIControlState.normal)
        btnInstructions.setTitleColor(UIColor.white, for: UIControlState.normal)
        btnNutrition.setTitleColor(UIColor.black, for: UIControlState.normal)
        
        selectedIndex = 1
        updateView()
    }
    
    
    @IBAction func onNutrition(_ sender: AnyObject) {
        let pinkColor = UIColor.init(colorLiteralRed: 210/255.0, green: 57/255.0, blue: 101/255.0, alpha: 1.0)
        btnIngredients.backgroundColor = UIColor.clear
        btnInstructions.backgroundColor = UIColor.clear
        btnNutrition.backgroundColor = pinkColor
        
        btnIngredients.setTitleColor(UIColor.black, for: UIControlState.normal)
        btnInstructions.setTitleColor(UIColor.black, for: UIControlState.normal)
        btnNutrition.setTitleColor(UIColor.white, for: UIControlState.normal)
        
        selectedIndex = 2
        updateView()
    }
    
    private func updateView(){
        if selectedIndex == 0 {
            remove(asChildViewController: InstructionsController)
            add(asChildViewController: IngredientsController)
        }
        if selectedIndex == 1 {
            remove(asChildViewController: IngredientsController)
            add(asChildViewController: InstructionsController)
        }
        
        if selectedIndex == 2 {
            remove(asChildViewController: InstructionsController)
            add(asChildViewController: NutritionController)
        }
    }


}
