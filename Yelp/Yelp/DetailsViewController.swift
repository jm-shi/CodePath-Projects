//
//  DetailsViewController.swift
//  Yelp
//

import UIKit
import MapKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var priceRangeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    
    var business: Business!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.title = business.name
        
        nameLabel.text = business.name
        photoImageView.setImageWith(business.imageURL!)
        categoriesLabel.text = business.categories
        addressLabel.text = business.address
        reviewCountLabel.text = "\(business.reviewCount!) Reviews"
        ratingImageView.setImageWith(business.ratingImageURL!)
        distanceLabel.text = business.distance
    }

}
