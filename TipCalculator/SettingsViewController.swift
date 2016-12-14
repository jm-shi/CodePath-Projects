//
//  SettingsViewController.swift
//  Tip Calculator
//
//  Created by admin on 12/12/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.tintColor = UIColor.red
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Load default tip percentage
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let defaults = UserDefaults.standard
        let tipIndex = defaults.integer(forKey: "default_tip_index")
        tipControl.selectedSegmentIndex = tipIndex;
    }
    
    // Update tip percentage upon modifying segmented control
    @IBAction func changeTipVal(_ sender: Any) {
        let defaults = UserDefaults.standard
        let tipIndex = tipControl.selectedSegmentIndex
        defaults.set(tipIndex, forKey: "default_tip_index")
        defaults.synchronize()
    }
    
}
