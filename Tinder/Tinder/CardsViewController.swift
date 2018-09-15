//
//  CardsViewController.swift
//  Tinder
//
//  Created by admin on 4/26/17.
//  Copyright © 2017 JS. All rights reserved.
//

import UIKit

class CardsViewController: UIViewController {

    @IBOutlet weak var cardImage: UIImageView!

    var cardInitialCenter: CGPoint!
    var cardRight: CGPoint!
    var cardLeft: CGPoint!
    
    var dir = 1 as CGFloat
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cardRight = CGPoint(x: 2*self.view.bounds.width, y: self.view.bounds.height/2)
        cardLeft = CGPoint(x: -2*self.view.bounds.width, y: self.view.bounds.height/2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func didPan(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: view)
        let location = sender.location(in: cardImage)
        
        if sender.state == .began {
            cardInitialCenter = cardImage.center
            
            if (location.y > cardImage.bounds.height/2) {
                dir = -1
            }
            else {
                dir = 1
            }
            
            
            
        } else if sender.state == .changed {
            
            cardImage.center = CGPoint(x: cardInitialCenter.x + translation.x, y: cardInitialCenter.y)

            if (translation.x > 0) {
                cardImage.transform = cardImage.transform.rotated(by: dir * CGFloat(M_PI/180))
            }
            else {
                cardImage.transform = cardImage.transform.rotated(by: dir * -CGFloat(M_PI/180))
            }
            
            
        } else if sender.state == .ended {
            
            if (translation.x > 50) {
                UIView.animate(withDuration:0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] ,
                               animations: { () -> Void in
                                self.cardImage.center = self.cardRight
                }, completion: nil)
            }
            else if (translation.x < -50) {
                UIView.animate(withDuration:0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] ,
                               animations: { () -> Void in
                                self.cardImage.center = self.cardLeft
                }, completion: nil)
            }
            else {
                UIView.animate(withDuration:0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] ,
                               animations: { () -> Void in
                                self.cardImage.transform = CGAffineTransform.identity
                                self.cardImage.center = self.cardInitialCenter
                }, completion: nil)
                
            }
            
        }
        
    }
    
    
    @IBAction func onTap(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "toProfile", sender: self)
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    //}
 

}
