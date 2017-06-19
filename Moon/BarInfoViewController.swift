//
//  BarInfoViewController.swift
//  Moon
//
//  Created by Evan Noble on 6/12/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import MapKit
import RxCocoa
import RxSwift
import Action
import Material

class BarInfoViewController: UIViewController, BindableType {

    var viewModel: BarInfoViewModel!
    private let bag = DisposeBag()
    
    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet weak var phoneNumberButton: UIButton!
    @IBOutlet weak var addressButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareBackButton()
        prepareWebsite()
        preparePhoneButton()
        prepareAddress()
    }
    
    func bindViewModel() {
        backButton.rx.action = viewModel.onBack()
        
        phoneNumberButton.rx.controlEvent(.touchUpInside).subscribe(viewModel.onCall.inputs).addDisposableTo(bag)
        viewModel.onCall.elements.subscribe(onNext: { [weak self] in
            self?.openURL(url: $0)
        })
        .addDisposableTo(bag)
        
        websiteButton.rx.controlEvent(UIControlEvents.touchUpInside).subscribe(viewModel.onViewWebsite.inputs).addDisposableTo(bag)
        viewModel.onViewWebsite.elements.subscribe(onNext: { [weak self] in
            self?.openURL(url: $0)
        })
        .addDisposableTo(bag)
        
        addressButton.rx.controlEvent(.touchUpInside).subscribe(viewModel.onViewAddress.inputs).addDisposableTo(bag)
        viewModel.onViewAddress.elements.subscribe(onNext: { [weak self] in
            self?.openURL(url: $0)
        })
        .addDisposableTo(bag)
        
        viewModel.addressString.drive(addressButton.rx.title(for: .normal)).addDisposableTo(bag)
        viewModel.phoneNumberString.drive(phoneNumberButton.rx.title(for: .normal)).addDisposableTo(bag)
        viewModel.websiteString.drive(websiteButton.rx.title(for: .normal)).addDisposableTo(bag)
    }
    
    fileprivate func openURL(url: URL?) {
        let application = UIApplication.shared
        if let url = url, application.canOpenURL(url) {
            application.open(url, options: [:], completionHandler: nil)
        }
    }

    fileprivate func openMapForPlace(address: String) {
        
        print(address)
        
        let latitude: CLLocationDegrees = 37.2
        let longitude: CLLocationDegrees = 22.9
        
        let regionDistance: CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "Place Name"
        mapItem.openInMaps(launchOptions: options)
    }

}

extension BarInfoViewController {
    
    fileprivate func prepareBackButton() {
        var image = Icon.close
        image = image?.tint(with: .moonRed)
        
        backButton.setImage(image, for: .normal)
    }
    
    fileprivate func preparePhoneButton() {
        phoneNumberButton.tintColor = .lightGray
        phoneNumberButton.titleLabel?.font = UIFont(name: "Roboto", size: 12)
    }
    
    fileprivate func prepareWebsite() {
        websiteButton.tintColor = .lightGray
        websiteButton.titleLabel?.font = UIFont(name: "Roboto", size: 12)
    }
    
    fileprivate func prepareAddress() {
        addressButton.tintColor = .lightGray
        addressButton.titleLabel?.font = UIFont(name: "Roboto", size: 12)
    }
}
