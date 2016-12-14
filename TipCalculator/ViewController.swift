//
//  ViewController.swift
//  Tip Calculator
//
//  Created by admin on 12/11/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    @IBOutlet weak var tipName: UILabel!
    @IBOutlet weak var totalName: UILabel!
    
    @IBOutlet weak var pinkBackground: UILabel!
    @IBOutlet weak var redBackground: UILabel!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "Tip Calculator"
        view.tintColor = UIColor.red
        
        let defaults = UserDefaults.standard
        defaults.set(0, forKey: "default_tip_index")
        
        self.billField.alpha = 1
        self.billField.center.y = self.view.bounds.height/2.6
        self.tipLabel.alpha = 0
        self.totalLabel.alpha = 0
        self.tipControl.alpha = 0
        self.tipName.alpha = 0
        self.totalName.alpha = 0
        self.redBackground.alpha = 0
        self.billField.placeholder = "$"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTap(_ sender: Any) {
    }
    
    // Load default tip percentage
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Always show keyboard
        billField.becomeFirstResponder()
        
        let defaults = UserDefaults.standard
        let tipIndex = defaults.integer(forKey: "default_tip_index")
        tipControl.selectedSegmentIndex = tipIndex;
        
        let tipPercentages = [0.1, 0.15, 0.2]
        let bill = Double(billField.text!) ?? 0
        let tip = bill * tipPercentages[tipIndex]
        let total = bill + tip
        
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
        
    }
    
    // Update tip percentage upon modifying segmented control
    @IBAction func calculateTip(_ sender: AnyObject) {
        
        let defaults = UserDefaults.standard
        let tipIndex = tipControl.selectedSegmentIndex
        defaults.set(tipIndex, forKey: "default_tip_index")
        defaults.synchronize()
        
        if billField.text == "" {
            UIView.animate(withDuration: 0.4, animations: {
                self.billField.alpha = 1
                self.billField.center.y = self.view.bounds.height/2.6
                self.tipLabel.alpha = 0
                self.totalLabel.alpha = 0
                self.tipControl.alpha = 0
                self.tipName.alpha = 0
                self.totalName.alpha = 0
                self.redBackground.alpha = 0
                self.billField.placeholder = "$"
            })
        }
        else {
            UIView.animate(withDuration: 0.4, animations: {
                self.billField.center.y = self.view.bounds.height/4.8
                self.tipLabel.alpha = 1
                self.totalLabel.alpha = 1
                self.tipControl.alpha = 1
                self.tipName.alpha = 1
                self.totalName.alpha = 1
                self.redBackground.alpha = 0.55
            })
        }
        
        let tipPercentages = [0.1, 0.15, 0.2]
        let bill = Double(billField.text!) ?? 0
        let tip = bill * tipPercentages[tipIndex]
        let total = bill + tip
        
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
    }
    
}

