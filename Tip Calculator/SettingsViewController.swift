//
//  SettingsViewController.swift
//  Tip Calculator
//
//  Created by Jamie Shi on 12/12/16.
//  Copyright © 2016 Jamie Shi. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    @IBOutlet weak var controlSwitch: UISwitch!
    @IBOutlet weak var sliderSwitch: UISwitch!
    
    @IBOutlet weak var tipSlider: UISlider!
    @IBOutlet weak var tipSliderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.tintColor = UIColor.red
        
        // Load default tip percentage for segmented control
        let tipIndex = defaults.integer(forKey: "defaultTipIndex")
        tipControl.selectedSegmentIndex = tipIndex
        
        // Load default tip percentage for slider
        let tipPercent = defaults.double(forKey: "defaultTipPercent")
        tipSlider.value = Float(tipPercent * 100)
        tipSliderLabel.text = defaults.string(forKey: "tipSliderLabelText") ?? "5%"

        
        let controlSwitchIsOn = defaults.bool(forKey: "useControl")
        if controlSwitchIsOn {
            controlSwitch.isOn = true
            sliderSwitch.isOn = false
        }
        else {
            controlSwitch.isOn = false
            sliderSwitch.isOn = true
        }
        
    }
    
    // Update tip percentage upon modifying segmented control
    // Precondition: segmented control is switched on
    @IBAction func changeTipVal(_ sender: Any) {
        if controlSwitch.isOn {
        let tipIndex = tipControl.selectedSegmentIndex
            defaults.set(tipIndex, forKey: "defaultTipIndex")
            defaults.synchronize()
        }
    }
    
    // Update tip percentage upon modifying slider
    // Precondition: slider is switched on
    @IBAction func changeTipValWithSlider(_ sender: Any) {
        var tipPercentage = Int(tipSlider.value)
        tipPercentage = tipPercentage - tipPercentage % 5
        let tipPercentAsDouble = Double(tipPercentage)/100
        defaults.set(tipPercentAsDouble, forKey: "defaultTipPercent")
        tipSliderLabel.text = String(describing: tipPercentage) + "%"
        defaults.set(tipSliderLabel.text, forKey: "tipSliderLabelText")
        defaults.synchronize()
    }
    
    @IBAction func onControlSwitch(_ sender: Any) {
        if controlSwitch.isOn {
            controlSwitch.isOn = false
            sliderSwitch.isOn = true
        }
        else {
            controlSwitch.isOn = true
            sliderSwitch.isOn = false
        }
        defaults.set(controlSwitch.isOn, forKey: "useControl")
    }
    
    @IBAction func onSliderSwitch(_ sender: Any) {
        if sliderSwitch.isOn {
            sliderSwitch.isOn = false
            controlSwitch.isOn = true
        }
        else {
            sliderSwitch.isOn = true
            controlSwitch.isOn = false
        }
        defaults.set(controlSwitch.isOn, forKey: "useControl")
    }
    
}
