//
//  ViewController.swift
//  Tip Calculator
//
//  Created by Jamie Shi on 12/11/16.
//  Copyright © 2016 Jamie Shi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    @IBOutlet weak var tipSlider: UISlider!
    @IBOutlet weak var tipSliderLabel: UILabel!
    
    @IBOutlet weak var tipName: UILabel!
    @IBOutlet weak var totalName: UILabel!
    
    @IBOutlet weak var peopleCount: UILabel!
    @IBOutlet weak var billPerPerson: UILabel!
    @IBOutlet weak var peopleStepper: UIStepper!
    
    @IBOutlet weak var pinkBackground: UILabel!
    @IBOutlet weak var redBackground: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Always show keyboard
        billField.becomeFirstResponder()
        
        self.title = "Tipper"
        view.tintColor = UIColor.red
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Remember bill amount across app restarts (if < 10 mins)
        let previousUseTime = defaults.integer(forKey: "previousUse")
        let currentUseTime = Int(NSDate().timeIntervalSince1970)
        if (currentUseTime - previousUseTime < 600) {
            let previousBillAmount = defaults.double(forKey: "bill")
            let tipIndex = defaults.integer(forKey: "defaultTipIndex")
            
            if previousBillAmount - Double(Int(previousBillAmount)) == 0 {
                if Double(billField.text!) != Double(0) && billField.text! != "" {
                    billField.text = String(Int(previousBillAmount))
                }
                else {
                    billField.text = String("")
                }
            }
            else {
                if Double(billField.text!) != Double(0) && billField.text! != "" {
                    billField.text = String(previousBillAmount)
                }
                else {
                    billField.text = String("")
                }
            }
            
            if !defaults.bool(forKey: "useControl") {
                tipSlider.value = Float(defaults.double(forKey: "defaultTipPercent")*100)
                tipSliderLabel.text = defaults.string(forKey: "tipSliderLabelText")
            }
            
            modifyResults(tipIndex: tipIndex, bill: previousBillAmount,
                          useSlider: false)
            toRelevantScreen()
        }
        else {
            toDefaultScreen();
        }
    }
    
    func showControlOrSlider() {
        let useSegmentedControl = self.defaults.bool(forKey: "useControl")
        if useSegmentedControl {
            self.tipSlider.isEnabled = false
            self.tipSlider.alpha = 0
            self.tipSliderLabel.alpha = 0
            self.tipControl.alpha = 1
            self.tipControl.isEnabled = true
        }
        else {
            self.tipSlider.isEnabled = true
            self.tipSlider.alpha = 1
            self.tipSliderLabel.alpha = 1
            self.tipControl.alpha = 0
            self.tipControl.isEnabled = false
        }
    }
    
    func toDefaultScreen() {
        UIView.animate(withDuration: 0.4, animations: {
            self.tipLabel.alpha = 0
            self.totalLabel.alpha = 0
            self.peopleCount.alpha = 0
            self.billPerPerson.alpha = 0
            self.billField.placeholder = NumberFormatter().currencySymbol
            self.showControlOrSlider()
        })
    }
    
    func toCalculatingScreen() {
        UIView.animate(withDuration: 0.4, animations: {
            self.tipLabel.alpha = 1
            self.totalLabel.alpha = 1
            self.peopleCount.alpha = 1
            self.billPerPerson.alpha = 1
            self.showControlOrSlider()
        })
    }
    
    func toRelevantScreen() {
        if billField.text == "" {
            toDefaultScreen();
        }
        else {
            toCalculatingScreen();
        }
    }
    
    func modifyResults(tipIndex: Int, bill: Double, useSlider: Bool) {
        var tip = 0.0
        
        if !useSlider {
            let tipPercentages = [0.1, 0.15, 0.2, 0.25]
            tip = bill * tipPercentages[tipIndex]
        }
        else {
            let tipPercent = tipSliderLabel.text
            let truncatedTipPercent = tipPercent?.substring(to: (tipPercent?.index(before: (tipPercent?.endIndex)!))!)
            let tipPercentAsDouble = Double(truncatedTipPercent!)!/100
            tip = bill * tipPercentAsDouble
        }
        
        let total = bill + tip
        
        tipControl.selectedSegmentIndex = tipIndex;
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        tipLabel.text = formatter.string(from: tip as NSNumber)
        totalLabel.text = formatter.string(from: total as NSNumber)
        
        let numPeople = peopleStepper.value
        peopleCount.text = String(Int(numPeople))
        billPerPerson.text = formatter.string(from: total/numPeople as NSNumber)
        billPerPerson.text = billPerPerson.text! + "/person"
        
        let currentTime = Int(NSDate().timeIntervalSince1970)
        defaults.set(tipIndex, forKey: "defaultTipIndex")
        defaults.set(currentTime, forKey: "previousUse")
        defaults.set(bill, forKey: "bill")
        defaults.set(numPeople, forKey: "peopleCount")
        
        defaults.synchronize()
    }
    
    @IBAction func splitBill(_ sender: Any) {
        modifyResults(tipIndex: tipControl.selectedSegmentIndex,
                      bill: Double(billField.text!) ?? 0, useSlider: false)
    }
    
    // Update tip percentage upon modifying segmented control
    @IBAction func calculateTip(_ sender: AnyObject) {
        let tipIndex = tipControl.selectedSegmentIndex
        toRelevantScreen()
        
        let billAsDouble = Double(billField.text!) ?? 0
        if billAsDouble == 0 || billAsDouble > Double(999999999) {
            billField.text = String("")
        }
        
        modifyResults(tipIndex: tipIndex, bill: Double(billField.text!) ?? 0,
                      useSlider: false)
    }
    
    // Update tip percentage upon modifying slider
    @IBAction func calculateTipWithSlider(_ sender: Any) {
        let tipIndex = tipControl.selectedSegmentIndex
        toRelevantScreen()
        
        var tipPercentage = Int(tipSlider.value)
        let stepSize = defaults.double(forKey: "stepValue")
        tipPercentage = tipPercentage - tipPercentage % Int(stepSize)
        tipSliderLabel.text = String(tipPercentage) + "%"
        
        defaults.set(Double(tipPercentage)/100, forKey: "defaultTipPercent")
        defaults.set(tipSliderLabel.text, forKey: "tipSliderLabelText")
        defaults.synchronize()
        
        modifyResults(tipIndex: tipIndex, bill: Double(billField.text!) ?? 0,
                      useSlider: true)
    }
    
}

