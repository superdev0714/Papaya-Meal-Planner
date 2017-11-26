//
//  Signup7ViewController.swift
//  PapayaMealPlanner
//
//  Created by Norton Gumbo on 10/23/16.
//  Copyright © 2016 Papaya LC. All rights reserved.
//

import UIKit

class Signup7ViewController: UIViewController {

    var data: [String: String]?
    
    @IBOutlet weak var numMealsTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(data!)
    }
    
//    @IBAction func goToNextPage(_ sender: UIButton) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "SignupHoldingController")
//        self.present(vc, animated: true, completion: nil)
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let meals = numMealsTextField.text
        data?["num_meals"] = meals
        let signupHoldingVC = segue.destination as! SignupHoldingViewController
        signupHoldingVC.data = data
    }

}
