//
//  ViewController.swift
//  Moon
//
//  Created by Evan Noble on 4/16/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import Material

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: TextField!
    @IBOutlet weak var passwordTextField: TextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        setUpLoginView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        let searchController = SearchBarViewController(rootViewController: MasterViewController.instantiateFromStoryboard())
//        self.present(searchController, animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setUpLoginView() {
        
        //Email Text Field Set Up
        emailTextField.dividerNormalColor = .white
        emailTextField.dividerActiveColor = .white
        emailTextField.placeholder = "email"
        emailTextField.placeholderActiveColor = .white
        emailTextField.placeholderNormalColor = .lightGray
        emailTextField.textColor = .white
        
        //Password Text Field Set Up
        passwordTextField.dividerNormalColor = .white
        passwordTextField.dividerActiveColor = .white
        passwordTextField.placeholder = "password"
        passwordTextField.placeholderActiveColor = .white
        passwordTextField.placeholderNormalColor = .lightGray
        passwordTextField.textColor = .white
        
        //Login Button Set Up
        loginButton.backgroundColor = .white
        loginButton.setTitleColor(.moonBlue, for: .normal)
        loginButton.layer.cornerRadius = 5
        
        //Sign Up Button Set Up
        signUpButton.backgroundColor = .white
        signUpButton.setTitleColor(.moonGreen, for: .normal)
        signUpButton.layer.cornerRadius = 5
    }
}
