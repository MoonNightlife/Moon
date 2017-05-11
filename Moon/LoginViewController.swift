//
//  ViewController.swift
//  Moon
//
//  Created by Evan Noble on 4/16/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    let masterControllerSegueIdenifier = "loginToMaster"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        performSegue(withIdentifier: masterControllerSegueIdenifier, sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
