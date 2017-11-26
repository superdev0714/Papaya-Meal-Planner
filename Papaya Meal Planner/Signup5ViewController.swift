//
//  Signup5ViewController.swift
//  PapayaMealPlanner
//
//  Created by Norton Gumbo on 10/23/16.
//  Copyright © 2016 Papaya LC. All rights reserved.
//

import UIKit

class Signup5ViewController: UIViewController, UITextFieldDelegate {
    
    var data: [String: String]?
    
    @IBOutlet weak var kgTextField: UITextField!
    @IBOutlet weak var poundTextField: UITextField!
    @IBOutlet weak var unitSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kgTextField.isHidden = true
        poundTextField.becomeFirstResponder()
        print(data!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Remove back button navigation bar
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
    
    func calcKgWeight(weight: Int) -> Double{
        
        let kg = Double(weight) * 0.4536
        return kg
    }
    
    @IBAction func unitChanged(_ sender: UISegmentedControl) {
        switch unitSegmentedControl.selectedSegmentIndex{
        case 0:
            kgTextField.isHidden = true
            poundTextField.isHidden = false
        case 1:
            kgTextField.isHidden = false
            poundTextField.isHidden = true
        default:
            break
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "step5ToStep6":
                let pound = Int(poundTextField.text!)
                data?["weight"] = String(calcKgWeight(weight: pound!))
                let signup6VC = segue.destination as! Signup6ViewController
                signup6VC.data = data
            default: break
            }
        }
    }

}
