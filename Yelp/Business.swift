//
//  Business.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class Business: NSObject, MKAnnotation {
    let name: String?
    let address: String?
    let imageURL: URL?
    let categories: String?
    let distance: String?
    let ratingImageURL: URL?
    let reviewCount: NSNumber?
    let location: CLLocation?
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        
        var imageURLString = dictionary["image_url"] as? String
        
        let endIndex = imageURLString?.index((imageURLString?.endIndex)!, offsetBy: -6)
        var truncatedString = imageURLString?.substring(to: endIndex!)
        truncatedString = truncatedString! + "l.jpg"
        imageURLString = truncatedString!
        
        if imageURLString != nil {
            imageURL = URL(string: imageURLString!)!
        } else {
            imageURL = nil
        }
        
        let location = dictionary["location"] as? NSDictionary
        var address = ""
        if location != nil {
            let addressArray = location!["address"] as? NSArray
            if addressArray != nil && addressArray!.count > 0 {
                address = addressArray![0] as! String
            }
            
            let neighborhoods = location!["neighborhoods"] as? NSArray
            if neighborhoods != nil && neighborhoods!.count > 0 {
                if !address.isEmpty {
                    address += ", "
                }
                address += neighborhoods![0] as! String
            }
        }
        
        let coordinate = location?["coordinate"] as? NSDictionary
        let latitude = coordinate?["latitude"] as? Double
        let longitude = coordinate?["longitude"] as? Double
        self.location = CLLocation(latitude: latitude!, longitude: longitude!)
        self.coordinate = CLLocationCoordinate2D(latitude: (self.location?.coordinate.latitude)!, longitude: (self.location?.coordinate.longitude)!)
        
        self.address = address
        self.title = self.name
        self.subtitle = self.address

        let categoriesArray = dictionary["categories"] as? [[String]]
        if categoriesArray != nil {
            var categoryNames = [String]()
            for category in categoriesArray! {
                let categoryName = category[0]
                categoryNames.append(categoryName)
            }
            categories = categoryNames.joined(separator: ", ")
        } else {
            categories = nil
        }
        
        let distanceMeters = dictionary["distance"] as? NSNumber
        if distanceMeters != nil {
            let milesPerMeter = 0.000621371
            distance = String(format: "%.2f mi", milesPerMeter * distanceMeters!.doubleValue)
        } else {
            distance = nil
        }
        
        let ratingImageURLString = dictionary["rating_img_url_large"] as? String
        if ratingImageURLString != nil {
            ratingImageURL = URL(string: ratingImageURLString!)
        } else {
            ratingImageURL = nil
        }
        
        reviewCount = dictionary["review_count"] as? NSNumber
    }
    
    class func businesses(array: [NSDictionary]) -> [Business] {
        var businesses = [Business]()
        for dictionary in array {
            let business = Business(dictionary: dictionary)
            businesses.append(business)
        }
        return businesses
    }
    
    class func searchWithTerm(term: String, offset: Int?, categories: [String]?, completion: @escaping ([Business]?, Error?) -> Void) {
        _ = YelpClient.sharedInstance.searchWithTerm(term, offset: offset, categories: categories, completion: completion)
    }
    
    class func searchWithTerm(term: String, offset: Int?, sort: YelpSortMode?, categories: [String]?, deals: Bool?, completion: @escaping ([Business]?, Error?) -> Void) -> Void {
        _ = YelpClient.sharedInstance.searchWithTerm(term, offset: offset, sort: sort, categories: categories, deals: deals, completion: completion)
    }
}
