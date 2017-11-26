//
//  SignupHoldingViewController.swift
//  PapayaMealPlanner
//
//  Created by Norton Gumbo on 10/23/16.
//  Copyright © 2016 Papaya LC. All rights reserved.
//

import UIKit

class SignupHoldingViewController: UIViewController {
    
    var data: [String: String]?
    
//    let loginButton: FBSDKLoginButton = {
//        let button = FBSDKLoginButton()
//        button.readPermissions = ["email"]
//        return button
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(data!)
        
//        view.addSubview(loginButton)
//        loginButton.center = view.center
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Hide the navigation bar on the this view controller
        self.navigationController?.isNavigationBarHidden = true
    }
    
}
