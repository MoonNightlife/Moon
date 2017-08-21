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
import NVActivityIndicatorView
import RxSwift
import RxCocoa
import Action

class CityOverviewViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, BindableType {

    class func instantiateFromStoryboard() -> CityOverviewViewController {
        let storyboard = UIStoryboard(name: "MoonsView", bundle: nil)
        // swiftlint:disable:next force_cast
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! CityOverviewViewController
    }
    
    var viewModel: CityOverviewViewModel!
    var screenHeight: CGFloat!
    var pinAnimation: NVActivityIndicatorView!
    var bag = DisposeBag()
    var bars = [TopBar]()
 
    @IBOutlet weak var goingCarouselHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var segmentControl: ADVSegmentedControl!
    @IBOutlet weak var goingCarousel: iCarousel!
    @IBOutlet weak var zoomToLocationButton: MDCFloatingButton!
    @IBOutlet weak var cityMapView: MKMapView!
    var locationManager: CLLocationManager?
    
    @IBAction func zoomToLocation(_ sender: Any) {
        dismissCarouselView()
        locationManager?.startUpdatingLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenHeight = self.view.frame.size.height
        
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
        addGestureReconizerToMap()
        displayEmptyViewText(text: "", carousel: goingCarousel)
    }
    
    func addGestureReconizerToMap() {
        let tapRec = UITapGestureRecognizer(target: self, action: #selector(self.dismissCarouselView))
        cityMapView.addGestureRecognizer(tapRec)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        for a in cityMapView.annotations {
            cityMapView.removeAnnotation(a)
        }
        viewModel.reloadBars.execute()
    }
    
    func bindViewModel() {
        viewModel.reloadBars.elements.subscribe(onNext: { [weak self] bars in
            self?.bars = bars
            self?.addAnnotations()
        })
        .addDisposableTo(bag)
        
        Observable.combineLatest(viewModel.getPeopleForBar.executing, viewModel.displayedUsers.asObservable())
            .subscribe(onNext: { [weak self] isExecuting, users in
                if !isExecuting && users.isEmpty {
                    if self?.segmentControl.selectedIndex == 0 {
                        self?.removeEmptyViewText(carousel: self!.goingCarousel)
                        self?.displayEmptyViewText(text: "Looks Like No People Are Going Tonight", carousel: self!.goingCarousel)
                    } else {
                        self?.removeEmptyViewText(carousel: self!.goingCarousel)
                        self?.displayEmptyViewText(text: "Looks Like No Friends Are Going Tonight", carousel: self!.goingCarousel)
                    }
                }
            })
            .addDisposableTo(bag)
        
        viewModel.displayedUsers.asObservable()
            .do(onNext: { [weak self] users in
                if users.isNotEmpty {
                     self?.removeEmptyViewText(carousel: self!.goingCarousel)
                }
            })
            .subscribe(onNext: { [weak self] _ in
                //self?.removeEmptyViewText(carousel: self!.goingCarousel)
                self?.goingCarousel.reloadData()
            })
            .addDisposableTo(bag)
        
        segmentControl.rx.controlEvent(UIControlEvents.valueChanged)
            .map({ [unowned self] _ in
                return UsersGoingType(rawValue: self.segmentControl.selectedIndex)
            })
            .filterNil()
            .bind(to: viewModel.selectedUserIndex)
            .addDisposableTo(bag)
        
    }
    
    deinit {
        print("deinit")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager?.requestWhenInUseAuthorization()
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
    
    func displayEmptyViewText(text: String, carousel: iCarousel) {
        let frame = CGRect(x: 0, y: carousel.frame.size.height / 2, width: carousel.frame.size.width, height: 30)
        let label = UILabel(frame: frame)
        label.textAlignment = .center
        label.textColor = .lightGray
        label.font = UIFont(name: "Roboto", size: 16)
        label.text = text
        label.tag = 5
        
        carousel.addSubview(label)
        carousel.bringSubview(toFront: label)
    }
    
    func removeEmptyViewText(carousel: iCarousel) {
        if let viewWithTag = carousel.viewWithTag(5) {
            viewWithTag.removeFromSuperview()
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
    
    func dismissCarouselView() {
        animateViewDown()
        
        if pinAnimation != nil {
            pinAnimation.stopAnimating()
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let id = (view.annotation as? BarAnnotation)?.placeID else {
            return
        }
        viewModel.getPeopleForBar.execute(id)
        viewModel.getFriendsForBar.execute(id)

        animateViewUp()
        
        let tempAnimation = animatePinWith(frame: view.frame, color: .moonPurple)
        pinAnimation = tempAnimation
        
        view.addSubview(pinAnimation)
        pinAnimation.startAnimating()
    }
    
    func animatePinWith(frame: CGRect, color: UIColor) -> NVActivityIndicatorView {
        let width = frame.size.width
        let height = frame.size.height
        let newFrame = CGRect(x: 0, y: height - 20, width: width, height: height)
        
        let view = NVActivityIndicatorView(frame: newFrame, type: .ballPulse, color: color, padding: CGFloat(10))
        
        return view
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
        var v = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        if v == nil {
            v = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            v!.canShowCallout = true
            
            var btn = UIButton(type: .detailDisclosure)
            btn.tintColor = .moonPurple
            if let id = (annotation as? BarAnnotation)?.placeID {
                btn.rx.action = viewModel.onView(barID: id)
            }
            v?.rightCalloutAccessoryView = btn
        } else {
            v!.annotation = annotation
            if let id = (annotation as? BarAnnotation)?.placeID, var btn = v?.rightCalloutAccessoryView as? UIButton {
                btn.rx.action = viewModel.onView(barID: id)
            }
        }
        
        //swiftlint:disable:next force_cast
        let customPointAnnotation = annotation as! BarAnnotation
    
        v?.image = customPointAnnotation.image
        v?.tintColor = customPointAnnotation.tintColor
        
        return v
    }
    
    func addAnnotations() {
        for bar in bars {
            if let lat = bar.lat, let long = bar.long {
                
                let pointAnnotation = BarAnnotation()
                let image = #imageLiteral(resourceName: "LocationIcon")
               
//                switch arc4random_uniform(3) {
//                case 0:
//                    image = #imageLiteral(resourceName: "RedPin")
//                case 1:
//                    image = #imageLiteral(resourceName: "YellowPin")
//                default:
//                    image = #imageLiteral(resourceName: "GreenPin")
//                }
                
                pointAnnotation.coordinate = CLLocationCoordinate2DMake(lat, long)
                pointAnnotation.title = bar.name
                pointAnnotation.placeID = bar.id
                pointAnnotation.image = image
                pointAnnotation.subtitle = "People Going: \(bar.usersGoing ?? 0)"
                
                let annotationView = MKAnnotationView(annotation: pointAnnotation, reuseIdentifier: "pin")
                
                //swiftlint:disable:next force_cast
                self.cityMapView.addAnnotation(annotationView.annotation!)
            }
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
        return viewModel.displayedUsers.value.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        let view = setUpGoingView(index: index)
        
        return view
    }
    
    func setUpGoingView(index: Int) -> UIView {
        let size = screenHeight * 0.22
        let frame = CGRect(x: self.view.frame.size.width / 2, y: 0, width: size + 20, height: size)
        let view = PeopleGoingCarouselView()
        view.frame = frame
        view.initializeView()
        populateGoing(peopleGoingView: view, index: index)
        
        return view
    }
    
    func populateGoing(peopleGoingView: PeopleGoingCarouselView, index: Int) {
        let activity = viewModel.displayedUsers.value[index]
        
        // Bind actions
        if let userID = activity.userID {
            
            let likeAction = viewModel.onLikeActivity(userID: userID)
            peopleGoingView.likeButton.rx.action = likeAction
            likeAction.elements.do(onNext: {
                peopleGoingView.toggleColorAndNumber()
            }).subscribe().addDisposableTo(peopleGoingView.bag)
            
            let hasLiked = viewModel.hasLikedActivity(activityID: userID)
            hasLiked.elements.do(onNext: { hasLiked in
                if hasLiked {
                    peopleGoingView.likeButton.tintColor = .red
                }
            }).subscribe().addDisposableTo(peopleGoingView.bag)
            hasLiked.execute()
            
            peopleGoingView.numberOfLikesButton.rx.action = viewModel.onViewLikers(userID: userID)
            
            peopleGoingView.imageView.gestureRecognizers?.first?.rx.event.subscribe(onNext: { [weak self] _ in
                self?.viewModel.onShowProfile(userID: userID).execute()
            }).addDisposableTo(peopleGoingView.bag)
            
            let downloader = viewModel.getProfileImage(id: userID)
            downloader.elements.bind(to: peopleGoingView.imageView.rx.image).addDisposableTo(peopleGoingView.bag)
            downloader.execute()
        }
        
        // Bind labels
        peopleGoingView.numberOfLikesButton.title = "\(activity.numLikes ?? 0)"
        let nameLabel = peopleGoingView.bottomToolbar.leftViews[0] as? UILabel
        nameLabel?.text = activity.userName
        
    }

}
