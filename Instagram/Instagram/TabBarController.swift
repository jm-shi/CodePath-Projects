//
//  TabBarController.swift
//  Instagram
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.barTintColor = UIColor(red: 0.1, green: 0.11, blue: 0.13, alpha: 1.0)
        self.tabBar.tintColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
