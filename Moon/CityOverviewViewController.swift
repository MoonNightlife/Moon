//
//  CityOverviewViewController.swift
//  Moon
//
//  Created by Evan Noble on 5/12/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import MapKit
import MaterialComponents
import Material
import iCarousel

class CityOverviewViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, BindableType {

    class func instantiateFromStoryboard() -> CityOverviewViewController {
        let storyboard = UIStoryboard(name: "MoonsView", bundle: nil)
        // swiftlint:disable:next force_cast
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! CityOverviewViewController
    }
    
    var viewModel: CityOverviewViewModel!
    
    @IBOutlet weak var goingCarouselHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var segmentControl: ADVSegmentedControl!
    @IBOutlet weak var goingCarousel: iCarousel!
    @IBOutlet weak var zoomToLocationButton: MDCFloatingButton!
    @IBOutlet weak var cityMapView: MKMapView!
    var locationManager: CLLocationManager?
    
    @IBAction func zoomToLocation(_ sender: Any) {
        locationManager?.startUpdatingLocation()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        
        cityMapView.delegate = self
        cityMapView.showsUserLocation = true
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager?.startUpdatingLocation()
        } else {
            locationManager?.requestLocation()
        }
        
        zoomToLocationButton.backgroundColor = .white
        let locationImage = #imageLiteral(resourceName: "Location").withRenderingMode(.alwaysTemplate).tint(with: .moonPurple)
        zoomToLocationButton.setImage(locationImage, for: .normal)
        
        goingCarousel.isHidden = true

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        for a in cityMapView.annotations {
            cityMapView.removeAnnotation(a)
        }
        addAnnotations()
    }
    
    func bindViewModel() {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("NotDetermined")
        case .restricted:
            print("Restricted")
        case .denied:
            print("Denied")
        case .authorizedAlways:
            print("AuthorizedAlways")
        case .authorizedWhenInUse:
            print("AuthorizedWhenInUse")
            locationManager!.startUpdatingLocation()
        }
    }
    
    func animateViewUp() {
        goingCarousel.isHidden = false
        
        UIView.animate(withDuration: Double(2.0), animations: {
            self.goingCarouselHeightConstraint.constant = 200
            self.view.layoutIfNeeded()
        })
    }
    
    func animateViewDown() {
        
        UIView.animate(withDuration: Double(2.0), animations: {
            self.goingCarouselHeightConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
        
        //goingCarousel.isHidden = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.first!
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 2000, 2000)
        cityMapView.setRegion(coordinateRegion, animated: true)
        locationManager?.stopUpdatingLocation()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        animateViewDown()
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        animateViewUp()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to initialize GPS: ", error.localizedDescription)
    }

    // MARK: - Mapview delegate methods
    // Creates the annotation with the correct image for how many users say they are going
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        let reuseIdentifier = "pin"
        
        var v = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? MKPinAnnotationView
        if v == nil {
            v = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            v!.canShowCallout = true
            
            let btn = UIButton(type: .detailDisclosure)
            v?.rightCalloutAccessoryView = btn
        } else {
            v!.annotation = annotation
        }
        
        //swiftlint:disable:next force_cast
        let customPointAnnotation = annotation as! BarAnnotation
        
        v?.pinTintColor = customPointAnnotation.tintColor
        v!.alpha = 1
        
        return v
    }
    
    func addAnnotations() {
        for data in fakeTopBars {
            let pointAnnotation = BarAnnotation()
            
            switch arc4random_uniform(3) {
            case 0:
                pointAnnotation.tintColor = UIColor.red
            case 1:
                pointAnnotation.tintColor = UIColor.yellow
            default:
                pointAnnotation.tintColor = UIColor.green
            }
            
            pointAnnotation.coordinate = data.coordinates
            pointAnnotation.title = data.barName
            pointAnnotation.placeID = "123123"
            pointAnnotation.subtitle = "Users Going: \(data.usersGoing)"
            let annotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: "pin")
            
            //swiftlint:disable:next force_cast
            self.cityMapView.addAnnotation(annotationView.annotation!)
        }
    }

}
