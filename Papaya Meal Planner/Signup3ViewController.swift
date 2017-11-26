//
//  Signup3ViewController.swift
//  PapayaMealPlanner
//
//  Created by Norton Gumbo on 10/23/16.
//  Copyright © 2016 Papaya LC. All rights reserved.
//

import UIKit

class Signup3ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var dateTextField: UITextField!
    
    var data: [String: String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateTextField.delegate = self
        dateTextField.becomeFirstResponder()
        print(data!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Remove back button navigation bar
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePickerMode.date
        textField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(Signup3ViewController.datePickerChanged(sender:)), for: .valueChanged)
        
    }
    
    func datePickerChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        dateTextField.text = formatter.string(from: sender.date)
        sender.isHidden = true
        dateTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if ((dateTextField.text) != nil) {
            data?["date_of_birth"] = dateTextField.text
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "step3ToStep4":
                let signup4VC = segue.destination as! Signup4ViewController
                signup4VC.data = data
            default: break
            }
        }
    }
    
}
