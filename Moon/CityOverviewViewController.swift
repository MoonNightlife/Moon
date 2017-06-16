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
    var screenHeight: CGFloat!
    
    @IBOutlet weak var goingCarouselHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var segmentControl: ADVSegmentedControl!
    @IBOutlet weak var goingCarousel: iCarousel!
    @IBOutlet weak var zoomToLocationButton: MDCFloatingButton!
    @IBOutlet weak var cityMapView: MKMapView!
    var locationManager: CLLocationManager?
    
    @IBAction func zoomToLocation(_ sender: Any) {
        locationManager?.startUpdatingLocation()
    }
    
    //data 
    var usersGoing = [FakeUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenHeight = self.view.frame.size.height
        
        usersGoing = createFakeUsers()
        
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
        
        prepareSegmentControl()
        prepareCarousel()

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
    
    func prepareSegmentControl() {
        //segment set up
        segmentControl.items = ["People Going", "Friends Going"]
        segmentControl.selectedLabelColor = .moonPurple
        segmentControl.borderColor = .clear
        segmentControl.backgroundColor = .clear
        segmentControl.selectedIndex = 0
        segmentControl.unselectedLabelColor = .lightGray
        segmentControl.thumbColor = .moonPurple
    }
    
    func prepareCarousel() {
        goingCarousel.delegate = self
        goingCarousel.dataSource = self
        
        goingCarousel.contentView.isHidden = true
        
        goingCarousel.bringSubview(toFront: segmentControl)
        goingCarousel.backgroundColor = .white
        goingCarousel.isPagingEnabled = true
        goingCarousel.type = .linear
        goingCarousel.bounces = false
        goingCarousel.reloadData()
    }
    
    func animateViewUp() {
        UIView.animate(withDuration: Double(0.3), animations: {
            self.goingCarouselHeightConstraint.constant = self.view.frame.height * 0.55
            self.view.layoutIfNeeded()
        })
        
        goingCarousel.contentView.isHidden = false
    }
    
    func animateViewDown() {
        UIView.animate(withDuration: Double(0.3), animations: {
            self.goingCarouselHeightConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
        
        goingCarousel.contentView.isHidden = true
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
            pointAnnotation.subtitle = "People Going: \(data.usersGoing)"
            let annotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: "pin")
            
            //swiftlint:disable:next force_cast
            self.cityMapView.addAnnotation(annotationView.annotation!)
        }
    }

}

extension CityOverviewViewController: iCarouselDelegate, iCarouselDataSource {
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == .spacing {
            return value * 1.1
        }
        
        return value
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return usersGoing.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        let view = setUpGoingView(index: index)
        
        return view
    }
    
    func setUpGoingView(index: Int) -> UIView {
        let size = screenHeight * 0.22
        //let size = self.view.frame.size.height * 0.22
        let frame = CGRect(x: self.view.frame.size.width / 2, y: 0, width: size + 20, height: size)
        let view = PeopleGoingCarouselView()
        view.frame = frame
        //view.initializeViewWith(user: usersGoing.value[index], index: index, viewProfile: viewModel.onShowProfile, likeActivity: viewModel.onLikeActivity, viewLikers: viewModel.onViewLikers)
        view.initFake(user: usersGoing[index], index: index)
        
        return view
    }

}
