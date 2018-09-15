//
//  MapViewController.swift
//  Yelp
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var businesses: [Business]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.navigationController?.navigationBar.tintColor = UIColor.white

        self.mapView.delegate = self
        
        // Start location: San Francisco
        let startLocation = CLLocation(latitude: 37.7833, longitude: -122.4167)
        goToLocation(location: startLocation)
        
        if businesses != nil {
            for business in businesses {
                mapView.addAnnotation(business)
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func goToLocation(location: CLLocation) {
        let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 1000, 1000)
        mapView.setRegion(region, animated: false)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotation") as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "annotation")
            
            let leftImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            let business = annotation as? Business
            leftImage.setImageWith((business?.imageURL!)!)
            annotationView?.leftCalloutAccessoryView = leftImage
            
            let detailsButton = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = detailsButton
            
            
            annotationView?.isEnabled = true
            annotationView?.canShowCallout = true
        }
        else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        self.performSegue(withIdentifier: "detailsSegue", sender: view.annotation)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailsSegue" {
            if let detailsVC = segue.destination as? DetailsViewController {
                detailsVC.business = sender as? Business
            }
        }
    }
    
}
