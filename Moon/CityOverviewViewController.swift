//
//  CityOverviewViewController.swift
//  Moon
//
//  Created by Evan Noble on 5/12/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import MapKit

class CityOverviewViewController: UIViewController {

    class func instantiateFromStoryboard() -> CityOverviewViewController {
        let storyboard = UIStoryboard(name: "MoonsView", bundle: nil)
        // swiftlint:disable:next force_cast
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! CityOverviewViewController
    }
    
    @IBOutlet weak var cityMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
