//
//  Signup4ViewController.swift
//  PapayaMealPlanner
//
//  Created by Norton Gumbo on 10/23/16.
//  Copyright © 2016 Papaya LC. All rights reserved.
//

import UIKit

class Signup4ViewController: UIViewController, UITextFieldDelegate {
    
    var data: [String: String]?
    
    @IBOutlet weak var cmTextField: UITextField!
    @IBOutlet weak var feetTextField: UITextField!
    @IBOutlet weak var inchesTextField: UITextField!
    @IBOutlet weak var unitSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cmTextField.isHidden = true
        feetTextField.becomeFirstResponder()
        print(data!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Remove back button navigation bar
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
    
    func calcCMHeight(heightFeet: Int, heightInches: Int) -> Double{
        let totalInches = (heightFeet * 12) + heightInches
        
        let cm = Double(totalInches) * 2.54
        return cm
    }
    
    @IBAction func unitChange(_ sender: UISegmentedControl) {
        switch unitSegmentedControl.selectedSegmentIndex{
            case 0:
                cmTextField.isHidden = true
                feetTextField.isHidden = false
                inchesTextField.isHidden = false
            case 1:
                cmTextField.isHidden = false
                feetTextField.isHidden = true
                inchesTextField.isHidden = true
            default:
                break
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "step4ToStep5":
                let feet = Int(feetTextField.text!)
                let inches = Int(inchesTextField.text!)
                data?["height"] = String(calcCMHeight(heightFeet: feet!, heightInches: inches!))
                let signup5VC = segue.destination as! Signup5ViewController
                signup5VC.data = data
            default: break
            }
        }
    }

}
