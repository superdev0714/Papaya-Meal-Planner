//
//  WalkthroughContentViewController.swift
//  PapayaMealPlanner
//
//  Created by Norton Gumbo on 11/4/16.
//  Copyright © 2016 Papaya LC. All rights reserved.
//

import UIKit

protocol SkipDelegate {
    func skip()
}

class WalkthroughContentViewController: UIViewController {

    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    
    var delegate: SkipDelegate?
    
    var pageIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.pageIndex = 0
        
        
    }
    
    @IBAction func onSkip(_ sender: AnyObject) {
        
        self.delegate?.skip()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.pageIndex == 0 {
            setFirstView()
        } else {
            setSecondView()
        }
        
    }
    
    public func setFirstView()
    {
        self.firstView.isHidden = false
        self.secondView.isHidden = true
    }
    
    public func setSecondView()
    {
        self.firstView.isHidden = true
        self.secondView.isHidden = false
    }

}
